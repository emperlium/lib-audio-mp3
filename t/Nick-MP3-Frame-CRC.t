use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Nick::MP3::Test::GainFiles '@TEST_GAIN_FILES';

our @TEST_FRAMES;

BEGIN {
    @TEST_FRAMES = @{
        ( grep ! $$_{'header'}{'protection_bit'}, @TEST_GAIN_FILES )[0]
            -> {'original_frames'}
    };
    plan tests => 1 + @TEST_FRAMES;
    use_ok 'Nick::MP3::Frame::CRC' => 'frame_crc';
}

my $cnt;
for my $frame ( @TEST_FRAMES ) {
    is(
        unpack( 'n', frame_crc( $frame ) ),
        unpack( 'n', substr $frame, 4, 2 ),
        'Frame ' . ( ++$cnt )
    );
}
