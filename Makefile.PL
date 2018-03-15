use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'Nick::MP3',
    VERSION_FROM    => 'lib/Nick/MP3.pm',
    PREREQ_PM       => {
        'Digest::CRC' => 0,
        'IO::String' => 0,
        'POSIX' => 0,
        'Fcntl' => 0
    },
    TEST_REQUIRES   => {
        'Test::More' => 0,
        'Digest::MD5' => 0
    }
);
