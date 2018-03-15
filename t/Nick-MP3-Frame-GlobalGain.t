use strict;
use warnings;

use Test::More;

our $GLOBAL_GAIN_TO_APPLY;

use lib 't/lib';
use Nick::MP3::Test::GainFiles qw(
    @TEST_GAIN_FILES $TEST_APPLIED_GAIN
);

BEGIN {
    plan tests => 1 + (
        @{ $TEST_GAIN_FILES[0]{'original_frames'} } * @TEST_GAIN_FILES
    );
    use_ok 'Nick::MP3::Frame::GlobalGain' => qw(
        set_global_gain apply_gain
    );
}

set_global_gain( $TEST_APPLIED_GAIN );

my @fields = qw( header original_frames mp3gain_frames );

for my $test ( @TEST_GAIN_FILES ) {
    my( $header, $original, $mp3gain ) = @$test{ @fields };
    my $name = join( '-', %$header, 'frame', '' );
    for ( my $i = 0; $i <= $#$original; $i++ ) {
        apply_gain( $$original[$i] );
        is_deeply(
            [ unpack 'C*', $$original[$i] ],
            [ unpack 'C*', $$mp3gain[$i] ],
            $name . ( $i + 1 )
        );
    }
}
