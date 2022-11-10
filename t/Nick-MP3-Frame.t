use strict;
use warnings;

use Test::More;
use IO::String;

use lib 't/lib';

our( $FRAME_LENGTH, @FILES );

BEGIN {
    use Nick::MP3::Test::Files '@TEST_FILES';
    @FILES = grep $$_{'file'} ne 'The Third Policeman.mp3', @TEST_FILES;
    plan tests => 2 + ( @FILES * 5 );
    use_ok 'Nick::MP3::Frame' => qw(
        find_frame header frame_time frame_samples
        find_bitrate_type count_frames $FRAME_LENGTH
    );
}

for my $test ( @FILES ) {
    my $data = $$test{'data'};
    my( $pos, $head, @frames );
    note( $$test{'file'} );
    for ( ;; ) {
        defined(
            $pos = find_frame( $data, $pos )
        ) && $pos >= 0
            or last;
        unless ( @frames ) {
            is(
                frame_samples(),
                $$test{'frame_samples'},
                'frame_samples'
            );
            is(
                frame_time(),
                $$test{'frame_time'},
                'frame_time'
            );
            is_deeply(
                header(),
                $$test{'header'},
                'header'
            );
            my $bitrate_type = find_bitrate_type(
                substr $data, $pos, $FRAME_LENGTH
            );
            is(
                $bitrate_type ? $bitrate_type -> type() : '',
                join( '-',
                    grep(
                        exists( $$test{$_} ),
                        qw( Xing Info )
                    )
                ), 'find_bitrate_type'
            );
        }
        push @frames, [ $pos, $FRAME_LENGTH ];
        $pos += $FRAME_LENGTH;
    }
    is_deeply(
        \@frames, [ map
            [ @$_[ 0, 1 ] ],
            @{ $$test{'frames'} }
        ], 'frames'
    );
}

{
    my $file = $TEST_FILES[0];
    my $data = $$file{'data'};
    is(
        count_frames(
            IO::String -> new( $data ),
            length( $data )
        ),
        scalar(
            @{ $$file{'frames'} }
        ),
        'count_frames'
    );
}
