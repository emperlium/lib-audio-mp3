package Nick::MP3::Frame::LAME;

use strict;
use warnings;

use base 'Nick::MP3';

use Digest::CRC 'crc16';

our( $AUTOLOAD, %METHODS, @METHOD_NAMES );

BEGIN {
    my $no_set = sub {
        $_[0] -> caller_throw(
            'set not supported yet', 2
        );
    };
    my @rg_types = qw( 0 track album );
    my %shared = (
        'tag_vbr' => {
            'offset'    => 5,
            'length'    => 1,
            'pack'      => 'C'
        },
        'replay_gain' => {
            'length'    => 2,
            'pack'      => 'n',
            'get'       => sub {
                my $val = &{ $_[1] }( $_[0] );
                #bits 0h-2h: NAME of Gain adjustment:
                #000 = not set
                #001 = radio
                #010 = audiophile
                my $type = $rg_types[ $val >> 13 ]
                    or return ();
                # bit 6h: Sign bit
                # bits 7h-Fh: ABSOLUTE GAIN ADJUSTMENT
                # storing 10x the adjustment (to give the extra decimal place).
                return (
                    $type => (
                        ( $val & 511 ) * (
                            ( $val >> 9 ) & 1 ? -1 : 1
                        )
                    ) / 10
                );
            },
            'set' => $no_set
        }
    );
    for (
        {
            'name'      => 'version',
            'offset'    => 0,
            'length'    => 5
        },
        {
            'name'      => 'peak_signal_amplitude',
            'offset'    => 7,
            'length'    => 4,
            'pack'      => 'f'
        },
        {
            'name'      => 'tag_version',
            %{ $shared{'tag_vbr'} },
            'get'       => sub {
                # 0  rev0
                # 1  rev1
                # 15 reserved
                return &{ $_[1] }( $_[0] ) >> 4
            }
        },
        {
            'name'      => 'vbr_method',
            %{ $shared{'tag_vbr'} },
            'get'       => sub {
                # 0 unknown
                # 1 constant bitrate
                # 2 restricted VBR targetting a given average bitrate (ABR)
                # 3 full VBR method1
                # 4 full VBR method2
                # 5 full VBR method3
                # 6 full VBR method4
                # 8 constant bitrate 2 pass
                # 9 abr 2 pass
                return &{ $_[1] }( $_[0] ) & 15
            }
        },
        {
            'name'      => 'replay_gain_1',
            'offset'    => 11,
            %{ $shared{'replay_gain'} }
        },
        {
            'name'      => 'replay_gain_2',
            'offset'    => 13,
            %{ $shared{'replay_gain'} }
        },
        {
            'name'      => 'encoder_delays',
            'offset'    => 17,
            'length'    => 3,
            'get'       => sub {
                my $val = unpack(
                    'N', "\x00" . $_[0] -> raw_encoder_delays()
                );
                return(
                    ( $val >> 12 ),
                    $val & 4095
                );
            },
            'set' => $no_set
        },
        {
            'name'      => 'encoder_delay',
            'offset'    => 17,
            'length'    => 2,
            'pack'      => 'n',
            'get'       => sub {
                return &{ $_[1] }( $_[0] ) >> 4;
            },
            'set'       => sub {
                return &{ $_[2] }(
                    $_[0], (
                        &{ $_[3] }( $_[0] ) & 15
                    ) + (
                        $_[1] << 4
                    )
                );
            }
        },
        {
            'name'      => 'encoder_padding',
            'offset'    => 18,
            'length'    => 2,
            'pack'      => 'n',
            'get'       => sub {
                return &{ $_[1] }( $_[0] ) & 4095;
            },
            'set'       => sub {
                return &{ $_[2] }(
                    $_[0], (
                        &{ $_[3] }( $_[0] ) & 61440
                    ) + $_[1]
                );
            }
        },
        {
            'name'      => 'tag_crc',
            'offset'    => 30,
            'length'    => 2,
            'pack'      => 'n',
            'set'       => sub {
                return &{ $_[2] }(
                    $_[0], crc16(
                        substr(
                            $_[0]{'frame'},
                            0,
                            $_[0] -> tag_crc_offset()
                        )
                    )
                );
            }
        }
    ) {
        my(
               $name, $offset, $length, $pack, $packer, $unpacker, $get, $set
        ) = @$_{
            qw( name   offset   length   pack   packer   unpacker   get   set )
        };
        push @METHOD_NAMES => $name;
        $METHODS{ $name . '_offset' } = sub {
            return $_[0]{'offset'} + $offset;
        };
        my $raw = $METHODS{ 'raw_' . $name } = sub {
            return substr(
                $_[0]{'frame'},
                $_[0]{'offset'} + $offset,
                $length
            );
        };
        if ( $pack ) {
            $packer or $packer = sub {
                return pack( $pack, $_[1] )
            };
            $unpacker or $unpacker = sub {
                return unpack(
                    $pack, &$raw( $_[0] )
                )
            };
            $METHODS{ '_unpack_' . $name } = $unpacker;
        }
        $METHODS{$name} = (
            (
                $get && (
                    $unpacker
                    ? sub { &$get( $_[0], $unpacker ) }
                    : $get
                )
            ) || $unpacker || $raw
        );
        unless ( $set ) {
            $set = $packer
                ? $packer
                : sub {
                    return sprintf(
                        '% ' . $length . 's', $_[1]
                    );
                };
        }
        $METHODS{ 'set_' . $name } = sub {
            return(
                substr(
                    $_[0]{'frame'},
                    $_[0]{'offset'} + $offset,
                    $length
                ) = &$set( @_, $packer, $unpacker )
            );
        };
    }
}

sub new {
    my( $class, $header ) = @_;
    $header or return undef;
    my $pos = $header -> end_offset();
    my $frame = $header -> frame();
    substr( $frame, $pos, 4 ) eq 'LAME'
        or return undef;
    return bless {
        'frame'     => $frame,
        'offset'    => $pos + 4
    } => $class;
}

sub AUTOLOAD {
    my $method = substr(
        $AUTOLOAD, length( ref $_[0] ) + 2
    );
    exists( $METHODS{$method} )
        or $_[0] -> caller_throw(
            'Unknown method: ' . $AUTOLOAD
        );
    @_ > 1 and $method = 'set_' . $method;
    return &{ $METHODS{$method} }( @_ );
}

sub DESTROY {}

sub replay_gain {
    return {
        $_[0] -> replay_gain_1(),
        $_[0] -> replay_gain_2()
    };
}

1;
