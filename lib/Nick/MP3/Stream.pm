package Nick::MP3::Stream;

use strict;
use warnings;

use base qw(
    Nick::MP3 Exporter
);

use Nick::MP3::Frame qw(
    find_frame header find_bitrate_type frame_samples frame_time
    $FRAME_LENGTH $BLOCK_SIZE
);

our( @EXPORT_OK, $POS, $CONSUME_BR_HEADER );

BEGIN {
    @EXPORT_OK = qw( $CONSUME_BR_HEADER );
    $CONSUME_BR_HEADER = 1;
}

sub new {
    my $self = bless {
        'handle' => $_[1],
        'data' => \do{ my $x = '' },
    } => $_[0];
    if (
        UNIVERSAL::isa $$self{'handle'}, 'IO::Handle'
    ) {
        $$self{'handle'} -> binmode();
    } else {
        binmode $$self{'handle'}
    }
    $$self{'first_frame'} = $self -> get_frame()
        or $self -> throw(
            'Unable to get first frame'
        );
    $$self{'first_header'} = header();
    ( $$self{'bitrate_header'} = find_bitrate_type(
            $$self{'first_frame'},
            $$self{'first_header'}
        )
    ) && $CONSUME_BR_HEADER
        or substr(
            ${ $$self{'data'} }, 0, 0
        ) = $$self{'first_frame'};
    return $self;
}

sub get_frame {
    my( $self ) = @_;
    my $data = $$self{'data'};
    for ( ;; ) {
        if (
            defined(
                $POS = find_frame( $$data )
            )
        ) {
            if (
                $POS >= 0
                &&
                $POS + $FRAME_LENGTH <= length( $$data )
            ) {
                $POS and substr( $$data, 0, $POS ) = '';
                return substr(
                    $$data, 0, $FRAME_LENGTH, ''
                );
            } else {
                substr( $$data, 0, $POS ) = '';
            }
        } else {
            $$data = '';
        }
        read(
            $$self{'handle'},
            $$data,
            $BLOCK_SIZE,
            length( $$data )
        ) or return undef;
    }
}

sub skip_frames {
    my( $self, $frames ) = @_;
    $frames or return;
    $frames > 0
        or return $self -> rewind_frames( $frames * -1 );
    my( $fh, $data ) = @$self{ qw( handle data ) };
    my $len;
    for ( ;; ) {
        $POS = 0;
        $len = length $$data;
        for ( ;; ) {
            if (
                defined(
                    $POS = find_frame( $$data, $POS )
                )
            ) {
                if ( $POS < 0 ) {
                    substr( $$data, 0, $POS ) = '';
                    $len = length $$data;
                } else {
                    unless(
                        --$frames > 0
                    ) {
                        $POS and substr( $$data, 0, $POS ) = '';
                        return $self -> sync_new_position( 1 );
                    }
                    $POS += $FRAME_LENGTH;
                    $POS < $len
                        and next;
                    $POS -= $len
                        and seek( $fh, $POS, 1 );
                    $len = 0;
                }
            }
            last;
        }
        read(
            $fh, $$data, $BLOCK_SIZE, $len
        ) or $self -> throw(
            "Ran out of data with $frames frames left to skip"
        );
    }
}

sub rewind_frames {
    my( $self, $frames ) = @_;
    $frames or return;
    my( $fh, $data ) = @$self{ qw( handle data ) };
    my( @pos, $len, $idx );
    my $byte_pos = $self -> position();
    my $read_bytes = $BLOCK_SIZE;
    while ( $byte_pos > 0 ) {
        $byte_pos -= $BLOCK_SIZE;
        if ( $byte_pos < 0 ) {
            $read_bytes += $byte_pos;
            $byte_pos = 0;
        }
        seek $fh, $byte_pos, 0;
        $len = read( $fh, $$data, $read_bytes )
            or $self -> throw(
                "Ran out of data with $frames frames left to skip"
            );
        $read_bytes > $BLOCK_SIZE
            and $read_bytes = $BLOCK_SIZE;
        undef @pos;
        $POS = 0;
        while (
            defined(
                $POS = find_frame( $$data, $POS )
            )
        ) {
            if ( $POS >= 0 ) {
                push @pos => $POS;
                $POS += $FRAME_LENGTH;
                $POS < $len
                    and next;
            } else {
                push @pos => $len + $POS;
            }
            last;
        }
        if ( @pos ) {
            if ( @pos > $frames ) {
                $POS = $pos[ $#pos - $frames ];
                $POS > 1 and substr( $$data, 0, $POS ) = '';
                return $self -> sync_new_position( 1 );
           } else {
                $frames -= @pos;
                $pos[0] > 0 and $read_bytes += $pos[0] - 1;
            }
        } else {
            $read_bytes += $len;
        }
    }
    $self -> throw(
        "Ran out of data to rewind with $frames frames left to skip"
    );
}

sub position {
    return tell( $_[0]{'handle'} ) - length(
        ${ $_[0]{'data'} }
    );
}

sub vbr_header {
    return(
        $_[0]{'bitrate_header'}
            && $_[0]{'bitrate_header'} -> type() eq 'Xing'
        ? $_[0]{'bitrate_header'}
        : undef
    );
}

sub bitrate_header {
    return $_[0]{'bitrate_header'};
}

sub first_header {
    return $_[0]{'first_header'};
}

sub first_frame {
    return $_[0]{'first_frame'};
}

sub last_header {
    return header();
}

sub frames_per_second {
    return(
        $_[0]{'first_header'}{'sample_rate'}
        / (
            $_[0]{'first_header'}{'id'}
            ? 144000 # MPEG1
            : 72000  # MPEG2
        )
    );
}

sub frame_length {
    return $_[0]{'first_header'}{'frame_length'};
}

sub bitrate {
    return $_[0]{'first_header'}{'bitrate'};
}

sub sample_rate {
    return $_[0]{'first_header'}{'sample_rate'};
}

sub is_stereo {
    return $_[0]{'first_header'}{'stereo'};
}

sub layer {
    return $_[0]{'first_header'}{'layer'};
}

sub version_id {
    return $_[0]{'first_header'}{'version_id'};
}

sub sync_new_position {
    my( $self, $keep_data ) = @_;
    my $make_id = sub {
        return join( ':',
            @{ $_[0] }{
                qw( sample_rate version_id layer stereo )
            }
        );
    };
    my $cur_id = &$make_id( $$self{'first_header'} );
    my $frame;
    my $data = $$self{'data'};
    $keep_data or $$data = '';
    while ( 1 ) {
        $frame = $self -> get_frame()
            or $self -> throw( sprintf
                'Unable to synchronise new position (%d)',
                tell( $$self{'handle'} )
            );
        if (
            &$make_id( header() ) eq $cur_id
        ) {
            substr( $$data, 0, 0 ) = $frame;
            last;
        } else {
            substr( $$data, 0, 0 ) = substr( $frame, 1 );
        }
    }
}

sub close {
    return close( $_[0]{'handle'} );
}

1;
