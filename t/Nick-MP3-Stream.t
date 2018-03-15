use strict;
use warnings;

use Test::More;
use IO::String;
use Digest::MD5 'md5_base64';

our $CONSUME_BR_HEADER;

use Nick::MP3::Frame '$BLOCK_SIZE';

use lib 't/lib';
use Nick::MP3::Test::Files '@TEST_FILES';

BEGIN {
    plan tests => 3 + ( @TEST_FILES * 4 );
    use_ok 'Nick::MP3::Stream' => '$CONSUME_BR_HEADER';
    $CONSUME_BR_HEADER = 0;
}

note(
    "Changing BLOCK_SIZE from $BLOCK_SIZE to "
        . ( $BLOCK_SIZE = 160 )
);

for my $test ( @TEST_FILES ) {
    note( $$test{'file'} );
    my $fh = IO::String -> new(
        \do{ $$test{'data'} }
    );
    my $stream = Nick::MP3::Stream -> new( $fh );
    my( $pos, $frame, @frames );
    for ( ;; ) {
        $pos = $stream -> position();
        $frame = $stream -> get_frame() or last;
        push @frames => [
            $pos, length( $frame ), md5_base64( $frame )
        ];
    }
    my $tframes = $$test{'frames'};
    my( @spos, @want_spos );
    for ( my $i = 0; $i < $#$tframes; $i ++ ) {
        $fh -> seek(
            $tframes -> [$i][0] + 1, 0
        );
        $stream -> sync_new_position();
        push @spos => $stream -> position();
        push @want_spos => $tframes -> [ $i + 1 ][0];
    }
    $fh -> close();
    is_deeply(
        \@frames, $tframes, 'get_frame'
    );
    is_deeply(
        \@spos, \@want_spos, 'sync_new_position'
    );
    is(
        ( $$test{'br_header_type'}
            ? $stream -> bitrate_header() -> type()
            : ''
        ),
        $$test{'br_header_type'},
        'bitrate_header'
    );
    my $xing = $stream -> vbr_header();
    is_deeply(
        ( $xing
            ? {
                map {
                    $_ => (
                        $_ eq 'toc'
                        ? [ $xing -> $_() ]
                        : $xing -> $_()
                    ),
                } map(
                    { $_, $_ . '_offset' }
                    qw( bytes frames scale toc )
                )
            } : undef
        ), (
            exists( $$test{'Xing'} )
            ? $$test{'Xing'}
            : undef
        ),
        'vbr_header'
    );
}

{
    my( $VBR_FILE ) = grep(
        $$_{'br_header_type'} eq 'Xing', @TEST_FILES
    );
    my $stream = Nick::MP3::Stream -> new(
        IO::String -> new(
            \do{ $$VBR_FILE{'data'} }
        )
    );
    my( $method, $move_frames );
    my $last_frame_idx = $#{ $$VBR_FILE{'frames'} };
    my $num_frames = @{ $$VBR_FILE{'frames'} };
    my $frame_idx = -1;
    for (
        [ 'skip_frames' => $num_frames ],
        [ 'rewind_frames' => -$num_frames + 1 ],
    ) {
        ( $method, $move_frames ) = @$_;
        $frame_idx += $move_frames;
        $stream -> skip_frames( $move_frames );
        my $frame = $stream -> get_frame();
        my @frame_id = (
            length( $frame ), md5_base64( $frame )
        );
        unshift( @frame_id =>
            $stream -> position() - length( $frame )
        );
        is_deeply(
            \@frame_id,
            $$VBR_FILE{'frames'}[$frame_idx],
            $method
        );
    }
}
