#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Nick::MP3::Test::Headers '@TEST_HEADERS';

BEGIN {
    @TEST_HEADERS = grep(
        exists( $$_{'Info'} ),
        @TEST_HEADERS
    );
    plan tests => 1 + (
        grep( defined( $$_{'Info'} ), @TEST_HEADERS ) * 4
    ) + (
        grep !defined( $$_{'Info'} ), @TEST_HEADERS
    );
    use_ok 'Nick::MP3::Frame::Info';
}

my $info;
for my $test ( @TEST_HEADERS ) {
    note( $$test{'file'} );
    unless ( defined $$test{'Info'} ) {
        is(
            Nick::MP3::Frame::Info -> new( $$test{'data'} ),
            undef,
            'Invalid header'
        );
        next;
    }
    isa_ok(
        (
            $info = Nick::MP3::Frame::Info -> new( $$test{'data'} )
        ) => 'Nick::MP3::Frame::Info'
    ) or next;
    is( $info -> type() => 'Info', 'type' );
    is_deeply(
        {
            map {
                $_ => (
                    $_ eq 'toc'
                    ? [ $info -> $_() ]
                    : $info -> $_()
                ),
            } map(
                { $_, $_ . '_offset' }
                qw( bytes frames scale toc )
            )
        } => $$test{'Info'},
        'method values'
    );
    is(
        substr(
            $$test{'data'},
            $info -> end_offset(),
            4
        ),
        'LAME',
        'end_offset'
    );
}
