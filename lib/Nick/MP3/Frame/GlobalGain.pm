package Nick::MP3::Frame::GlobalGain;

use strict;
use warnings;

use base 'Exporter';

our(
    @EXPORT_OK, $GLOBAL_GAIN, @SKIP_CHANNELS,
    @SKIP_POST, $DB_TO_GAIN,
    $header, $ver_idx, $crc_flag, $stereo,
    $short, $gain, $bit_skip, $byte_off,
    $bit_off, $post_skip
);

use Nick::Error;
use Nick::MP3::Frame::CRC 'frame_crc';

BEGIN {
    @EXPORT_OK = qw(
        set_global_gain set_decibels apply_gain
    );
    $GLOBAL_GAIN = 0;
    @SKIP_CHANNELS = (
        [ 1, 2 ], #MPEG2*
        [ 9, 11 ]  #MPEG1
    );
    @SKIP_POST = (
        42, #MPEG2*
        38  #MPEG1
    );
    $DB_TO_GAIN = 5 * ( log(2) / log(10) );
}

sub set_global_gain {
    $_[0] or Nick::Error -> throw(
        q{There's not much point setting a gain of 0}
    );
    $_[0] >= -255 && $_[0] <= 255
        or Nick::Error -> throw(
            "Value $_[0] should be between (+-)255"
        );
    $GLOBAL_GAIN = $_[0];
}

sub set_decibels {
    $_[0] or Nick::Error -> throw(
        q{There's not much point setting a gain of 0}
    );
    my $gain = $_[0] / $DB_TO_GAIN;
    if ( abs( $gain ) - int( abs $gain ) < 0.5 ) {
        $gain = int( $gain );
    } else {
        $gain = int( $gain ) + ( $gain < 0 ? -1 : 1 );
    }
    set_global_gain( $gain );
}

sub apply_gain {
    $header = unpack( 'N', substr $_[0], 0, 4 );
    $ver_idx = (
        ( $header >> 19 ) & 3
    ) == 3 ? 1 : 0;
    $crc_flag = ( $header >> 16 ) & 1;
    $stereo = (
        ( $header >> 6 ) & 3
    ) == 3 ? 0 : 1;
    $post_skip = $SKIP_POST[$ver_idx];
    $bit_skip = $ver_idx
        + $SKIP_CHANNELS[$ver_idx][$stereo]
        + ( $crc_flag ? 40 : 56 );
    for ( 0 .. $ver_idx ) {
        for ( 0 .. $stereo ) {
            $bit_skip += 21;
            $byte_off = $bit_skip >> 3;
            $bit_off = 8 - ( $bit_skip & 7 );
            $short = unpack( 'n',
                substr $_[0], $byte_off, 2
            );
            $gain = ( $short >> $bit_off ) & 255;
            $short ^= $gain << $bit_off;
            $gain += $GLOBAL_GAIN;
            if ( $gain > 255 ) {
                $gain = 255;
            } elsif ( $gain < 0 ) {
                $gain = 0;
            }
            $short += $gain << $bit_off;
            substr( $_[0], $byte_off, 2 )
                = pack( 'n', $short );
            $bit_skip += $post_skip;
        }
    }
    $crc_flag or substr(
        $_[0], 4, 2
    ) = frame_crc( $_[0] );
    return $bit_skip >> 3;
}

1;
