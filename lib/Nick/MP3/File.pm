package Nick::MP3::File;

use strict;
use warnings;

use Fcntl;

use base qw( Nick::MP3 Exporter );

use Nick::MP3::Stream '$CONSUME_BR_HEADER';
use Nick::MP3::SkipID3v2 'skip_id3v2';
use Nick::MP3::Frame qw( count_frames $FRAME_LENGTH );

our(
    @EXPORT_OK, $ERROR_ON_EXCESS_BYTES,
    $MP3_FRAME, $VBR_POSITION_CHECK
);

BEGIN {
    @EXPORT_OK = qw(
        $ERROR_ON_EXCESS_BYTES $VBR_POSITION_CHECK $MP3_FRAME
    );
    $ERROR_ON_EXCESS_BYTES = 100000;
    $VBR_POSITION_CHECK = 0;
    $CONSUME_BR_HEADER = 1;
}

sub new {
    my( $class, $file ) = @_;
    my $self = bless {
        'file'          => $file,
        'got_frames'    => 0
    } => $class;
    $self -> _init();
    return $self;
}

sub read_frame {
    $MP3_FRAME = $_[0]{'stream'} -> get_frame()
        or return 0;
    $_[0]{'got_frames'}++;
    return $FRAME_LENGTH;
}

sub get_frame {
    return(
        $_[0] -> read_frame()
        ? $MP3_FRAME
        : undef
    );
}

sub DESTROY {
    $_[0] && ref( $_[0] )
        and $_[0] -> close();
}

sub close {
    return unless $_[0]{'handle'};
    close( delete $_[0]{'handle'} )
        or $_[0] -> throw(
            'Unable to close file handle'
        );
}

sub get_current_time {
    return $_[0] -> _nice_time(
        $_[0] -> get_current_secs()
    );
}

sub get_current_secs {
    return $_[0]{'got_frames'} * $_[0]{'frame_time'};
}

sub get_current_bytes {
    return $_[0]{'stream'} -> position();
}

sub get_file_time {
    return(
        exists( $_[0]{'total_time'} )
        ? $_[0]{'total_time'}
        : (
            $_[0]{'total_time'} = $_[0] -> _nice_time(
                $_[0]{'total_secs'}
            )
        )
    );
}

sub get_file_secs {
    return $_[0]{'total_secs'};
}

sub get_bitrate {
    return $_[0]{'bitrate'};
}

sub is_vbr {
    return $_[0]{'vbr'};
}

sub get_samplerate {
    return $_[0]{'stream'} -> sample_rate();
}

sub is_stereo {
    return $_[0]{'stream'} -> is_stereo();
}

sub get_layer {
    return $_[0]{'stream'} -> layer();
}

sub get_version {
    return $_[0]{'stream'} -> version_id();
}

sub get_frame_time {
    return $_[0]{'frame_time'};
}

sub bitrate_header {
    return $_[0]{'bitrate_header'};
}

sub header_frame {
    return $_[0]{'header_frame'};
}

sub frame_position {
    return $_[0]{'got_frames'};
}

sub skip {
    my( $self, $secs ) = @_;
    my $move_frames = $self -> _secs_to_frames( abs $secs );
    my $cur_frame = $$self{'got_frames'};
    my $frame_time = $$self{'frame_time'};
    my $new_frame;
    if ( $secs > 0 ) {
        $new_frame = $cur_frame + $move_frames;
        my $total_frames = $$self{'total_frames'};
        if ( $new_frame > $total_frames ) {
            return ( $new_frame - $total_frames ) * $frame_time;
        }
    } else {
        $new_frame = $cur_frame - $move_frames;
        if ( $new_frame < 0 ) {
            return $new_frame * $frame_time;
        }
    }
    $self -> _go_to_frame( $new_frame );
    return 0;
}

sub go_to {
    my( $self, $secs ) = @_;
    $secs == 0
        and return $self -> go_to_byte( $$self{'audio_offset'} );
    my $frames = $self -> _secs_to_frames( $secs );
    if ( $secs < 0 ) {
        $frames = $$self{'total_frames'} - $frames;
    }
    $self -> _go_to_frame( $frames );
}

sub go_to_byte {
    my( $self, $byte ) = @_;
    if (
        $byte < $$self{'audio_offset'}
    ) {
        $self -> throw(
            "Go to byte $byte is less than audio start at $$self{audio_offset}"
        );
    } elsif (
        $byte > $$self{'total_bytes'} - $$self{'audio_onset'}
    ) {
        $self -> throw( sprintf
            'Go to byte %s is greater than audio end at %s',
            $byte, $$self{'total_bytes'} - $$self{'audio_onset'}
        );
    }
    if ( $$self{'vbr'} && $VBR_POSITION_CHECK ) {
        my $fh = $$self{'handle'};
        seek( $fh, $$self{'audio_offset'}, 0 );
        $$self{'got_frames'} = count_frames( $fh, $byte );
        $$self{'stream'} -> sync_new_position();
    } else {
        $self -> _go_to_byte( $byte );
        $$self{'got_frames'} = int(
            (
                ( $byte - $$self{'audio_offset'} )
                / $$self{'frame_size'}
            ) + .5
        );
    }
}

sub _init {
    my( $self ) = @_;
    my $file = $$self{'file'};
    sysopen(
        my $fh, $file, O_RDONLY | O_BINARY
    ) or $self -> throw(
        "unable to open file '$file': $!"
    );
    skip_id3v2( $fh );
    $$self{'handle'} = $fh;
    my $stream
        = $$self{'stream'}
        = Nick::MP3::Stream -> new( $fh );
    $$self{'total_bytes'} = -s $file;
    my $vbr = 0;
    my( $br_header, $size, $frames, $onset );
    my $offset = $stream -> position();
    if (
        $br_header = $stream -> bitrate_header()
    ) {
        $$self{'header_frame'} = $stream -> first_frame();
        $br_header -> frames_offset()
            and $frames = $br_header -> frames();
        $br_header -> type() eq 'Xing'
            and $vbr = 1;
        if (
            $br_header -> bytes_offset()
        ) {
            $size = $br_header -> bytes();
            $onset = $$self{'total_bytes'} - ( $offset + $size );
            if (
                $ERROR_ON_EXCESS_BYTES && abs( $onset ) > $ERROR_ON_EXCESS_BYTES
            ) {
                $self -> error(
                    "Unbelievable non-audio bytes at end of file ($onset) ignoring bitrate header"
                );
                ( $size, $frames, $onset ) = ( undef, undef, undef );
            } elsif ( $onset < 0 ) {
                ( $size, $onset ) = ( undef, undef );
            }
        }
    } else {
        $$self{'header_frame'} = undef;
    }
    unless ( $size ) {
        $onset = $self -> _tail_tag_sizes();
        $size = $$self{'total_bytes'} - ( $offset + $onset );
    }
    my $bitrate = $stream -> bitrate();
    $$self{'frame_size'} = (
        $frames && $vbr
        ? $size / $frames
        : $stream -> frame_length()
    );
    $frames or $frames = int(
        $size / $$self{'frame_size'}
    );
    $vbr and $bitrate = $size / $frames * $stream -> frames_per_second();
    @$self{ qw(
        bitrate   audio_offset audio_onset vbr   total_frames bitrate_header
    ) } = (
        $bitrate, $offset,     $onset,     $vbr, $frames,     $br_header
    );
    $$self{'total_secs'} = $frames * (
        $$self{'frame_time'} = $stream -> frame_time()
    );
}

sub _nice_time {
    return(
        $_[1] < 3600
        ? sprintf(
            '%d:%02d',
            $_[1] / 60,
            $_[1] % 60
        ) : sprintf(
            '%d:%02d:%02d',
            $_[1] / 3600,
            ( $_[1] % 3600 ) / 60,
            $_[1] % 60
        )
    );
}

sub _tail_tag_sizes {
    my( $self ) = @_;
    my( $header, $size );
    my $fh = $$self{'handle'};
    my $orig_pos = tell $fh;
    my $read = sub {
        read( $fh, $header, $_[0] )
            or $self -> throw(
                "Unable to read $_[0] bytes from file handle"
            );
    };
    $self -> _seek( -128 => 2 );
    &$read( 3 );
    my $onset = 0;
    if (
        $header eq 'TAG'
    ) {
        $onset = 128;
    }
    $self -> _seek(
        ( 32 + $onset ) * -1 => 2
    );
    &$read( 16 );
    if (
        substr( $header, 0, 8 ) eq 'APETAGEX'
    ) {
        if (
            ( $size = unpack(
                'V' => substr( $header, -4 )
            ) ) > $$self{'total_bytes'}
        ) {
            $self -> error(
                "APE size $size is larger than the file $$self{total_bytes}, ignoring"
            )
        } else {
            $self -> _seek(
                ( 32 + $size + $onset ) * -1 => 2
            );
            &$read( 8 );
            $header eq 'APETAGEX'
                and $onset += 32 + $size
        }
    }
    $self -> _seek( $orig_pos );
    return $onset;
}

sub _secs_to_frames {
    return int(
        abs( $_[1] ) / $_[0]{'frame_time'}
    );
}

sub _go_to_frame {
    my( $self, $frame ) = @_;
    $frame < 0
        and $self -> throw(
            "Go to frame $frame is less than 0"
        );
    $frame > $$self{'total_frames'}
        and $self -> throw(
            "Go to frame $frame is greater than $$self{total_frames}"
        );
    if ( $$self{'vbr'} ) {
        $$self{'stream'} -> skip_frames(
            $frame - $$self{'got_frames'}
        );
    } else {
        $self -> _go_to_byte(
            int(
                $$self{'frame_size'} * $frame
            ) + $$self{'audio_offset'}
        );
    }
    $$self{'got_frames'} = $frame;
}

sub _go_to_byte {
    $_[0] -> _seek( $_[1] );
    $_[0]{'stream'} -> sync_new_position();
}

sub _seek {
    seek(
        $_[0]{'handle'},
        $_[1],
        $_[2] || 0
    ) or $_[0] -> throw(
        "Unable to seek to byte $_[1] from "
        . (
            'start of file',
            'current position',
            'end of file'
        )[ $_[2] || 0 ]
    );
}

1;
