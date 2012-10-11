#!/bin/bash
WIDTH=320
HEIGHT=240
WIDTH=640
HEIGHT=480
FRAMERATE=15
gst-launch -v videotestsrc ! video/x-raw-yuv,width=${WIDTH},height=${HEIGHT},framerate=${FRAMERATE}/1 ! x264enc bitrate=256 ! rtph264pay name=pay0 pt=96 ! udpsink port=5000 host=192.168.3.204 &


