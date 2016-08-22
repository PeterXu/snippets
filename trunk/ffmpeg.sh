#!/bin/bash


playback_http() {
    input="http://127.0.0.1:8080/test"
    url="rtmp://127.0.0.1/app/test_capture"


    #/d/misc/mozilla-build/ffmpeg/bin/ffmpeg \
    #    -f dshow -i video="Integrated Camera" -f dshow -i audio="麦克风 (3- Realtek High Definition" \
    #    -pix_fmt yuv420p -c:v libx264 -vprofile baseline -s 640x480 -filter:v fps=20 -b:v 512k -intra-refresh auto \
    #    -maxrate 640k -minrate 128k -bf 0 -b_strategy 0 -g 15 -keyint_min 15 -sc_threshold 0 \
    #    -flags global_header -mixed-refs 1 -rc_lookahead 30 \
    #    -c:a aac -ar 44100 -ac 1 -b:a 32k -strict -2 \
    #    -f flv $url

    /d/misc/mozilla-build/ffmpeg/bin/ffmpeg \
        -i $input \
        -pix_fmt yuv420p -c:v libx264 -vprofile baseline -s 640x480 -filter:v fps=20 -b:v 512k -intra-refresh auto \
        -maxrate 640k -minrate 128k -bf 0 -b_strategy 0 -g 25 -keyint_min 10 -sc_threshold 0 \
        -mixed-refs 1 -rc_lookahead 30 \
        -c:a aac -ar 44100 -ac 1 -b:a 32k -strict -2 \
        -f flv $url
}



playback_pipe() {
    url="rtmp://127.0.0.1/app/test"
    ffmpeg –s 640x480 –pix_fmt yuv420p -i pipe:video  \
        –vcodec libx264 -vprofile baseline -pass 1 \
        -maxrate 640k -minrate 128k -framerate 20 -g 20 \
        -f s16le -ar 44.1k -ac 1 -i pipe:audio \
        -acodec aac -ar 44.1k -ac 1 -ab 32k -strict experimental \
        -f flv $url
        

    ffmpeg -s 640x480 -pix_fmt yuv420p -i pipe:/sdcard/zffmpeg_pipe_video \
        -vcodec libx264 -vprofile baseline -pass 1 -maxrate 640k -minrate 128k -framerate 20 -g 20 \
        -f s16le -ar 44.1k -ac 1 -i pipe:/sdcard/zffmpeg_pipe_audio -acodec aac -ar 44.1k -ac 1 -ab 32k -strict -2 \
        -f flv $url
}    


playback_y4m() {
    ## yuv4mpeg
    # 1) magic: "YUV4MPEG"
    # 2) yuv header, max 80+10bytes: "...\nW640H480C420p12"
    # "YUV4MPEG,W640,H480,C420p12,F20"


    ffmpeg -f u16le -acodec pcm_s16le -ac 2 -ar 44100 -i all.a \
           -f yuv4mpegpipe -i all.v \
           -y output.flv
           

    ffmpeg -f yuv4mpegpipe -i /sdcard/zffmpeg_pipe_video -pix_fmt yuv420p -vcodec libx264 -vprofile baseline -pass 1 -maxrate 640k -minrate 128k -framerate 20 -g 20 -s 640x480 -f flv $url


    ffmpeg -loglevel debug -f yuv4mpegpipe -i ~/Documents/example.y4m -pix_fmt yuv420p -vcodec libx264 -vprofile baseline -pass 1 -maxrate 640k -minrate 128k -framerate 20 -g 20 -f flv ~/Documents/test_out.flv

    ./ffmpeg_g -loglevel debug -f yuv4mpegpipe -i /sdcard/ffmpeg/test.y4m -pix_fmt yuv420p -vcodec libx264 -vprofile baseline -pass 1 -maxrate 640k -minrate 128k -framerate 20 -g 20 -f flv /sdcard/ffmpeg/test_out.flv


    ./ffmpeg_g -loglevel debug -f yuv4mpegpipe -i /sdcard/ffmpeg/test.y4m -pix_fmt yuv420p -f yuv4mpegpipe /sdcard/ffmpeg/test_out.yuv


    ./ffmpeg_g -loglevel debug -f yuv4mpegpipe -i /sdcard/ffmpeg/test.y4m -pix_fmt yuv420p -vcodec libx264 -vprofile baseline -pass 1 -maxrate 640k -minrate 128k -framerate 20 -g 20 -f flv /sdcard/ffmpeg/test_out.yuv


    ./ffmpeg_g -loglevel debug -f yuv4mpegpipe -listen 1 -i unix://data/ffmpeg/zunix_video -pix_fmt yuv420p -vcodec libx264 -vprofile baseline -maxrate 640k -minrate 128k -framerate 20 -g 20 -f flv /sdcard/ffmpeg/test_out.flv

    ./ffmpeg_g -loglevel debug -f yuv4mpegpipe -listen 1 -i unix://sdcard/ffmpeg/zunix_video -pix_fmt yuv420p -vcodec libx264 -vprofile baseline -maxrate 640k -minrate 128k -framerate 20 -g 20 -keyint_min 10 -bf 0 -b_strategy 0 -sc_threshold 0 -intra-refresh auto -flags global_header -mixed-refs 1 -f flv $url
}

exit 0