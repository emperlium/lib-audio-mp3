use strict;
use warnings;

use Test::More;

use lib 't/lib';
use Nick::MP3::Test::Headers '@TEST_HEADERS';

BEGIN {
    plan tests => 1 + ( 2 * @TEST_HEADERS );
    use_ok 'Nick::MP3::Frame::Header';
}

for my $test ( @TEST_HEADERS ) {
    ok(
        parse(
            substr $$test{'data'}, 0, 4
        )
    ) and is_deeply(
        header() => $$test{'header'}
    );
}
