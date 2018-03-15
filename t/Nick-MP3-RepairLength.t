use strict;
use warnings;

use Test::More 'tests' => 7;

use lib 't/lib';
use Nick::MP3::Test::Files '@TEST_FILES';

BEGIN {
    use_ok 'Nick::MP3::RepairLength';
}

my $TEST_FILE = $TEST_FILES[0];

my $repair;
if (
    $repair = Nick::MP3::RepairLength -> new(
        \do{ $$TEST_FILE{'data'} }
    )
) {
    ok(
        $repair -> ok(),
        'Good data needs no updates'
    );
} else {
    fail 'Unable to make an object with good test data';
}

{
    my $frames = scalar(
        @{ $$TEST_FILE{'frames'} }
    ) - 3;
    my( $bytes, $from_bytes, $to_bytes ) = ( 0, 0, 0 );
    for (
        ( $$TEST_FILE{'br_header_type'} ? 1 : 0 ) .. $frames
    ) {
        $to_bytes = $$TEST_FILE{'frames'}[$_];
        $bytes += $$to_bytes[1];
        if ( ! $_ ) {
            $from_bytes = $$to_bytes[0];
        } elsif ( $_ == $frames ) {
            $to_bytes = $$to_bytes[0] + $$to_bytes[1] - $from_bytes;
        }
    }
    my $data = substr(
        $$TEST_FILE{'data'}, $from_bytes, $to_bytes
    );
    if (
        $repair = Nick::MP3::RepairLength -> new( \$data )
    ) {
        if (
            ok ! $repair -> ok(), 'Bad data needs updates'
        ) {
            $repair -> fix();
            my $header = $$TEST_FILE{
                $$TEST_FILE{'br_header_type'}
            };
            my $header_pos = $$TEST_FILE{'leading_bytes'};
            for (
                [ 'bytes' => $bytes ],
                [ 'frames' => $frames ]
            ) {
                my( $type, $want ) = @$_;
                is(
                    unpack( 'N',
                        substr(
                            $data,
                            $header_pos + $$header{ $type . '_offset' },
                            4
                        )
                    ) => $want,
                    "fixed $type"
                )
            }
            isnt(
                unpack( 'n',
                    substr(
                        $data,
                        $header_pos + $$TEST_FILE{'lame'}{'tag_crc_offset'},
                        2
                    )
                ),
                $$TEST_FILE{'lame'}{'tag_crc'},
                'LAME CRC changed'
            );
        }
    } else {
        fail 'Unable to make an object with bad test data';
    }
}

{
    $$TEST_FILE{'br_header_type'} eq 'Xing'
        or fail 'Including header test needs a Xing header';
    my $data = $$TEST_FILE{'data'};
    my $header_pos = $$TEST_FILE{'leading_bytes'};
    my $info = Nick::MP3::Info -> new( \$data );
    my $br_header = $info -> bitrate_header();
    for (
        [
            $br_header -> bytes_offset(),
            $br_header -> bytes(
                length( $data ) - (
                    $header_pos + $$TEST_FILE{'trailing_bytes'}
                )
            )
        ], [
            $br_header -> frames_offset(),
            $br_header -> frames(
                scalar @{ $$TEST_FILE{'frames'} }
            )
        ]
    ) {
        substr( $data, $$_[0], length( $$_[1] ) ) = $$_[1];
    }
    if (
        $repair = Nick::MP3::RepairLength -> new( \$data )
    ) {
        ok(
            $repair -> ok(),
            'Header frame taken into account'
        );
    } else {
        fail "Header frame wasn't taken into account";
    }
}

1;
