package Nick::MP3::Frame;

use strict;
use warnings;

use base 'Exporter';

use Nick::MP3;
use Nick::MP3::Frame::Header qw(
    parse header $FRAME_LENGTH $LAYER $VERSION_ID $SAMPLE_RATE
);

our(
    @EXPORT_OK, $MARKER, @BITRATE_TYPES, $BLOCK_SIZE,
    $len, $pos, $tmp
);

BEGIN {
    @EXPORT_OK = qw(
        find_frame parse_header header count_frames
        frame_time frame_samples find_bitrate_type
        $FRAME_LENGTH $BLOCK_SIZE
    );
    $MARKER = "\xff";
    @BITRATE_TYPES = qw(
        Nick::MP3::Frame::Info
        Nick::MP3::Frame::Xing
    );
    $BLOCK_SIZE = 8192;
}

use Nick::MP3::Frame::Xing;
use Nick::MP3::Frame::Info;

sub find_frame {
    $pos = defined( $_[1] )
        ? $_[1]
        : 0;
    $len = length( $_[0] );
    while (
        (
            $pos = index( $_[0], $MARKER, $pos )
        ) > -1
    ) {
        if ( $pos + 4 >= $len ) {
            return $pos - $len;
        } elsif (
            parse( substr $_[0], $pos, 4 )
        ) {
            return $pos;
        } else {
            $pos ++;
        }
    }
    return undef;
}

sub parse_header {
    return(
        parse( substr $_[0], 0, 4 )
        ? header()
        : undef
    );
}

sub frame_samples {
    if ( $LAYER == 3 ) {
        return 384;
    } elsif ( $VERSION_ID == 3 || $LAYER == 2 ) {
        return 1152;
    } else {
        return 576;
    }
}

sub frame_time {
    return frame_samples() / $SAMPLE_RATE;
}

sub find_bitrate_type {
    $_[1] || (
        $_[1] = parse_header( $_[0] )
    ) or return undef;
    for ( @BITRATE_TYPES ) {
        $tmp = $_ -> new( @_ )
            and return $tmp;
    }
    return undef;
}

sub count_frames {
    my( $fh, $bytes ) = @_;
    my( $read, $pos );
    my $buffer = '';
    my $frames = 0;
    $len = 0;
    while ( $bytes > 0 ) {
        $read = read(
            $fh, $buffer, (
                $BLOCK_SIZE > $bytes ? $bytes : $BLOCK_SIZE
            ), $len
        ) or Nick::MP3 -> throw(
            'Unable to read from filehandle'
        );
        $bytes -= $read;
        $len += $read;
        $pos = 0;
        while (
            ( $pos = index $buffer, $MARKER, $pos ) > -1
        ) {
            if ( $pos + 4 >= $len ) {
                substr( $buffer, 0, $pos - $len ) = '';
                $len = length $buffer;
                last;
            } elsif (
                parse( substr $buffer, $pos, 4 )
            ) {
                $pos += $FRAME_LENGTH;
                $frames ++;
            } else {
                $pos ++;
            }
        }
        $pos == -1 and $len = 0;
    }
    return $frames;
}

1;
