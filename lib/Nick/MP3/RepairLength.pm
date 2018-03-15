package Nick::MP3::RepairLength;

use strict;
use warnings;

use base 'Nick::MP3';

use Fcntl;

use Nick::MP3::Info qw( $EXCLUDE_HEADER_FRAME );
use Nick::MP3::Frame::LAME;

sub new {
    my( $class, $file, $info ) = @_;
    my $self = bless {
        'file' => $file,
        'update' => {},
        'info' => (
            $info || Nick::MP3::Info -> new( $file )
        ),
    } => $class;
    $self -> _check_file();
    return $self;
}

sub _check_file {
    my( $self ) = @_;
    my $info = $$self{'info'};
    my $br_header = $info -> bitrate_header()
        or return;
    my $first_bytes = length( $info -> first_frame() );
    my %update = (
        'bytes' => {
            'got'       => $info -> audio_bytes( 1 ),
            'offset'    => $br_header -> bytes_offset()
        },
        'frames' => {
            'got'       => $info -> frames( 1 ),
            'offset'    => $br_header -> frames_offset()
        }
    );
    my( $got, $want );
    for my $type (
        qw( bytes frames )
    ) {
        $update{$type}{'offset'} && do {
            $want = $update{$type}{'want'}
                = $br_header -> $type();
            $got = $update{$type}{'got'};
            $want == $got || (
                $want == $got + (
                    ( $type eq 'bytes' ? $first_bytes : 1 )
                    *
                    ( $EXCLUDE_HEADER_FRAME ? 1 : -1 )
                )
            ) ? 0 : 1;
        } or delete $update{$type};
    }
    $$self{'update'} = \%update;
}

sub ok {
    return keys(
        %{ $_[0]{'update'} }
    ) ? 0 : 1;
}

sub fix {
    my( $self ) = @_;
    my $update = delete $$self{'update'};
    $update && %$update
        or $self -> caller_throw(
            'Nothing to fix in $$self{file}'
        );
    my $info = delete $$self{'info'};
    my $header_pos = $info -> leading_bytes();
    my $br_header = $info -> bitrate_header();
    my $handle;
    if ( ref $$self{'file'} ) {
        $handle = $info -> handle();
    } else {
        undef $info;
        sysopen(
            $handle, $$self{'file'}, O_WRONLY | O_BINARY
        ) or $self -> throw(
            "unable to open file '$$self{file}': $!"
        );
    }
    $self -> log( sprintf
        'Updating %s header for %s',
        $br_header -> type(),
        $$self{'file'}
    );
    for my $type ( keys %$update ) {
        $self -> log( sprintf
            '  change %s from %d to %d',
            $type,
            $br_header -> $type(),
            $$update{$type}{'got'}
        );
        seek( $handle, $header_pos + $$update{$type}{'offset'}, 0 );
        print $handle $br_header -> $type(
            $$update{$type}{'got'}
        );
    }
    my $lame = Nick::MP3::Frame::LAME -> new( $br_header );
    if ( $lame ) {
        seek( $handle, $header_pos + $lame -> tag_crc_offset(), 0 );
        print $handle $lame -> tag_crc( 1 );
        $self -> log( '  update LAME CRC' );
    }
    close $handle;
}

sub text {
    my( $self ) = @_;
    my $update = $$self{'update'};
    $update && %$update
        or $self -> caller_throw(
            'Nothing to fix in $$self{file}'
        );
    return 'got ' . join( ', ', map
        sprintf(
            '%+d %s', (
                exists( $$update{$_} )
                ? $$update{$_}{'got'} - $$update{$_}{'want'}
                : 0
            ), $_
        ), qw( frames bytes )
    );
}

1;
