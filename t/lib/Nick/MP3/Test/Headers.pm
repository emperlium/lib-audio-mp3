package Nick::MP3::Test::Headers;

use strict;
use warnings;

use base 'Exporter';

use MIME::Base64 'decode_base64';

our @EXPORT = qw( @TEST_HEADERS );

our @TEST_HEADERS = (
    {
        'file' => 'TinyVBR.mp3',
        'data' => decode_base64("/+NAxAAAAAAAAAAAAFhpbmcAAAAPAAAADAAABoEACQkJCQkJCQk2NjY2NjY2NlJSUlJSUlJSbW1t\nbW1tbW1tiYmJiYmJiYmbm5ubm5ubm7a2tra2tra2tsnJycnJycnJ5OTk5OTk5OTt7e3t7e3t7e32\n9vb29vb29v//////////AAAACkxBTUUzLjk4cgQ3AAAAAC5DAAAUCCQE10EAAZoAAAaBSOaJhQAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==\n"),
        'header' => {'bitrate',32,'bitrate_index',4,'copyright',0,'emphasis',0,'frame_length',208,'id',0,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',11025,'sampling_freq',0,'stereo',0,'version_id',2.5},
        'lame' => {'encoder_delays',[576,1239],'peak_signal_amplitude','0','peak_signal_amplitude_offset',144,'tag_crc',35205,'tag_crc_offset',167,'tag_version',0,'tag_version_offset',142,'track','-6.7','vbr_method',4,'vbr_method_offset',142,'version','3.98r','version_offset',137},
        'br_header_type' => 'Xing',
        'Xing' => {'bytes',1665,'bytes_offset',25,'frames',12,'frames_offset',21,'scale',10,'scale_offset',129,'toc',[592137,151587081,154547766,909522486,911364690,1381126738,1382903149,1835887981,1835895177,2307492233,2307496859,2610666395,2610673334,3065427638,3065427657,3385444809,3385444836,3840206052,3840206061,3991793133,3991793133,4143380214,4143380214,4294967295,4294967295],'toc_offset',29}
    }, {
        'file' => 'TinyCBR.mp3',
        'data' => decode_base64("/+NAxAAAAAAAAAAAAEluZm8AAAAPAAAADAAACpsAFRUVFRUVFRUqKioqKioqKkBAQEBAQEBAVVVV\nVVVVVVVVampqampqamqAgICAgICAgJWVlZWVlZWVlaqqqqqqqqqqwMDAwMDAwMDV1dXV1dXV1dXq\n6urq6urq6v//////////AAAAOUxBTUUzLjk4cgE3AAAAAC4/AAAUICQE10IAACAAAAqb9U3J8AAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==\n"),
        'header' => {'bitrate',32,'bitrate_index',4,'copyright',0,'emphasis',0,'frame_length',208,'id',0,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',11025,'sampling_freq',0,'stereo',0,'version_id',2.5},
        'lame' => {'encoder_delays',[576,1239],'peak_signal_amplitude','0','peak_signal_amplitude_offset',144,'tag_crc',51696,'tag_crc_offset',167,'tag_version',0,'tag_version_offset',142,'track','-6.3','vbr_method',1,'vbr_method_offset',142,'version','3.98r','version_offset',137},
        'br_header_type' => 'Info',
        'Info' => {'bytes',2715,'bytes_offset',25,'frames',12,'frames_offset',21,'scale',57,'scale_offset',129,'toc',[1381653,353703189,355084842,707406378,708853824,1077952576,1079334229,1431655765,1431661162,1785358954,1785364608,2155905152,2155910549,2509608341,2509608362,2863311530,2863311552,3233857728,3233857749,3587560917,3587560917,3941264106,3941264106,4294967295,4294967295],'toc_offset',29}
    }, {
        'file' => 'BonnieVBR.mp3',
        'data' => decode_base64("//uQZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWGluZwAAAA8AADR2AHKc/wADBggK\nDA8RFBYYGh4gIyUnKiwuMTM2OTs+QENFR0pMT1FVV1pcXmFkZ2lsb3N2eXt+gYOGiIqMkJOVl5qc\nnqGjpaerrrCztbi6vL/BxMfJy87Q09XX2dzf4uTn6uzv8vT3+fwAAABNTEFNRTMuOTdiA7oAAAAA\nLj4AADQgJAT+TQAB4ABym7M1EV7vAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAA\n"),
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',1,'mode_extension',2,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',1,'version_id',1},
        'lame' => {'encoder_delays',[576,1278],'peak_signal_amplitude','0','peak_signal_amplitude_offset',167,'tag_crc',24303,'tag_crc_offset',190,'tag_version',0,'tag_version_offset',165,'track','-6.2','vbr_method',3,'vbr_method_offset',165,'version','3.97b','version_offset',160},
        'br_header_type' => 'Xing',
        'Xing' => {'bytes',7511295,'bytes_offset',48,'frames',13430,'frames_offset',44,'scale',77,'scale_offset',152,'toc',[198152,168562449,336992282,505422629,657075246,825439801,993935427,1162299980,1330730327,1516002913,1684498796,1869837945,2071888259,2257095308,2425591191,2593955489,2745542571,2930815925,3099245759,3250898889,3419328723,3587693020,3756188903,3941396466,4109892092],'toc_offset',52}
    }, {
        'file' => 'OryxCBR-64-44.mp3',
        'data' => decode_base64("//tQxAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAYvAAUNDgACBQcKDA8SFBcZHB8hJCYpKy4x\nMzU4Oj1AQkVHSkxPUlRXWVxfYWRmaGttcHN1eHp9gIKFh4qNj5KUl5mbnqGjpqirrrCztbi6vcDC\nxcfKzM7R1NbZ297h4+bo6+7w8/X4+v0AAAA8TEFNRTMuOTMgAYkAAAAAAAAAAAJAJAWBQQAAAAAF\nDQ7WqeKmAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==\n"),
        'header' => {'bitrate',64,'bitrate_index',5,'copyright',0,'emphasis',0,'frame_length',208,'id',1,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',0,'version_id',1},
        'lame' => {'encoder_delays',[576,1409],'peak_signal_amplitude','0','peak_signal_amplitude_offset',152,'tag_crc',58022,'tag_crc_offset',175,'tag_version',0,'tag_version_offset',150,'vbr_method',1,'vbr_method_offset',150,'version','3.93 ','version_offset',145},
        'br_header_type' => 'Info',
        'Info' => {'bytes',331022,'bytes_offset',33,'frames',1583,'frames_offset',29,'scale',60,'scale_offset',137,'toc',[132359,168562450,337058076,522265638,690695729,859125818,1027621445,1196051535,1381259097,1549754724,1718119277,1886614904,2055045250,2240252557,2408748183,2577112737,2745608363,2930815925,3099246016,3267741642,3436106196,3604601822,3789809384,3958305011,4126735101],'toc_offset',37}
    }, {
        'file' => 'StrictlyKevVBR.mp3',
        'data' => decode_base64("//uQZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWGluZwAAAA8AAADXAAF4OQAEBggL\nDRATFRcaHB8hJScpLC4wMzY4Oz0/QURHSUtOUFNWWFpdX2FjaGptb3J0eHt9gIKEh4uNj5KUl5md\nn6Kkpqmtr7K0t7m8wMPFyMrMz9PV2Nrd3+Pl5+rs7vD09vj6/P8AAABNTEFNRTMuOTdiA7oAAAAA\nLFoAADQgJAYsTQAB4AABduAWGyM1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAA\n"),
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',1,'mode_extension',2,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',1,'version_id',1},
        'lame' => {'encoder_delays',[576,1580],'peak_signal_amplitude','0','peak_signal_amplitude_offset',167,'tag_crc',9013,'tag_crc_offset',190,'tag_version',0,'tag_version_offset',165,'track','9','vbr_method',3,'vbr_method_offset',165,'version','3.97b','version_offset',160},
        'br_header_type' => 'Xing',
        'Xing' => {'bytes',96313,'bytes_offset',48,'frames',215,'frames_offset',44,'scale',77,'scale_offset',152,'toc',[263688,185405459,353835548,522265895,690761264,859191355,1027555652,1195985742,1347638872,1516068705,1667787373,1869771896,2071822466,2223475597,2408748183,2577244066,2762385837,2947724471,3116155075,3318270668,3486766552,3671973859,3857181420,4008768758,4177198335],'toc_offset',52}
    }, {
        'file' => 'onyourwayhome.mp3',
        'data' => decode_base64("//uQZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASW5mbwAAAA8AAAFvAAJY0AADBggK\nDRASFRgaHR8hJCcpLC8xNDY5Oz5AQ0ZIS01QUlVXWl1fYmRnaWxucXR2eXt+gIOFiIuNkJKVl5qc\nn6Kkp6qsrrGztrm7vsHDxcjKzdDS1dja3N/h5Ofp7O/x8/b4+/4AAAA8TEFNRTMuOTBhAQAAAAAA\nAAAAAAIAAAAATQAAAAACWNC6Kb98AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAA\n"),
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',1,'mode_extension',2,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',1,'version_id',1},
        'lame' => {'encoder_delays',[0,0],'peak_signal_amplitude','0','peak_signal_amplitude_offset',167,'tag_crc',49020,'tag_crc_offset',190,'tag_version',0,'tag_version_offset',165,'vbr_method',1,'vbr_method_offset',165,'version','3.90a','version_offset',160},
        'br_header_type' => 'Info',
        'Info' => {'bytes',153808,'bytes_offset',48,'frames',367,'frames_offset',44,'scale',60,'scale_offset',152,'toc',[198152,168628242,353901085,522265639,690761521,875968827,1044398918,1212894544,1381324634,1566532196,1734962286,1903457913,2071888003,2240318349,2425525655,2593955746,2762451628,2930881462,3116089025,3284519114,3453014741,3638222047,3789875177,3975148019,4143512574],'toc_offset',52}
    }, {
        'file' => 'ptah-turniptree.mp3',
        'data' => decode_base64("//uQRAAAAmsAqe0EAABDQAU9oAAADqHtM7imhAnRvuZ3DtCATeKJJb+bdkA1AgXPh8QOB8uODBcP\nh8o4H44MFz58QOB9/nBOfBAoND5QMeXhhbw+IDgPl5y/yiw+UOf/y44EFjv+fEDg+XHBgufPlJPk\npAkp7b7PYs4XPhgoNB8ocDBd4IAAaHygIRA4Tv84XfKDQfUc8HFh8ocZyg0PlAx//EiwfUc/5wTv\nBAoND5Q4zIf8oABQLBwKBgKxEIAgAABmk5/AoCA8A8UzMIoLP44ARsWf8Aww4RNgDR/wXyUNxyFd\nVf8+bDwEbC+jf7f5oYkMuD3GHOf/+UzMlzp8uFRQT///1qrToIGhu/////LjIIMg5gXHM3QX////\n///UfW6kKmsZm6CoeABAIBAIB2KBQKAQAABiWOeJwj8DBb5RHv8c5BL38JAF2GFC5vX+JeOc3GEL\nv/xzjHHsJgIAMn/+HPGAGAHGIOFXV//7mDIl90Fp///6Cbp7UD6H///+tZgieUgmpkEGQO//////\n/07F86ZGiJuggtA+hZM3dkeI\n"),
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',1,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',1,'version_id',1},
        'br_header_type' => ''
    }, {
        'file' => 'invalid_info.mp3',
        'data' => decode_base64("//OEZPMXFdVOAAAAAAAAAAAAAAAASW5mbwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n"),
        'header' => {'bitrate',64,'bitrate_index',8,'copyright',0,'emphasis',0,'frame_length',192,'id',0,'layer',3,'mode',1,'mode_extension',2,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',24000,'sampling_freq',1,'stereo',1,'version_id',2},
        'br_header_type' => '',
        'Info' => undef
    }, {
        'file' => 'empty_lame_xing.mp3',
        'data' => decode_base64("//uQxAAAAAAAAAAAAAAAAAAAAAAAWGluZwAAAA8AAAABAAACCQD/////////////////////////\n////////////////////////////////////////////////////////////////////////////\n//////////////////////////////8AAABQTEFNRTMuOTlyBLkAAAAAAAAAADUgJAJAQQAB4AAA\nAgkvcddgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAA\n"),
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',0,'version_id',1},
        'lame' => {'encoder_delays',[576,576],'peak_signal_amplitude','0','peak_signal_amplitude_offset',152,'tag_crc',55136,'tag_crc_offset',175,'tag_version',0,'tag_version_offset',150,'vbr_method',4,'vbr_method_offset',150,'version','3.99r','version_offset',145},
        'br_header_type' => 'Xing',
        'Xing' => {'bytes',521,'bytes_offset',33,'frames',1,'frames_offset',29,'scale',80,'scale_offset',137,'toc',[16777215,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295,4294967295],'toc_offset',37}
    }, {
        'file' => 'empty_lame_noxing.mp3',
        'data' => decode_base64("//uQxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAA\n"),
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',0,'version_id',1},
        'br_header_type' => ''
    }
);

1;
