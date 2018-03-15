# lib-audio-mp3

Suite of modules for low-level handling of MP3 frames.

## CPAN dependencies

 * Digest::CRC
 * IO::String

## Installation

You'll also need to install the lib-base repository from this account.

    perl Makefile.PL
    make test
    sudo make install

## Example

    use Nick::MP3::File '$MP3_FRAME';
    my $mp3 = Nick::MP3::File -> new( 'test.mp3' )
        or die;

    use FileHandle;
    my $sox = FileHandle -> new(
        '| sox -q -t mp3 - -t pulseaudio'
    ) or die $!;
    binmode $sox;

    my $total_secs = $mp3 -> get_file_secs();
    printf "Total seconds: %d\n", $total_secs;
    printf "Total time: %s\n", $mp3 -> get_file_time();
    printf "Bitrate: %d\n", $mp3 -> get_bitrate();
    printf "VBR: %d\n", $mp3 -> is_vbr();
    printf "Samplerate: %d\n", $mp3 -> get_samplerate();
    printf "Stereo: %d\n", $mp3 -> is_stereo();
    printf "Layer: %d\n", $mp3 -> get_layer();
    printf "Version: %d\n", $mp3 -> get_version();
    printf "Frame Time: %.3f\n", $mp3 -> get_frame_time();
    printf(
        "Current time(%s) bytes(%d)\n",
        $mp3 -> get_current_time(),
        $mp3 -> get_current_bytes()
    );
    my $frame_no = 0;
    my $jump_to = 0;
    my $quit = 0;
    while (
        $mp3 -> read_frame()
    ) {
        $sox -> print( $MP3_FRAME );
        $frame_no ++;
        if ( $frame_no % 300 == 0 ) {
            if ( $quit ) {
                print "quitting after $frame_no frames\n";
                last;
            }
            $jump_to += 100;
            if ( $jump_to > $total_secs ) {
                $quit = 1;
                $jump_to = 0;
            }
            print "jump to $jump_to seconds\n";
            $mp3 -> go_to( $jump_to );
            printf(
                "Current time(%s) bytes(%d)\n",
                $mp3 -> get_current_time(),
                $mp3 -> get_current_bytes()
            );
        }
    }
    $mp3 -> close();
    $sox -> close();
