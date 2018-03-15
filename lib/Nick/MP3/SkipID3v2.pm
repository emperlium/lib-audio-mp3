package Nick::MP3::SkipID3v2;

use strict;
use warnings;

use base qw( Nick::MP3 Exporter );

our @EXPORT_OK;

BEGIN {
    @EXPORT_OK = qw( skip_id3v2 id3v2_size );
}

=pod

=head1 NAME

Nick::MP3::SkipID3v2 - subroutines to identify and skip ID3 V2 tags.

=head1 SYNOPSIS

    use Nick::MP3::SkipID3v2 qw( skip_id3v2 id3v2_size );

    open( my $fh, '<test.mp3' );

    skip_id3v2( $fh );

    my $buf;
    seek( $fh, 0, 0 );
    read( $fh, $buf, 10 )
    printf "ID3 tag is %d bytes\n", id3v2_size( $buf );

=head1 METHODS

=head2 skip_id3v2()

Given a filehandle will seek past an ID3 V2 tag, if present.

    skip_id3v2( FH );

=head2 id3v2_size()

Given a chunk of data, will return the size of the ID3 V2 tag, if present.

    printf "ID3 tag is %d bytes\n", id3v2_size( $data );

=cut

sub skip_id3v2 {
    my( $fh ) = @_;
    my $orig_pos = tell $fh;
    my $buf;
    read( $fh, $buf, 10 )
        or Nick::MP3 -> throw(
            'Unable to read 10 bytes from file handle'
        );
    if (
        $buf = id3v2_size( $buf )
    ) {
        seek( $fh, $buf, 1 )
            or Nick::MP3 -> throw(
                "Unable to seek forward $buf bytes"
            );
    } else {
        seek( $fh, $orig_pos, 0 )
            or Nick::MP3 -> throw(
                "Unable to seek to byte $orig_pos"
            );
    }
}

sub id3v2_size {
    my( $tag ) = @_;
    substr( $tag, 0, 3 ) eq 'ID3'
        or return 0;
    my( $major, $rev ) = unpack(
        'CC', substr $tag, 3, 2
    );
    $major >= 2 && $major <= 4 && $rev == 0
        or return 0;
    for (
        unpack( 'C4', substr $tag, 6, 4 )
    ) {
        $rev = ( $rev << 7 ) + $_;
    }
    return $rev;
}

1;
