#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More 'tests' => 5;
use MIME::Base64 'decode_base64';

our @TEST_DATA;

BEGIN {
    use_ok 'Nick::MP3::SkipID3v2' => 'id3v2_size';
    @TEST_DATA = (
        {
            'file' => 'large_id3v2.mp3',
            'data' => decode_base64("SUQzAwAAABUbEw==\n"),
            'length' => 347539
        }, {
            'file' => 'no_tags.mp3',
            'data' => decode_base64("//tSAAAAAAAAAA==\n"),
            'length' => 0
        }, {
            'file' => 'biosphere.autour.de.la.lune.07.disparu.mp3',
            'data' => decode_base64("SUQzAwAAAAAJEw==\n"),
            'length' => 1171
        }, {
            'file' => 'massive.mp3',
            'data' => decode_base64("SUQzAwAAAAETAQ==\n"),
            'length' => 18817
        }
    );
}

for my $test ( @TEST_DATA ) {
    is(
        id3v2_size( $$test{'data'} ),
        $$test{'length'},
        'length of ' . $$test{'file'}
    );
}
