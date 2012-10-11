class CommandServer:
	def __init__(self):
		self.host = '' 
	        self.port = 50000 
	        self.backlog = 5 
	        self.size = 1024 
	        self.server = None 
	        self.threads = [] 


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
		
		self.player = gst.Pipeline("player")
		source = gst.element_factory_make("videotestsrc", "file-source")
		demuxer = gst.element_factory_make("mpegdemux", "demuxer")
		demuxer.connect("pad-added", self.demuxer_callback)
		self.video_decoder = gst.element_factory_make("mpeg2dec", "video-decoder")
		jpg_decoder = gst.element_factory_make("jpegdec", "jpg-decoder")
		jpg_source = gst.element_factory_make("multifilesrc", "jpg-source")
		jpg_source.set_property("location", "/home/chpap/syslinux/syslinux-4.04/sample/syslinux_splash.jpg")
		png_decoder = gst.element_factory_make("pngdec", "png-decoder")
		png_source = gst.element_factory_make("multifilesrc", "png-source")
		png_source.props.caps = gst.Caps("image/png,framerate=1/1")
		png_source.set_property("location", "/usr/share/app-install/icons/debian-logo.png")
		mixer = gst.element_factory_make("videomixer", "mixer")
		self.audio_decoder = gst.element_factory_make("mad", "audio-decoder")
		audioconv = gst.element_factory_make("audioconvert", "converter")
		audiosink = gst.element_factory_make("autoaudiosink", "audio-output")
		videosink = gst.element_factory_make("autovideosink", "video-output")
		self.queuea = gst.element_factory_make("queue", "queuea")
		self.queuev = gst.element_factory_make("queue", "queuev")
		ffmpeg1 = gst.element_factory_make("ffmpegcolorspace", "ffmpeg1")
		ffmpeg2 = gst.element_factory_make("ffmpegcolorspace", "ffmpeg2")
		ffmpeg3 = gst.element_factory_make("ffmpegcolorspace", "ffmpeg3")
		videobox = gst.element_factory_make("videobox", "videobox")
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
		
	def start_stop(self, w):
		if self.button.get_label() == "Start":
			filepath = self.entry.get_text()
#			if os.path.isfile(filepath):
			self.button.set_label("Stop")
#				self.player.get_by_name("file-source").set_property("location", filepath)
			self.player.get_by_name("file-source").set_property("is-live", True)
			self.player.set_state(gst.STATE_PLAYING)
		else:
			self.player.set_state(gst.STATE_NULL)
			self.button.set_label("Start")
						
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
		
GTK_Main()
gtk.gdk.threads_init()
gtk.main()
