package Nick::MP3::Test::Files;

use strict;
use warnings;

use base 'Exporter';

use MIME::Base64 'decode_base64';
use Digest::MD5 'md5_base64';

our @EXPORT = qw( @TEST_FILES );

our @TEST_FILES = (
    {
        'file' => 'TinyVBR.mp3',
        'data' => decode_base64("/+NAxAAAAAAAAAAAAFhpbmcAAAAPAAAADAAABoEACQkJCQkJCQk2NjY2NjY2NlJSUlJSUlJSbW1t\nbW1tbW1tiYmJiYmJiYmbm5ubm5ubm7a2tra2tra2tsnJycnJycnJ5OTk5OTk5OTt7e3t7e3t7e32\n9vb29vb29v//////////AAAACkxBTUUzLjk4cgQ3AAAAAC5DAAAUCCQE10EAAZoAAAaBSOaJhQAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/jEMQABVACoAdAAACAD///////\n////yhyH/////////4YVA2RJZqZqaMiM+0aaSDiqMmb/41DEEUHsdtsfjHkg8GUpyWxweLDMHRqK\nxuxx6RVFeUl7VLvxmlZJ0mGMIwWwkjxUEkZTzH8H2cgCSJ0O8pg9idRxfxU5O2SqckRdUihV9xnB\nWHqjtf5vtVrTg/VKHyK6TucR5hX7zBhab0+5s6MVDE2qU5V5NyPl1HrRvY2PUNzpDZ6/D5kVk7+A\nT5KsykhKt5HdHizq46ZKRXrQ7YPZjZ5Vezt8KJCmvE95jzqSB6xQGxvjvGBVbqxuTBlymy27a9Pt\nPYbZf//dNXxT3281fTGq4/iZj3jMmrwbnQzxnGdtQtuj3kv402tR47Exvb0eRcxqa+8a/7EpVG3H\nQs/+2r0mqgX/4zDEASKpbuMXz2AAZKk1SFwJz+f/43VHi4BwDJIeJiKUZpuD7CGNyMFfH+LeXvW6\n1jJg9juwiP2yYOZAAiflQSFNjvKffFkK88MOfmc1e5Rijt4+cmk12/TPtWvvx7salPKqNBWG86tQ\nNB2pQdqlgaIscDrmPxTgZkNM2ArCgKgqAn2Fjymi+CwdEsiIs6LHv8FQVWCtAHGpr4D/4zDEBRwx\ndt7WBhg0b273YisNah5oSUMnpZDg2CYdCcY6JNT6s/9V6YuGgtCUlTM997vGRWHpufnqU5qBLBu/\ndsvD0PS4vpIa/1Myz1tpMz/z3e7Z0KEDBAWmP2mFfZ+7ES0oF2gdBnaxP/aXOH2HzijruZJw8TWx\nFtjMdqT+3f//LGc4VYcQswcw449RHx1j0FjLcsESapLxVk3/4zDEIyBzatpWeYtEB/ngcKQRyXYm\n48lK5QlfVZa6L6zmM6itq/qaJ4cHtAxEd3QCqmVKUptTdP/8xmmMZzSqx2dvuLgIOD7zqdTnO8+/\n///9S0laZ5Std6Epdj/+mm9VlKVijREOaWbCtaEJAaA/Vc+GwxAkSFHuZALMTQHMDCIEO0OISMA+\nEKQQcRJy4ohVKIhFU9JReCowHo3/4yDEMB+xKrmWA9gY0xKN3k1sOa6fK0Z6IByYjoFJSHYyjouX\nfbHr1z95mIkDQdw7SDWs79IaPE5KCodDW+WbDrZL4K0M9ZUFSoJFmsK4luILBQOjRECv6iz1uSoD\n3/1w/dybf9Xicv/jMMQMHpL+oF7DBO0XvQxQaVMOFLpJ9ImMGVCy5M5MRkStrTWqwy6TqmwKEYmk\n0HSEYmK4CURxe47EEllo6AMJ4NRFi1qj15UTWhnrM7mMZ5ptpSujlVlLpLr6t9P3m/9NpWKSgztd\nF/////03VEFBXmxgr/fx9oXCgxUgAk7b+NY0sRCwGy7jyh4hKiQnstdlq+WKpzILIBbjk//jIMQg\nHXL6jF7DBNAOmYRgsyUzg7Xmo5BxUOwXUOlhS8ZCgWguaPNmbZ3eO6yl7qxAjEZ5CgYsWz+n6nOf\nk/p7Myn98n+3/9Tuh3cxK///+nZutKHixUAFO6XTSsROcg8QqeGS3b/Z/+MwxAUjok6MPmPHSEsu\nEItVXVKoiqXU0cDy1cqy38uepEfjqIpNHkQSwAEJJcH5amMVi85JyGIJbTFlapD7LELank0Q45Gl\nVpGO9gwJDlcYKrY3j+JHgWe2fezgJMOoUZwHwEhxWyttyxnnt1SPUqqsfP+f5ZxVDCUYBVs+ieLO\nFhpRUi1ovyxtg3stKlUhG8YO/1nZlQDALttw/+MQxAUHgOqpuABGcRC//woQpQKbGux6/QEtWtwF\nFiovIUNS6+ZMQU1FMy45OC4yVVVVVf/jEMQOAAAD/AAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVX/4xDENQAAA0gAAAAAVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVV\n"),
        'frames' => [[0,208,'cdZAZf4YMIvYUAsyP/YgIg'],[208,52,'fJXsygVWpfwzuDDgRHQ7Iw'],[260,261,'90dwY98iB4VMKQcqprGuPw'],[521,156,'VhJyPAGQixDUtqONOM+1dg'],[677,156,'pgRx1GygDjeLsR0eGYBnvw'],[833,156,'KSNp4s28xisHMwixQupf9g'],[989,104,'kZ+VjvoGE8JreRZYDMkC3A'],[1093,156,'9RstCJkv/NesYBYkzKGtYQ'],[1249,104,'kjUR2HHheFvsDEX+froYLQ'],[1353,156,'MPsC6qU1HnxVceSvlkCotw'],[1509,52,'pyvocSoNq2mNpcIzMIce1A'],[1561,52,'+PZEVXTWJak7JCjS2P10fA'],[1613,52,'Pw9gzLdFVeG29MysBk0Dzg']],
        'header' => {'bitrate',32,'bitrate_index',4,'copyright',0,'emphasis',0,'frame_length',208,'id',0,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',11025,'sampling_freq',0,'stereo',0,'version_id',2.5},
        'samples' => 5097,
        'frame_samples' => 576,
        'frame_time' => 0.0522448979591837,
        'br_header_type' => 'Xing',
        'leading_bytes' => 0,
        'trailing_bytes' => 0,
        'Xing' => {'bytes',1665,'bytes_offset',25,'frames',12,'frames_offset',21,'scale',10,'scale_offset',129,'toc',[592137,151587081,154547766,909522486,911364690,1381126738,1382903149,1835887981,1835895177,2307492233,2307496859,2610666395,2610673334,3065427638,3065427657,3385444809,3385444836,3840206052,3840206061,3991793133,3991793133,4143380214,4143380214,4294967295,4294967295],'toc_offset',29},
        'lame' => {'encoder_delays',[576,1239],'peak_signal_amplitude','0','peak_signal_amplitude_offset',144,'tag_crc',35205,'tag_crc_offset',167,'tag_version',0,'tag_version_offset',142,'track','-6.7','vbr_method',4,'vbr_method_offset',142,'version','3.98r','version_offset',137}
    }, {
        'file' => 'TinyCBR.mp3',
        'data' => decode_base64("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\nhCUOPpaeTx4N61xhhmUWHR0NDXb3UoZUnE+pG2yttyxnnt0SR6lRKsfDL4+UKGGEiQyhVhr2Q//j\nQsR0J3wWgB5jxvDbyj/l7NsvYt0s9DBnSq/f9maMV758yiqS65o/D1QXCOJeWVqhwtxPkg5qEc7R\nq4F1NV+fxkpo/xDSWBGluIcsFiTbrDW4sLpXTkpOATYuSfOFXCynEfybQ14X5Cp07Dbl2F6fTeXE\ntx8ruoNklBXLBOl2QVRULkXVKJ5maUNfqmr17Fxa0GmwgYjUTmhMMMjCszXNEr1/LymFE5WPZtcN\nlRqJYCkqyOdQKqDudR98ldZxZ5Hd/5ZbqCUEAzMNLlCcjlko/+NCxJojwmpEBHhHqOg4oNQh4huX\n5QyU+pi6jEl8tsra0FlSC4uLoHSCFKaNptSZIZknEliOAyTiS+YoS8ml4nNkl45im1z1MTkwjIa0\nQRoA0PI6sntLTnzW1a4SWRUdLdtnzTJG5XbZp5ytn/s89tf/t5bZ7/vJ2gFDJliVUJCTQCoUFBoN\nAqIlDzolGAy7CT9YCAolZ5IKu4/1VUxBTUUzLjk4LjJVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVX/40LEzyaKefwEwwzYVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1F\nMy45OC4yVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/j\nQsT4AAADSAAAAABVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\n"),
        'frames' => [[0,208,'aAXxOn8lTsR8EKiniucYaA'],[208,208,'51qjFpr9fdvwYU7S0gBVBA'],[416,209,'bakCw3DoZ+7hKxN+UA4J8A'],[625,209,'g5vIqI96lk7q/ddZklYjSw'],[834,209,'HN4LtaEePjhtEhctPzrOEg'],[1043,209,'JuZnCVRXkqpGaXmGR6Z6ZA'],[1252,209,'m3J2xdT+BmhswsFcnjngYg'],[1461,209,'1we4qfk0reiVq7E7Hzuyng'],[1670,209,'u54+2UkI7LVg3x0mGphnWA'],[1879,209,'uJ203CzWjvDQ0UWNaMSw+Q'],[2088,209,'zheMpw9JTeQd+PdPRnlptA'],[2297,209,'yhW6/dauI4iTbHagfNy21g'],[2506,209,'JmNZlCstZKKMCmRJHhNnLg']],
        'header' => {'bitrate',32,'bitrate_index',4,'copyright',0,'emphasis',0,'frame_length',208,'id',0,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',11025,'sampling_freq',0,'stereo',0,'version_id',2.5},
        'samples' => 5097,
        'frame_samples' => 576,
        'frame_time' => 0.0522448979591837,
        'br_header_type' => 'Info',
        'leading_bytes' => 0,
        'trailing_bytes' => 0,
        'Info' => {'bytes',2715,'bytes_offset',25,'frames',12,'frames_offset',21,'scale',57,'scale_offset',129,'toc',[1381653,353703189,355084842,707406378,708853824,1077952576,1079334229,1431655765,1431661162,1785358954,1785364608,2155905152,2155910549,2509608341,2509608362,2863311530,2863311552,3233857728,3233857749,3587560917,3587560917,3941264106,3941264106,4294967295,4294967295],'toc_offset',29},
        'lame' => {'encoder_delays',[576,1239],'peak_signal_amplitude','0','peak_signal_amplitude_offset',144,'tag_crc',51696,'tag_crc_offset',167,'tag_version',0,'tag_version_offset',142,'track','-6.3','vbr_method',1,'vbr_method_offset',142,'version','3.98r','version_offset',137}
    }, {
        'file' => 'turniptree.mp3',
        'data' => decode_base64("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\nfSv5NTLcmbzsN3IyQ2TPQf/th3206X+qV24gpQ==\n"),
        'frames' => [[70,417,'HG9uwn6d9ki6otaJWjU4RA'],[487,417,'QuxxaHuQCYO8xBHoF2pWZA'],[904,417,'chQ5/vqXoB5KwicM9PUGEQ'],[1321,417,'ZB9Njfu2Z/VkegB5myeHeQ']],
        'header' => {'bitrate',128,'bitrate_index',9,'copyright',0,'emphasis',0,'frame_length',417,'id',1,'layer',3,'mode',1,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',44100,'sampling_freq',0,'stereo',1,'version_id',1},
        'samples' => 4608,
        'frame_samples' => 1152,
        'frame_time' => 0.0261224489795918,
        'br_header_type' => '',
        'leading_bytes' => 70,
        'trailing_bytes' => 0
    }, {
        'file' => 'CBRTags.mp3',
        'data' => decode_base64("SUQzAwAAAAAQJ1RQRTEAAAAdAAAB//5hAHIAdABpAHMAdAAgAHYAYQBsAHUAZQAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n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\n2aJqv//n//j/6447tYKD447k2pZjtuLnhttmaDmFqf//+XQLbSS0zjmpgrIqCctu2+awR8L/kO8T\n8pDeQtQokihMA4COGK28bW6w3d1McadldyrjvrkhqV3LXF3d7tEe5pCKSr0UXD8P6uPhK/eyxcOz\n3TIq45j/40LESiZbloweexCXspOEQxHF3eXd3T+K96/pE5t3dZPOILOOFhRRs3yv///fXPjETVX5\nLiHgO5CMoQRMKIjTdvVcQj3bzZ7zDUpqOgjKMMgwAdJTV7+tz65O6BUAKbf+BZY6AUHzK6o4gRLK\n0rK0I+OT5Va38uepMrzpNFDTdIKcASInKIL0yro5XjOfppL5BSClK1tTUfZYhCUOPpaeTx4N61xh\nhmUWHR0NDXb3UoZUnE+pG2yttyxnnt0SR6lRKsfDL4+UKGGEiQyhVhr2Q//jQsR0J3wWcB5jxvDb\nyj/l7NsvYt0s9DBnSq/f9maMV758yiqS65o/D1QXCOJeWVqhwtxPkg5qEc7Rq4F1NV+fxkpo/xDS\nWBGluIcsFiTbrDW4sLpXTkpOATYuSfOFXCynEfybQ14X5Cp07Dbl2F6fTeXEtx8ruoNklBXLBOl2\nQVRULkXVKJ5maUNfqmr17Fxa0GmwgYjUTmhMMMjCszXNEr1/LymFE5WPZtcNlRqJYCkqyOdQKqDu\ndR98ldZxZ5Hd/5ZbqCUEAzMNLlCcjlko/+NCxJojwmo0BHhHqOg4oNQh4huX5QyU+pi6jEl8tsra\n0FlSC4uLoHSCFKaNptSZIZknEliOAyTiS+YoS8ml4nNkl45im1z1MTkwjIa0QRoA0PI6sntLTnzW\n1a4SWRUdLdtnzTJG5XbZp5ytn/s89tf/t5bZ7/vJ2gFDJliVUJCTQCoUFBoNAqIlDzolGAy7CT9Y\nCAolZ5IKu4/1VUxBTUUzLjk4LjJVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVX/40LEzyaKeewEwwzYVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVMQU1FMy45OC4yVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVf/jQsT4AAADOAAAAABV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV\nVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVQVBFVEFHRVjQBwAAyQAAAAUAAAAAAACgAAAAAAAAAAAM\nAAAAAAAAAEFydGlzdABhcnRpc3QgdmFsdWUHAAAAAAAAAE1QM0dBSU5fTUlOTUFYADEyMywxODgL\nAAAAAAAAAE1QM0dBSU5fVU5ETwArMDA0LCswMDQsTgwAAAAAAAAAUkVQTEFZR0FJTl9UUkFDS19H\nQUlOAC0wLjMxMDAwMCBkQggAAAAAAAAAUkVQTEFZR0FJTl9UUkFDS19QRUFLADAuMzA0NTIwQVBF\nVEFHRVjQBwAAyQAAAAUAAAAAAACAAAAAAAAAAABUQUcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAABhcnRpc3QgdmFsdWUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/w==\n"),
        'frames' => [[2097,208,'aAXxOn8lTsR8EKiniucYaA'],[2305,208,'/Om21CZcfl7zcTFuFcjNNg'],[2513,209,'4YyDyuopXkrEX8RjwfgyWg'],[2722,209,'qM5b1iahK6Cr51bz2MsZug'],[2931,209,'KMUqfWoUMBk5esq3HodBSg'],[3140,209,'1oex32+fhvKqzna0Ffhmlw'],[3349,209,'tXJCPyNL76UPJ6UkJPfLEQ'],[3558,209,'Bj92K7K+cF/wnzdfI7YrLQ'],[3767,209,'L2BuwB9yxTfF5YMF20Bylw'],[3976,209,'J4814WIScB1KFla1EG9jIA'],[4185,209,'kd/4doAK95WgYEd/9O/nJA'],[4394,209,'0ERWRDZR0CzZysOf1Ern+g'],[4603,209,'ZoIdFSjxOyKyUNhkTZFsNA']],
        'header' => {'bitrate',32,'bitrate_index',4,'copyright',0,'emphasis',0,'frame_length',208,'id',0,'layer',3,'mode',3,'mode_extension',0,'original',1,'padding_bit',0,'private_bit',0,'protection_bit',1,'sample_rate',11025,'sampling_freq',0,'stereo',0,'version_id',2.5},
        'samples' => 5097,
        'frame_samples' => 576,
        'frame_time' => 0.0522448979591837,
        'br_header_type' => 'Info',
        'leading_bytes' => 2097,
        'trailing_bytes' => 361,
        'Info' => {'bytes',2715,'bytes_offset',25,'frames',12,'frames_offset',21,'scale',57,'scale_offset',129,'toc',[1381653,353703189,355084842,707406378,708853824,1077952576,1079334229,1431655765,1431661162,1785358954,1785364608,2155905152,2155910549,2509608341,2509608362,2863311530,2863311552,3233857728,3233857749,3587560917,3587560917,3941264106,3941264106,4294967295,4294967295],'toc_offset',29},
        'lame' => {'encoder_delays',[576,1239],'peak_signal_amplitude','0','peak_signal_amplitude_offset',144,'tag_crc',51696,'tag_crc_offset',167,'tag_version',0,'tag_version_offset',142,'track','-6.3','vbr_method',1,'vbr_method_offset',142,'version','3.98r','version_offset',137}
    }
);

1;
