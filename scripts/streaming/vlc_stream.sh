#!/bin/bash
cvlc dc1394://cameraindex=1:size=640x480   --sout='#transcode{vcodec=mp4v,vb=3000,keyint=30,threads=2}:rtp{mux=ts,dst=zaphod,port=5004,caching=0}'
