#!/usr/bin/python

import sys, os
import pygtk, gtk, gobject
import pygst
import time
pygst.require("0.10")
import re
import gst
import select 
import socket 
import threading

def recv_timeout(the_socket,the_size,timeout=2):
#	the_socket.setblocking(0)
	the_socket.settimeout(timeout)
#	total_data=[];data='';begin=time.time()
#	while 1:
#if you got some data, then break after wait sec
#		if total_data and time.time()-begin>timeout:
#			break
#if you got no data at all, wait a little longer
#		elif time.time()-begin>timeout*2:
#			break
#		try:
#			data=the_socket.recv(the_size)
#			if data:
#				total_data.append(data)
#				begin=time.time()
#			else:
#				time.sleep(0.1)
#		except:
#			pass
#	return ''.join(total_data)
	data=the_socket.recv(the_size)
	return data



class HandleCommand:
	def __init__(self): 
		init=1
	def commdict(self,strr,optargs):
		return { 
			'stop' : lambda argg :  self.stop(),
			'overlay' : lambda argg :  self.overlay(argg),
			'play' : lambda argg :  self.play(),
			'quit' : lambda argg :  self.quit(),
			'nop'  : lambda argg : self.nop(),
		     	'echo'  : lambda argg : self.echo(argg),
		}[strr](optargs)
	def overlay(self,optargs):
#		optpairs=re.split(' |,',optpair)
		optpairs=str.split(optargs)
		for optpair in optpairs:
			ppair=re.split('=',optpair)
			{
				'location' : lambda argg : G.setoverlay('location',argg)  ,
				'alpha' : lambda argg : G.setoverlay('alpha',argg)  ,
				'xpos' : lambda argg : G.setoverlay('xpos',argg)  ,
				'ypos' : lambda argg : G.setoverlay('ypos',argg)  ,
			}[ppair[0]](ppair[1])

		return 0
	def stop(self):
		G.start_stop_stream("Stop")
		return 0
	def play(self):
		G.start_stop_stream("Start")
		return 0
	def nop(self):
		return 0
	def quit(self):
		print "quit"
		return -1
	def echo(self,str):
		print str
		return 0
	def handle(self,comm): 
		print "Got" + comm
		return 1
	def stringdecode(self,strbuf): 
		commands=re.split(';|:|\n|\r',strbuf)
		for commandline in commands:
			if commandline:
				comm=commandline.split()	
#				optargs=join(comm[1:-1])
				optlength=len(comm)
				optargs=' '.join(comm[1:optlength])
#				print "command: " + comm[0] + "|" + optargs

				try:
					a=1
#					self.commdict['quit'](optargs)
					ret=self.commdict(comm[0],optargs)
					if ret == -1 :
						print "will quit"
#						cs.close()
#						os.kill(os.getpid(), signal.SIGTERM)
#						os.kill(os.getgid(), signal.SIGTERM)
#						sys.exit(1)

				except:
					print "invalid command"
		return 1

hc=HandleCommand()	

class Server(threading.Thread): 
	def __init__(self): 
		threading.Thread.__init__(self)
		self.host = '' 
		self.port = 50000 
		self.backlog = 5 
		self.size = 1024 
		self.server = None 
		self.threads = [] 
		self.running = 0

	def open_socket(self): 
		try: 
			self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
			self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
			self.server.bind((self.host,self.port)) 
			self.server.listen(5) 
		except socket.error, (value,message): 
			if self.server: 
				self.server.close() 
			print "Could not open socket: " + message 
			sys.exit(1) 

	def run(self): 
		self.open_socket() 
		input = [self.server,sys.stdin] 
		self.running = 1 
		while self.running: 
#			print "select"
			inputready,outputready,exceptready = select.select(input,[],[],1) 
#			print "selected"
			for s in inputready: 
				if s == self.server: 
# handle the server socket 
       					c = Client(self.server.accept()) 
					c.start() 
					self.threads.append(c) 

				elif s == sys.stdin: 
# handle standard input 
					junk = sys.stdin.readline() 
					res = hc.stringdecode(junk)
					if res == 0:
						self.running = 0 
		print "server close"				
#		self.server.shutdown(1) 
		self.server.close() 
		self.running=-1

# close all threads 

	def close(self):
		self.running=0
#		print "join"
		for c in self.threads: 
			print "client close"				
#			c.shutdown(1) 
			c.close() 
			c.join() 
		while self.running == 0:
			time.sleep(0.1)
#		print "joined"

class Client(threading.Thread): 
	def __init__(self,(client,address)): 
		threading.Thread.__init__(self) 
		self.client = client 
		self.address = address 
		self.size = 1024 
		self.running=0

	def close(self): 
		self.running=0
		self.client.close() 
	def run(self): 
		self.running = 1 
		while self.running: 
			try:
				data = recv_timeout(self.client,self.size) 
				res = hc.stringdecode(data)
				if res == -1:
					print "-1"
					self.running = 0 
#				self.client.send(data) 
			except socket.timeout:
			  	continue
#			except:
			except socket.error, (value,message): 
				print "socket error: " + message
				self.running = 0 
				break  
			except : 
				print "Unexpected error: ", sys.exc_info()[0]
				self.running = 0 
				break  
		self.client.close() 

class CommandServer:
	def __init__(self):
	        self.threads = [] 
	def run(self):
       		s = Server() 
		s.start() 
		self.threads.append(s) 
	def close(self):
		for s in self.threads: 
			s.close();
			s.join() 


class GTK_Main:
	
	def __init__(self):
		window = gtk.Window(gtk.WINDOW_TOPLEVEL)
		window.set_title("Mpeg2-Player")
		window.set_default_size(500, 400)
		window.connect("destroy", gtk.main_quit, "WM destroy")
		vbox = gtk.VBox()
		window.add(vbox)
		hbox = gtk.HBox()
		vbox.pack_start(hbox, False)
		self.entry = gtk.Entry()
		hbox.add(self.entry)
		self.button = gtk.Button("Start")
		hbox.pack_start(self.button, False)
		self.button.connect("clicked", self.start_stop)
		self.movie_window = gtk.DrawingArea()
		vbox.add(self.movie_window)
		window.show_all()
		self.init_pipeline()

	def init_pipeline(self):
		self.player = gst.Pipeline("player")
		source = gst.element_factory_make("videotestsrc", "file-source")
		demuxer = gst.element_factory_make("mpegdemux", "demuxer")
		demuxer.connect("pad-added", self.demuxer_callback)
		self.video_decoder = gst.element_factory_make("mpeg2dec", "video-decoder")
#		jpg_decoder = gst.element_factory_make("jpegdec", "jpg-decoder")
#		jpg_source = gst.element_factory_make("multifilesrc", "jpg-source")
#		jpg_source.set_property("location", "/home/chpap/syslinux/syslinux-4.04/sample/syslinux_splash.jpg")
#		self.jpg_source=jpg_source
		png_decoder = gst.element_factory_make("pngdec", "png-decoder")
		png_source = gst.element_factory_make("multifilesrc", "png-source")
		png_source.props.caps = gst.Caps("image/png,framerate=1/1")
		png_source.set_property("location", "/usr/share/app-install/icons/debian-logo.png")
		mixer = gst.element_factory_make("videomixer", "mixer")
		self.audio_decoder = gst.element_factory_make("mad", "audio-decoder")
		audioconv = gst.element_factory_make("audioconvert", "converter")
		audiosink = gst.element_factory_make("autoaudiosink", "audio-output")
#		videosink = gst.element_factory_make("autovideosink", "video-output")
		videosink = gst.element_factory_make("ximagesink", "video-output")
		self.queuea = gst.element_factory_make("queue", "queuea")
		self.queuev = gst.element_factory_make("queue", "queuev")
		ffmpeg1 = gst.element_factory_make("ffmpegcolorspace", "ffmpeg1")
		ffmpeg2 = gst.element_factory_make("ffmpegcolorspace", "ffmpeg2")
		ffmpeg3 = gst.element_factory_make("ffmpegcolorspace", "ffmpeg3")
		videobox = gst.element_factory_make("videobox", "videobox")
		self.videobox=videobox
		alphacolor = gst.element_factory_make("alphacolor", "alphacolor")
		
		self.player.add(source, mixer, videosink,  self.queuev, ffmpeg1, ffmpeg2 , png_source, png_decoder, videobox, alphacolor, ffmpeg3)
#		self.player.add(source, mixer, videosink,  self.queuev, ffmpeg1, ffmpeg2 , jpg_source, jpg_decoder, videobox, alphacolor, ffmpeg3)
#		self.player.add(source, demuxer, self.video_decoder, png_decoder, png_source, mixer,
#			self.audio_decoder, audioconv, audiosink, videosink, self.queuea, self.queuev,
#			ffmpeg1, ffmpeg2, ffmpeg3, videobox, alphacolor)
#		gst.element_link_many(source, demuxer)
#		gst.element_link_many(self.queuev, self.video_decoder, ffmpeg1, mixer, ffmpeg2, videosink)
		gst.element_link_many(source, self.queuev , ffmpeg1,  mixer, ffmpeg2, videosink)
		gst.element_link_many(png_source, png_decoder, alphacolor, ffmpeg3, videobox, mixer)
#		gst.element_link_many(jpg_source, jpg_decoder, alphacolor, ffmpeg3, videobox, mixer)
#		gst.element_link_many(self.queuea, self.audio_decoder, audioconv, audiosink)
		
		bus = self.player.get_bus()
		bus.add_signal_watch()
		bus.enable_sync_message_emission()
		bus.connect("message", self.on_message)
		bus.connect("sync-message::element", self.on_sync_message)
		
		videobox.set_property("border-alpha", 0)
		videobox.set_property("alpha", 0.5)
		videobox.set_property("left", -10)
		videobox.set_property("top", -10)
	def setoverlay(self,prop,val):	
#		print str.atof(val)
		{
			'location' : lambda argg : self.jpg_source.set_property("location", arg) ,
			'alpha' : lambda argg : self.videobox.set_property("alpha",int(argg))  ,
			'xpos' : lambda argg : self.videobox.set_property("left",int(argg))  ,
			'ypos' : lambda argg : self.videobox.set_property("top",int(argg))  ,
		}[prop](val)
	def start_stop_stream(self,action):
		if action == "Start":
			filepath = self.entry.get_text()
#			if os.path.isfile(filepath):
			self.button.set_label("Stop")
			self.player.get_by_name("file-source").set_property("is-live", True)
			self.player.set_state(gst.STATE_PLAYING)
		else:
			self.player.set_state(gst.STATE_NULL)
			self.button.set_label("Start")


	def start_stop(self, w):
		self.start_stop_stream(self.button.get_label())
#				self.player.get_by_name("file-source").set_property("location", filepath)
						
	def on_message(self, bus, message):
		t = message.type
		if t == gst.MESSAGE_EOS:
			self.player.set_state(gst.STATE_NULL)
			self.button.set_label("Start")
		elif t == gst.MESSAGE_ERROR:
			err, debug = message.parse_error()
			print "Error: %s" % err, debug
			self.player.set_state(gst.STATE_NULL)
			self.button.set_label("Start")
	
	def on_sync_message(self, bus, message):
		if message.structure is None:
			return
		message_name = message.structure.get_name()
		if message_name == "prepare-xwindow-id":
			imagesink = message.src
			imagesink.set_property("force-aspect-ratio", True)
			imagesink.set_xwindow_id(self.movie_window.window.xid)
	
	def demuxer_callback(self, demuxer, pad):
		if pad.get_property("template").name_template == "video_%02d":
			queuev_pad = self.queuev.get_pad("sink")
			pad.link(queuev_pad)
		elif pad.get_property("template").name_template == "audio_%02d":
			queuea_pad = self.queuea.get_pad("sink")
			pad.link(queuea_pad)
		
try:		
	G=GTK_Main()
	gtk.gdk.threads_init()
	cs=CommandServer()
	cs.run()	
	gtk.main()
except KeyboardInterrupt:
	print "KeyboardInterrupt kkk"
	cs.close()
#	time.sleep(2)
	sys.exit(1)
	pass
