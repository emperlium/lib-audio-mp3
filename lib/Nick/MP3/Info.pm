package Nick::MP3::Info;

use strict;
use warnings;

use Fcntl;
use IO::String;
use POSIX 'fmod';

use base qw( Nick::MP3 Exporter );

use Nick::MP3::Stream '$CONSUME_BR_HEADER';
use Nick::MP3::Frame::LAME;
use Nick::MP3::Frame qw(
    find_frame frame_samples frame_time
    $FRAME_LENGTH $BLOCK_SIZE
);
use Nick::MP3::Frame::Header '$BITRATE';
use Nick::MP3::SkipID3v2 'skip_id3v2';

our(
    @EXPORT_OK, $AUTOLOAD,
    @ID_FIELDS, %METHOD_OBJECTS, $TMP,
    $EXCLUDE_HEADER_FRAME
);

BEGIN {
    @ID_FIELDS = qw(
        id layer mode sample_rate stereo version_id
    );
    @EXPORT_OK = qw( @ID_FIELDS $EXCLUDE_HEADER_FRAME );
    for ( qw(
        bitrate frame_length layer sample_rate stereo version_id
    ) ) {
        $METHOD_OBJECTS{$_} = [ 'first_header' => $_ ];
    }
    for ( qw(
        first_header first_frame bitrate_header
    ) ) {
        $METHOD_OBJECTS{$_} = [ 'stream' => $_ ];
    }
    for (
        @Nick::MP3::Frame::LAME::METHOD_NAMES, 'replay_gain'
    ) {
        $METHOD_OBJECTS{ 'lame_' . $_ }  = [ 'lame' => $_ ];
    }
    $EXCLUDE_HEADER_FRAME = 1;
    $CONSUME_BR_HEADER = 1;
}

sub new {
    my( $class, $data ) = @_;
    if ( ref $data ) {
        if (
            ref( $data ) eq 'SCALAR'
        ) {
            $data = IO::String -> new( $data );
        } elsif (
            UNIVERSAL::isa( $data, 'Nick::MP3::Stream' )
        ) {
            return bless {
                'stream' => $data
            } => $class;
        } elsif (
            UNIVERSAL::isa( $data, 'Nick::MP3::Info' )
        ) {
            return bless $data => $class;
        } elsif (
            ! UNIVERSAL::can( $data, 'read' )
        ) {
            $data = ref $data;
        }
    } elsif ( -f $data ) {
        sysopen(
            my $fh, $data, O_RDONLY | O_BINARY
        ) or $class -> throw(
            "unable to open file '$data': $!"
        );
        $data = $fh;
        skip_id3v2( $fh );
    } elsif ( ! defined( $data ) ) {
        $data = 'undefined';
    }
    ref( $data ) or $class -> throw(
        "I need either a valid filename, a scalar reference, a Nick::MP3::Stream object or a filehandle, not '$data'"
    );
    $TMP = Nick::MP3::Stream -> new( $data );
    return bless {
        'handle' => $data,
        'stream' => $TMP,
        'leading_bytes' => (
            $TMP -> position() - (
                $CONSUME_BR_HEADER
                    && $TMP -> bitrate_header()
                ? length( $TMP -> first_frame() )
                : 0
            )
        )
    } => $class;
}

sub AUTOLOAD {
    my( $method, $object );
    exists(
        $METHOD_OBJECTS{
            $method = substr(
                $AUTOLOAD, length( ref $_[0] ) + 2
            )
        }
    ) or $_[0] -> caller_throw(
        'Unknown method: ' . $AUTOLOAD
    );
    ( $object, $method ) = @{
        $METHOD_OBJECTS{$method}
    };
    return(
        ( $object = $_[0] -> $object() )
        ? (
            ref( $object ) eq 'HASH'
            ? $object -> {$method}
            : $object -> $method()
        )
        : undef
    );
}

sub DESTROY {
    ref( $_[0] ) && $_[0]{'stream'}
        and delete(
            $_[0]{'stream'}
        ) -> close();
}

sub stream {
    return $_[0]{'stream'};
}

sub handle {
    return $_[0]{'handle'};
}

sub get_field {
    return $_[0] -> first_header() -> { $_[1] };
}

sub get_fields {
    return @{
        $_[0] -> first_header()
    }{
        @_ > 1 ? @_[ 1 .. $#_ ] : @ID_FIELDS
    }
}

sub bitrate_header_type {
    return(
        ( $TMP = $_[0] -> bitrate_header() )
        ? $TMP -> type()
        : ''
    );
}

sub lame {
    return(
        exists( $_[0]{'lame'} )
        ? $_[0]{'lame'}
        : $_[0]{'lame'} = (
            ( $TMP = $_[0] -> bitrate_header() )
                ? Nick::MP3::Frame::LAME -> new( $TMP )
                : undef
        )
    );
}

sub channels {
    return $_[0] -> stereo() ? 2 : 1
}

sub details {
    unless (
        exists $_[0]{'details'}
    ) {
        $_[0]{'details'} = {
            'sample_rate' => $_[0] -> sample_rate(),
            'channels' => $_[0] -> channels()
        };
    }
    return( wantarray
        ? %{ $_[0]{'details'} }
        : $_[0]{'details'}
    );
}

sub is_vbr {
    return(
        exists( $_[0]{'vbr'} ) || (
            $_[1] && $_[0] -> _check_frames()
        )
        ? $_[0]{'vbr'}
        : $_[0] -> bitrate_header_type() eq 'Xing' ? 1 : 0
    );
}

sub average_bitrate {
    exists( $_[0]{'bitrate'} )
        or $_[0] -> _check_frames();
    return $_[0]{'bitrate'};
}

sub leading_bytes {
    return $_[0]{'leading_bytes'};
}

sub audio_offset_bytes {
    return (
        $_[0] -> bitrate_header_type()
        ? length( $_[0] -> first_frame() )
        : 0
    ) + $_[0]{'leading_bytes'};
}

sub trailing_bytes {
    my( $self ) = @_;
    unless (
        exists $$self{'trailing_bytes'}
    ) {
        my $fh = $$self{'handle'};
        my $orig_pos = tell $fh;
        seek( $fh, -128, 2 );
        my $buffer;
        read( $fh, $buffer, 3 );
        my $onset = 0;
        $buffer eq 'TAG'
            and $onset = 128;
        seek( $fh, -32 - $onset, 2 );
        read( $fh, $buffer, 16 );
        if (
            substr( $buffer, 0, 8 ) eq 'APETAGEX'
        ) {
            my $size;
            if (
                ( $size = unpack( 'V' => substr $buffer, -4 ) )
                    > $self -> total_bytes()
            ) {
                $self -> error(
                    "APE size $size is larger than the file $self->{total_bytes}, ignoring"
                )
            } else {
                seek( $fh, -32 - $size - $onset, 2 );
                read( $fh, $buffer, 8 );
                $buffer eq 'APETAGEX'
                    and $onset += 32 + $size
            }
        }
        seek( $fh, $orig_pos, 0 );
        $$self{'trailing_bytes'} = $onset;
    }
    return $$self{'trailing_bytes'};
}

sub total_bytes {
    unless (
        exists $_[0]{'total_bytes'}
    ) {
        $TMP = tell $_[0]{'handle'};
        seek $_[0]{'handle'}, 0, 2;
        $_[0]{'total_bytes'} = tell $_[0]{'handle'};
        seek $_[0]{'handle'}, $TMP, 0;
    }
    return $_[0]{'total_bytes'};
}

sub frames {
    my( $self, $accurate ) = @_;
    unless ( exists $$self{'frames'} ) {
        if ( $accurate ) {
            $self -> _check_frames();
        } elsif (
            $TMP = $self -> bitrate_header()
        ) {
            return $TMP -> frames();
        } else {
            return int(
                $self -> audio_bytes()
                / $$self{'stream'} -> frame_length()
            );
        }
    }
    return $$self{'frames'};
}

sub audio_bytes {
    my( $self, $accurate ) = @_;
    unless ( exists $$self{'audio_bytes'} ) {
        if ( $accurate ) {
            $self -> _check_frames();
        } elsif (
            $TMP = $self -> bitrate_header()
        ) {
            return $TMP -> bytes();
        } else {
            return(
                $self -> total_bytes() -
                    $$self{'leading_bytes'}
                        + $self -> trailing_bytes()
            );
        }
    }
    return $$self{'audio_bytes'};
}

sub _check_frames {
    my( $self ) = @_;
    my $fh = $$self{'handle'};
    my $orig_pos = tell $fh;
    my $start_pos = ( $EXCLUDE_HEADER_FRAME
        ? $self -> audio_offset_bytes()
        : $$self{'leading_bytes'}
    );
    seek( $fh, $start_pos, 0 );
    my( $buffer, $pos, $len, %bitrates, $read );
    my( $data, $frames, $bytes, $got_bytes ) = ( '', 0, 0, 0 );
    my $get_bytes = $self -> total_bytes()
        - $start_pos
        - $self -> trailing_bytes();
    while (
        $got_bytes < $get_bytes && (
            $read = read(
                $fh, $buffer, (
                    $got_bytes + $BLOCK_SIZE > $get_bytes
                    ? $get_bytes - $got_bytes
                    : $BLOCK_SIZE
                )
            )
        )
    ) {
        $got_bytes += $read;
        $len = length(
            $data .= $buffer
        );
        $pos = 0;
        for ( ;; ) {
            if (
                defined(
                    $pos = find_frame( $data, $pos )
                )
            ) {
                if ( $pos < 0 ) {
                    substr( $data, 0, $pos ) = '';
                } else {
                    $frames ++;
                    $bytes += $FRAME_LENGTH;
                    $pos += $FRAME_LENGTH;
                    $bitrates{$BITRATE} ++;
                    $pos < $len
                        and next;
                    if ( $pos -= $len ) {
                        seek( $fh, $pos, 1 );
                        $got_bytes += $pos;
                    }
                    $data = '';
                }
            }
            last;
        }
    }
    seek( $fh, $orig_pos, 0 );
    $$self{'audio_bytes'} = $bytes;
    $$self{'frames'} = $frames;
    @$self{ qw( vbr bitrate ) } = (
        keys( %bitrates ) > 1
        ? do {
            ( $pos, $len ) = ( 0, 0 );
            for ( keys %bitrates ) {
                $pos += $bitrates{$_};
                $len += $_ * $bitrates{$_};
            }
            ( 1, int $len / $pos );
        }
        : ( 0, ( keys %bitrates )[0] || 0 )
    );
}

sub samples {
    return(
        $_[0] -> frames( $_[1] ) * frame_samples() - (
            ( $TMP = $_[0] -> lame() )
            ? $TMP -> encoder_delay() + $TMP -> encoder_padding()
            : 0
        )
    );
}

sub seconds {
    return $_[0] -> samples( $_[1] ) / $_[0] -> sample_rate();
}

sub length {
    $TMP = $_[0] -> seconds( $_[1] );
    return(
        $TMP < 3600
        ? sprintf(
            '%d:%02d',
            $TMP / 60,
            $TMP % 60
        ) : sprintf(
            '%d:%02d:%02.2f',
            $TMP / 3600,
            ( $TMP % 3600 ) / 60,
            fmod( $TMP, 60 )
        )
    );
}

1;
