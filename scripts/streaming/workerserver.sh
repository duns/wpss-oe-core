#!/bin/bash
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"
STREAMNAME=worker0
PORTMJPG=8090
PORTRTP=8091
PORTRTSP=8092
PORTMP4=8093
VIDEODEV="/dev/video0"


[ -n "${1}" ] && STREAMNAME="${1}"
[ -n "${2}" ] && PORTMJPG="${2}"
[ -n "${3}" ] && PORTRTP="${3}"
[ -n "${4}" ] && PORTRTSP="${4}"
[ -n "${5}" ] && PORTMP4="${5}"
[ -n "${6}" ] && VIDEODEV="${6}"



SERVERIP=192.168.3.204
SERVERIP=10.8.1.6
MJPEGVBRATE=1500
H264VBRATE=512
FRAMERATE=20
SCALEWIDTH=640
SCALEHEIGHT=480




CAPSSTRING='\"Z01AFuygUB7YCIAAAAMAu5rKAAeLFss\\=\\,aOvssg\\=\\=\"'
CAPSSTRING='\"Z0KAHukDwXvLCAAAH0AAB1MAIAA\\=\\,aM48gAA\\=\"' # 480x360
CAPSSTRING='\"Z0KAHukCg+QgAAB9AAAdTACAAA\\=\\=\\,aM48gAA\\=\"' # 320x240

[ -n "$1" ] && STREAMNAME="$1"

launch_videodev()
{
	echo gst-launch  udpsrc caps="application/x-rtp,media=(string)video,framerate=${FRAMERATE}/1,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)${CAPSSTRING}" port=5000 !  rtph264depay ! ffdec_h264 ! videoscale ! video/x-raw-yuv,width=${SCALEWIDTH},height=${SCALEHEIGHT} !  v4l2sink device=${VIDEODEV}
	gst-launch  -vvv udpsrc caps="application/x-rtp,media=(string)video,framerate=${FRAMERATE}/1,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96,sprop-parameter-sets=(string)${CAPSSTRING}" port=5000 !  rtph264depay ! ffdec_h264 ! videoscale ! video/x-raw-yuv,width=${SCALEWIDTH},height=${SCALEHEIGHT} !  v4l2sink device=${VIDEODEV}
}

launch_streamserver()
{
	while true
		do

cvlc --play-and-exit  -q v4l2://${VIDEODEV} --sout="#duplicate{dst=\"transcode{width=320,height=240,fps=15,vcodec=h264,vb=${H264VBRATE},scale=1,sfilter=marq{marquee=[%d-%m-%Y %H:%M:%S],position=8,size=18},acodec=none,venc=x264{aud,profile=baseline,level=30,keyint=15,min-keyint=15,ref=1,nocabac}}:duplicate{dst=std{access=livehttp{seglen=2,delsegs=false,numsegs=15,index=/var/www/streaming/${STREAMNAME}.m3u8,index-url=http://${SERVERIP}/streaming/${STREAMNAME}-########.ts},mux=ts{use-key-frames},dst=/var/www/streaming/${STREAMNAME}-########.ts},dst=std{access=http,mux=ts,dst=:${PORTMP4}/${STREAMNAME}.mp4},dst=rtp{dst=${SERVERIP},port=${PORTRTP},sdp=rtsp://${SERVERIP}:${PORTRTSP}/${STREAMNAME}.sdp}}\",dst=\"transcode{fps=15,vcodec=mjpg,vb=${MJPEGVBRATE},sfilter=marq{marquee=[%d-%m-%Y %H:%M:%S],position=8,size=18}}:standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=${SERVERIP}:${PORTMJPG}/${STREAMNAME}.mjpg\"}}" #2>/dev/null
		sleep 2
	done
}

control_c()
# run if user hits control-c
{
  echo -en "\nExiting\n"
	  for (( CHILDNUM=1; CHILDNUM<=CHILDS; CHILDNUM ++ ))
		  do
			  PID=${CPID[${CHILDNUM}]}
#PGID=`ps -p ${PID} -o "%r"|awk '{print $NF}'`
PGID=`ps --no-headers -p ${PID} -o "%r"`
	echo Child pid=${PID} group=${PGID}
	echo kill -SIGTERM -$PID
#	kill -SIGTERM -$PGID
kill -SIGTERM $PID
	sleep 1
kill -SIGKILL $PID 2>/dev/null
#	kill -SIGKILL -$PGID
		done

   exit 0
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT

echo launching videodev
launch_videodev & 
CPID[1]=$!
CHILDS=1
echo launching stream server
launch_streamserver &
CPID[2]=$!
CHILDS=2
wait
