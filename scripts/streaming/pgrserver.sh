#gst-launch -v dc1394src ! queue ! videorate ! ffmpegcolorspace ! video/x-raw-yuv,width=640,height=480,framerate=15/1 ! x264enc tune=zerolatency byte-stream=true bitrate=300 ! rtph264pay ! udpsink port=5000 host=192.168.3.70 ts-offset=0 name=vrtpsink
SINK="ffmpegcolorspace ! ximagesink"
gst-launch -v dc1394src !  video/x-raw-gray,width=640,height=480,framerate=15/1 ! ${SINK}
#x264enc tune=zerolatency byte-stream=true bitrate=300 ! rtph264pay ! udpsink port=5000 host=127.0.0.1 ts-offset=0 name=vrtpsink
