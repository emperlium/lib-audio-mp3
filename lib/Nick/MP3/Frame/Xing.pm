package Nick::MP3::Frame::Xing;

use strict;
use warnings;

use base 'Nick::MP3';

our(
    $AUTOLOAD, $LONG_LEN, @OFFSET, @FLAG, $UNPACK,
    @LEN, %METHODS
);

use Nick::MP3::Frame 'parse_header';

BEGIN {
    $LONG_LEN = 4;
    @OFFSET = map(
        [ map $_ + $LONG_LEN, @$_ ],
        [ 9, 17 ],  # MPEG2
        [ 17, 32 ]  # MPEG1
    );
    @FLAG = qw( 1 2 4 8 );
    $UNPACK = 'N';
    my $toc_id = 2;
    my $tocs = 25;
    my @names = qw( frames bytes toc scale );
    for ( 0 .. $#FLAG ) {
        my $idx = $_;
        my( $len, $upk );
        my $name = $names[$idx];
        if ( $idx == $toc_id ) {
            $len = $LONG_LEN * $tocs;
            $upk = $UNPACK . $tocs;
        } else {
            $len = $LONG_LEN;
            $upk = $UNPACK;
        }
        push @LEN, $len;
        $METHODS{$name} = sub {
            return(
                $_[0]{'offsets'}[$idx]
                ? unpack(
                    $upk, substr(
                        $_[0]{'frame'},
                        $_[0]{'offsets'}[$idx],
                        $len
                    )
                )
                : undef
            );
        };
        $METHODS{ $name . '_offset'  } = sub {
            return $_[0]{'offsets'}[$idx];
        };
        $METHODS{ 'set_' . $name } = sub {
            my $self = shift;
            return(
                $$self{'offsets'}[$idx]
                ? substr(
                    $$self{'frame'},
                    $$self{'offsets'}[$idx],
                    $len
                ) = pack( $upk, @_ )
                : ''
            );
        };
    }
}

sub new {
    my( $class, $frame, $header ) = @_;
    unless ( $header ) {
        $header = parse_header( $frame )
            or return undef;
    }
    my $offset = $OFFSET[
        $header -> {'id'}
    ][
        $header -> {'stereo'}
    ];
    substr( $frame, $offset, $LONG_LEN )
        eq $class -> type()
            or return undef;
    $offset += $LONG_LEN;
    my $flags = unpack(
        $UNPACK, substr(
            $frame, $offset, $LONG_LEN
        )
    ) or return undef;
    $offset += $LONG_LEN;
    my @offsets;
    for ( 0 .. $#FLAG ) {
        if ( $flags & $FLAG[$_] ) {
            push @offsets => $offset;
            $offset += $LEN[$_];
        } else {
            push @offsets => 0;
        }
    }
    return bless {
        'frame'     => $frame,
        'offsets'   => \@offsets,
        'last_byte' => $offset
    } => $class;
}

sub type {
    return 'Xing';
}

sub end_offset {
    return $_[0]{'last_byte'};
}

sub frame {
    return $_[0]{'frame'};
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

sub DESTROY {
}

1;
