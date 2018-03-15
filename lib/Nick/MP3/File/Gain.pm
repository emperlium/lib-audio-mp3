package Nick::MP3::File::Gain;

use strict;
use warnings;

use base 'Nick::MP3::File';

use Nick::MP3::Frame::GlobalGain qw(
    set_decibels apply_gain
);
use Nick::Error ':try';

our( $FRAME, $REPORT_NO_GAIN );

BEGIN {
    $REPORT_NO_GAIN = 1;
}

sub new {
    my( $class, $file, $gain ) = @_;
    try {
        set_decibels( $gain );
    } catch Nick::Error with {
        $REPORT_NO_GAIN and $class -> log(
            "Gain of ${gain}dB seems to translate to 0, falling back on Nick::MP3::File"
        );
        $class = 'Nick::MP3::File';
    };
    return $class -> SUPER::new( $file );
}

sub get_frame {
    $FRAME = $_[0]{'stream'} -> get_frame()
        or return undef;
    apply_gain( $FRAME );
    $_[0]{'got_frames'} ++;
    return $FRAME;
}

1;
