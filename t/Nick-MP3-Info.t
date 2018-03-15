use strict;
use warnings;

use Test::More;

our $CLASS;

use lib 't/lib';
use Nick::MP3::Test::Files '@TEST_FILES';

BEGIN {
    plan tests => 2 + ( @TEST_FILES * 19 );
    $CLASS = 'Nick::MP3::Info';
    use_ok $CLASS => qw(
        @ID_FIELDS $EXCLUDE_HEADER_FRAME
    );
}

my( $info, $lame, $length, $br_type );

{
    $info = $CLASS -> new(
        \do{ $TEST_FILES[0]{'data'} }
    );
    $info -> {'hack'} = 1;
    my $new_info = $CLASS -> new( $info );
    ok(
        $new_info -> {'hack'},
        'instantiate with a Info object'
    );
}

my $test_field = $ID_FIELDS[0];
our @header_methods = qw( bitrate layer sample_rate );
foreach my $test ( @TEST_FILES ) {
    note( $test -> {'file'} );
    isa_ok(
        (
            $info = $CLASS -> new(
                \do{ $$test{'data'} }
            )
        ) => $CLASS
    ) or next;
    is(
        $info -> get_field( $test_field ),
        $$test{'header'}{$test_field},
        'get_field'
    );
    is(
        $info -> get_fields( $test_field ),
        $$test{'header'}{$test_field},
        'get_fields (one)'
    );
    is_deeply(
        [ $info -> get_fields() ],
        [ @{ $$test{'header'} }{ @ID_FIELDS } ],
        'get_fields (all)'
    );
    $br_type = $$test{'br_header_type'};
    is(
        $info -> bitrate_header_type(),
        $br_type,
        'bitrate_header_type'
    );
    is(
        $info -> frame_samples(),
        $$test{'frame_samples'},
        'frame_samples'
    );
    $lame = exists $$test{'lame'};
    is(
        $info -> lame_version(),
        ( $lame
            ? $$test{'lame'}{'version'}
            : undef
        ),
        'lame_version'
    );
    is_deeply(
        $info -> lame_replay_gain(),
        ( $lame
            ? { map
                { $_ => $$test{'lame'}{$_} }
                grep(
                    exists( $$test{'lame'}{$_} ),
                    qw( track album )
                )
            }
            : undef
        ),
        'lame_replay_gain'
    );
    is(
        $info -> is_vbr(),
        $br_type eq 'Xing' ? 1 : 0,
        'is_vbr'
    );
    is(
        join( '-', map $info -> $_(), @header_methods ),
        join( '-', map $$test{'header'}{$_}, @header_methods ),
        'header methods'
    );
    is(
        $info -> total_bytes(),
        length( $$test{'data'} ),
        'total_bytes'
    );
    is(
        $info -> leading_bytes(),
        $$test{'leading_bytes'},
        'leading_bytes'
    );
    is(
        $info -> trailing_bytes(),
        $$test{'trailing_bytes'},
        'trailing_bytes'
    );
    is(
        $info -> audio_offset_bytes(),
        $$test{'leading_bytes'} + (
            $br_type ? $$test{'frames'}[0][1] : 0
        ),
        'audio_offset_bytes'
    );
    is(
        $info -> frames(),
        ( $br_type
            ? $$test{$br_type}{'frames'}
            : do {
                $length = length( $$test{'data'} )
                    - $$test{'leading_bytes'}
                    - $$test{'trailing_bytes'};
                int(
                    $length / $$test{'header'}{'frame_length'}
                );
            }
        ),
        'frames (inaccurate)'
    );
    is(
        $info -> audio_bytes(),
        ( $br_type
            ? $$test{$br_type}{'bytes'}
            : $length
        ),
        'audio_bytes (inaccurate)'
    );
    $br_type && ! $EXCLUDE_HEADER_FRAME
        and $br_type = 0;
    is(
        $info -> frames( 1 ),
        scalar(
            @{ $$test{'frames'} }
        ) - (
            $br_type ? 1 : 0
        ),
        'frames (accurate)'
    );
    is(
        $info -> audio_bytes( 1 ),
        do {
            $length = 0;
            for (
                @{ $$test{'frames'} }[
                    ( $br_type ? 1 : 0 )
                        .. $#{ $$test{'frames'} }
                ]
            ) {
                $length += $$_[1];
            }
            $length;
        },
        'audio_bytes (accurate)'
    );
    is(
        $info -> samples(),
        $$test{'samples'},
        'samples'
    );
}

1;
