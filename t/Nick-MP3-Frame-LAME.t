use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Nick::MP3::Test::Headers '@TEST_HEADERS';

our( @RG_TESTS, @ED_TESTS, @DELAY_TESTS, @PADDING_TESTS );

BEGIN {
    @TEST_HEADERS = grep(
        exists( $$_{'lame'} ),
        @TEST_HEADERS
    );
    @RG_TESTS = (
        [ '0010111001111101' => [ 'track' => -12.5  ] ],
        [ '0100100000010100' => [ 'album' => 2      ] ],
        [ '0010111000111001' => [ 'track' => -5.7   ] ],
        [ '0010110111111111' => [ 'track' => 51.1   ] ]
    );
    @ED_TESTS = (
        [ '011011000001001011010010' => [ 1729, 722     ] ], # 0
        [ '001001000000010011010111' => [ 576,  1239    ] ], # 1
        [ '001001000000010011111110' => [ 576,  1278    ] ], # 2
        [ '111111111111111111111111' => [ 4095, 4095    ] ], # 3
        [ '111111111111000000000000' => [ 4095, 0       ] ], # 4
        [ '000000000000111111111111' => [ 0,    4095    ] ], # 5
        [ '010101010101010101010101' => [ 1365, 1365    ] ], # 6
        [ '101010101010010101010101' => [ 2730, 1365    ] ], # 7
        [ '000000000000000000000000' => [ 0,    0       ] ]  # 8
    );
    @DELAY_TESTS = (
        [ 3 => 5 ],
        [ 6 => 7 ]
    );
    @PADDING_TESTS = (
        [ 1 => 2 ],
        [ 3 => 4 ]
    );
    plan tests => 4
        + ( @TEST_HEADERS * 2 )
        + @RG_TESTS
        + ( @ED_TESTS * 3 )
        + @DELAY_TESTS
        + @PADDING_TESTS;
    use_ok 'Nick::MP3::Frame::LAME';
}

use Nick::MP3::Frame 'find_bitrate_type';

our @METHODS = map(
    { $_, $_ . '_offset' }
    qw( version tag_version vbr_method peak_signal_amplitude tag_crc )
);

is(
    MockLAME -> new() -> version( 'mock' ),
    ' mock',
    'set version'
);

for ( 0 .. $#RG_TESTS ) {
    my $method = sprintf(
        'replay_gain_%d', ( $_ % 2 ) + 1
    );
    is_deeply(
        [
            MockLAME -> new(
                $method => pack(
                    'B16', $RG_TESTS[$_][0]
                )
            ) -> $method()
        ] => $RG_TESTS[$_][1],
        sprintf( '%s %d', $method, $_ + 1 )
    );
}

for ( 0 .. $#ED_TESTS ) {
    my $lame = MockLAME -> new(
        'encoder_delays' => pack(
            'B24', $ED_TESTS[$_][0]
        )
    );
    is_deeply(
        [ $lame -> encoder_delays() ] => $ED_TESTS[$_][1],
        sprintf( 'encoder_delays %d', $_ + 1 )
    );
    is(
        $lame -> encoder_delay(), $ED_TESTS[$_][1][0],
        sprintf( 'encoder_delay %d', $_ + 1 )
    );
    is(
        $lame -> encoder_padding(), $ED_TESTS[$_][1][1],
        sprintf( 'encoder_padding %d', $_ + 1 )
    );
}

{
    my( $from, $to );
    for ( 0 .. $#DELAY_TESTS ) {
        ( $from, $to ) = @ED_TESTS[
            @{ $DELAY_TESTS[$_] }
        ];
        is(
            sprintf( '%016B',
                unpack( 'n',
                    MockLAME -> new(
                        'encoder_delays' => pack(
                            'B24', $$to[0]
                        )
                    ) -> encoder_delay(
                        $$from[1][0]
                    )
                ),
            ),
            substr( $$from[0], 0, 16 ),
            sprintf( 'set encoder_delay %d', $_ + 1 )
        );
    }
    for ( 0 .. $#PADDING_TESTS ) {
        ( $from, $to ) = @ED_TESTS[
            @{ $PADDING_TESTS[$_] }
        ];
        is(
            sprintf( '%016B',
                unpack( 'n',
                    MockLAME -> new(
                        'encoder_delays' => pack(
                            'B24', $$from[0]
                        )
                    ) -> encoder_padding(
                        $$to[1][1]
                    )
                ),
            ),
            substr( $$to[0], 8, 16 ),
            sprintf( 'set encoder_padding %d', $_ + 1 )
        );
    }
}

{
    my( $lame, %want );
    foreach my $test ( @TEST_HEADERS ) {
        note( $test -> {'file'} );
        $lame = Nick::MP3::Frame::LAME -> new(
            find_bitrate_type( $test -> {'data'} )
        );
        isa_ok(
            $lame => 'Nick::MP3::Frame::LAME'
        ) or next;
        is_deeply(
            {
                map( { $_ => $lame -> $_() } @METHODS ),
                %{ $lame -> replay_gain() },
                'encoder_delays' => [ $lame -> encoder_delays() ]
            } => $test -> {'lame'},
            'method values'
        );
    }
}

{
    my $lame = MockLAME -> new(
        'tag_crc' => pack( 'n', 123 )
    );
    is(
        $lame -> tag_crc(),
        123,
        'get tag_crc'
    );
    substr(
        $$lame{'frame'}, 0, 10
    ) = join( '', 0 .. 9 );
    is(
        unpack(
            'n', $lame -> tag_crc( 1 )
        ),
        6028,
        'set tag_crc'
    );
}

package MockLAME;

our $PARENT;

BEGIN {
    $PARENT = 'Nick::MP3::Frame::LAME';
}

use base $PARENT;

sub new {
    my( $class, $type, $data ) = @_;
    my $self = bless {
        'offset'    => 0,
        'frame'     => "\x00" x 192,
    } => $PARENT;
    if ( $type ) {
        $type .= '_offset';
        substr(
            $self -> {'frame'},
            $self -> $type(),
            length( $data )
        ) = $data;
    }
    return $self;
}

1;
