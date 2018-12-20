package Nick::MP3::Frame::Header;

use strict;
use warnings;

use base 'Exporter';

our(
    @EXPORT, @BITRATES, @SAMPLE_RATES,
    $BYTES, $FRAME_LENGTH, $VERSION_ID, $ID, $LAYER, $PROTECTION_BIT,
    $BITRATE_INDEX, $SAMPLING_FREQ, $PADDING_BIT, $EMPHASIS,
    $BITRATE, $SAMPLE_RATE
);

BEGIN {
    @EXPORT = qw(
        parse header $FRAME_LENGTH $LAYER $VERSION_ID $BITRATE $SAMPLE_RATE
        @BITRATES @SAMPLE_RATES
    );
    @BITRATES = (
        [ #MPEG2
            [],
            #Layer 3
            [ qw( 0  8 16 24  32  40  48  56  64  80  96 112 128 144 160 ) ],
            #Layer 2
            [ qw( 0  8 16 24  32  40  48  56  64  80  96 112 128 144 160 ) ],
            #Layer 1
            [ qw( 0 32 48 56  64  80  96 112 128 144 160 176 192 224 256 ) ]
        ],
        [ #MPEG1
            [],
            #Layer 3
            [ qw( 0 32 40 48  56  64  80  96 112 128 160 192 224 256 320 ) ],
            #Layer 2
            [ qw( 0 32 48 56  64  80  96 112 128 160 192 224 256 320 384 ) ],
            #Layer 1
            [ qw( 0 32 64 96 128 160 192 224 256 288 320 352 384 416 448 ) ]
        ],
    );
    @SAMPLE_RATES = (
        [ qw( 11025 12000  8000 ) ], # MPEG 2.5
        [   undef, undef, undef   ], # reserved
        [ qw( 22050 24000 16000 ) ], # MPEG 2
        [ qw( 44100 48000 32000 ) ], # MPEG 1
    );
}

sub parse {
    $BYTES = unpack( 'N', $_[0] );
    if (
        $BYTES >> 21 & 11 != 11
        ||
        ( $BYTES & 0xFFE00000 ) != 0xFFE00000
        ||
        ( $BYTES & 0xFFFF0000 ) == 0xFFFE0000
    ) {
        return undef;
    }

    # need to do a crc check

    $LAYER = ( $BYTES >> 17 ) & 3
        or return undef;

    $ID = ( $BYTES >> 19 ) & 1;

    $PROTECTION_BIT = ( $BYTES >> 16 ) & 1;

    $ID == 1 && $LAYER == 3 && $PROTECTION_BIT == 1
        and return undef;

    ( $EMPHASIS = $BYTES & 3 ) == 2
        and return undef;

    ( $VERSION_ID = ( $BYTES >> 19 ) & 3 ) == 1
        and return undef;

    $BITRATE_INDEX = ( $BYTES >> 12 ) & 15;
    $BITRATE_INDEX == 0 || $BITRATE_INDEX == 15
        and return undef;

    ( $SAMPLING_FREQ = ( $BYTES >> 10 ) & 3 ) == 3
        and return undef;

    $PADDING_BIT = ( $BYTES >> 9 ) & 1;

    $BITRATE = $BITRATES[ $ID ][ $LAYER ][ $BITRATE_INDEX ];

    $SAMPLE_RATE = $SAMPLE_RATES[ $VERSION_ID ][ $SAMPLING_FREQ ];

    if ( $LAYER == 3 ) {
        $FRAME_LENGTH = 48;
        # not tested
        $PADDING_BIT *= 4;
    } elsif ( $LAYER == 2 ) {
        $FRAME_LENGTH = 144;
    } else {
        $FRAME_LENGTH = ( $VERSION_ID == 2 || $VERSION_ID == 0 ) ? 72 : 144;
    }
    $FRAME_LENGTH = int( $FRAME_LENGTH * $BITRATE * 1000 / $SAMPLE_RATE + $PADDING_BIT )
        or return undef;
    return 1;
}

sub header {
    my $mode = ( $BYTES >> 6 ) & 3;
    return {
        'id'                => $ID,
        'layer'             => 4 - $LAYER,
        'protection_bit'    => $PROTECTION_BIT,
        'bitrate_index'     => $BITRATE_INDEX,
        'sampling_freq'     => $SAMPLING_FREQ,
        'padding_bit'       => $PADDING_BIT,
        'private_bit'       => ( $BYTES >> 8 ) & 1,
        'mode'              => $mode,
        'mode_extension'    => ( $BYTES >> 4 ) & 3,
        'copyright'         => ( $BYTES >> 3 ) & 1,
        'original'          => ( $BYTES >> 2 ) & 1,
        'emphasis'          => $EMPHASIS,
        'bitrate'           => $BITRATE,
        'sample_rate'       => $SAMPLE_RATE,
        'frame_length'      => $FRAME_LENGTH,
        'stereo'            => $mode == 3 ? 0 : 1,
        'version_id'        => (
            $VERSION_ID == 3
            ? 1 : (
                $VERSION_ID == 0
                ? 2.5 : $VERSION_ID
            )
        ),
    };
}

1;
