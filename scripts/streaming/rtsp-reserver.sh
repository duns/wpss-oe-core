#!/bin/bash
RTSPSERVBIN=/usr/src/gst-rtsp-0.10.8/examples/test-launch
ARGS=' ( videotestsrc ! x264enc ! rtph264pay name=pay0 pt=96 ) '
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,ssrc=(uint)2353780166,clock-base=(uint)658675883,seqnum-base=(uint)53279'
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukCg+QgAAB9AAAdTACAAA\\=\\=\\,aM48gAA\\=\"'
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukBQHpCAAAH0AAB1MAIAA\\=\\=\\,aM48gAA\\=\"' # 640x480
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukBaHpCAAAH0AAB1MAIAA\\=\\=\\,aM48gAA\\=\"' # 720x480
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukBaCS88IAAAfQAAHUwAgA\\=\\,aM48gAA\\=\"' # 720x564
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukCg+QgAAB9AAAdTACAAA\\=\\=\\,aM48gAA\\=\"' # 320x240
CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukBQF7ywgAAB9AAAdTACAA\\=\\,aM48gAA\\=\"' # 640 360
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z0KAHukDwUkIAAAfQAAHUwAgAA\\=\\=\\,aM48gAA\\=\"' # 480x360
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z01AFeygoP2AiAAAAwALuaygAHixbLA\\=\\,aOvssg\\=\\=\"' # 320x480 testsrc
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z01AHuygUB7YCIAAAAMAu5rKAAeLFss\\=\\,aOvssg\\=\\=\"' # 640x480 testsrc
#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)\"Z01AFeygoP2AiAAAAwALuaygAHixbLA\\=\\,aOvssg\\=\\=\"'

#CAPS='application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264'
ARGS=" ( udpsrc caps=$CAPS port=5000 ! rtph264depay ! ffdec_h264 !  x264enc ! rtph264pay name=pay0 pt=96  ) "

ARGS=" ( udpsrc caps=$CAPS port=5000 ! rtph264depay !  rtph264pay name=pay0 pt=96  ) "
#ARGS=" ( udpsrc caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)JPEG,payload=(int)96 port=5000 ! rtpjpegdepay !  rtpjpegpay name=pay0 pt=96  ) " #MJPEG
#ARGS=' ( udpsrc 'caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264' port=5000 ) '
#ARGS=' ( udpsrc 'caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264' port=5000 ! rtph264depay ! ffdec_h264 ! ffmpegcolorspace ! x264enc ! rtph264pay name=pay0 pt=96 ) '

echo $RTSPSERVBIN $ARGS
$RTSPSERVBIN "$ARGS"
