#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Nick::MP3::Test::Headers '@TEST_HEADERS';

our @SET_TESTS;

BEGIN {
    @TEST_HEADERS = grep(
        exists( $$_{'Xing'} ),
        @TEST_HEADERS
    );
    @SET_TESTS = (
        [ 'frames', [ 10 ], '10' ],
        [ 'bytes', [ 1000 ], '1000' ],
        [ 'toc', [ 1 .. 9, 1 .. 9, 1 .. 9  ], '1234567891234567891234567' ]
    );
    plan tests => 1 + ( @TEST_HEADERS * 4 ) + ( @SET_TESTS * 2 );
    use_ok 'Nick::MP3::Frame::Xing';
}

my $xing;
for my $test ( @TEST_HEADERS ) {
    note( $$test{'file'} );
    isa_ok(
        (
            $xing = Nick::MP3::Frame::Xing -> new( $$test{'data'} )
        ) => 'Nick::MP3::Frame::Xing'
    ) or next;
    is( $xing -> type() => 'Xing', 'type' );
    is_deeply(
        {
            map {
                $_ => (
                    $_ eq 'toc'
                    ? [ $xing -> $_() ]
                    : $xing -> $_()
                ),
            } map(
                { $_, $_ . '_offset' }
                qw( bytes frames scale toc )
            )
        } => $$test{'Xing'},
        'method values'
    );
    is(
        substr(
            $$test{'data'},
            $xing -> end_offset(),
            4
        ),
        'LAME',
        'end_offset'
    );
}

for ( @SET_TESTS ) {
    my( $method, $vals, $want ) = @$_;
    my $xing = MockXing -> new();
    is(
        join( '',
            unpack( 'N*',
                $xing -> $method( @$vals )
            )
        ),
        $want,
        'set ' . $method
    );
    is(
        join( '',
            $xing -> $method()
        ),
        $want,
        'get set ' . $method
    );
}

package MockXing;

our( $PARENT, @LEN );

BEGIN {
    $PARENT = 'Nick::MP3::Frame::Xing';
}

use base $PARENT;

BEGIN {
    @LEN = @Nick::MP3::Frame::Xing::LEN;
}

sub new {
    my @offsets;
    my $offset = 2;
    for ( 0 .. $#LEN ) {
        push @offsets => $offset;
        $offset += $LEN[$_];
    }
    return bless {
        'frame'     => "\x00" x 190,
        'offsets'   => \@offsets,
        'last_byte' => $offset
    } => $PARENT;
}

1;
