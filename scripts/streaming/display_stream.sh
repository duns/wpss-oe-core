#!/bin/bash
RTSPSERVBIN=/usr/src/gst-rtsp-0.10.8/examples/test-launch
RTSPSERVBIN=gst-launch
ARGS=' ( videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96 ) '
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,ssrc=(uint)2353780166,clock-base=(uint)658675883,seqnum-base=(uint)53279'
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukCg+QgAAB9AAAdTACAAA\\=\\=\\,aM48gAA\\=\"'
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukBQHpCAAAH0AAB1MAIAA\\=\\=\\,aM48gAA\\=\"'
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukCg+QgAAB9AAAdTACAAA\\=\\=\\,aM48gAA\\=\"'
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z01AFeygoP2AiAAAAwALuaygAHixbLA\\=\\,aOvssg\\=\\=\"'
CAPS='application/x-rtp,media=video,clock-rate=90000,encoding-name=H264,payload=96,sprop-parameter-sets=\"Z0KAHukBQHpCAAAH0AAB1MAIAA\\=\\=\\,aM48gAA\\=\"'
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z01AFeygoP2AiAAAAwALuaygAHixbLA\\=\\,aOvssg\\=\\=\"'

#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264'
ARGS=" ( udpsrc caps=$CAPS port=5000 ! rtph264depay ! ffdec_h264 !  x264enc ! rtph264pay name=pay0 pt=96  ) "

ARGS=" udpsrc caps=$CAPS port=5000 ! rtph264depay ! ffdec_h264 ! ffmpegcolorspace ! ximagesink "
ARGS=" udpsrc caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG,payload=(int)96 port=5000 ! rtpjpegdepay ! videorate ! image/jpeg,framerate=15/1 ! queue !   jpegdec ! ffmpegcolorspace ! ximagesink " #JPEG
#ARGS=' ( udpsrc 'caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264' port=5000 ) '
#ARGS=' ( udpsrc 'caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264' port=5000 ! rtph264depay ! ffdec_h264 ! ffmpegcolorspace ! x264enc ! rtph264pay name=pay0 pt=96 ) '
#ARGS=" videotestsrc !  ffmpegcolorspace ! ximagesink "

echo $RTSPSERVBIN $ARGS
$RTSPSERVBIN -v  ${ARGS}
