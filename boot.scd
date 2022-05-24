(
  s.options.outDevice	= "BlackHole 16ch"; // routing to external (eg. Reaper or in this case PureData)
  s.options.numBuffers = 1024 * 64; 
  s.options.numWireBufs = 128; 
  s.options.memSize = 4096 * 256; 
  s.options.maxNodes = 1024 * 32; 
  s.options.numInputBusChannels = 0;
  s.options.numOutputBusChannels = 8;
  s.recSampleFormat = "int24";
  s.recHeaderFormat="wav";
  s.latency = 0.3;

	~tempo = TempoClock.new(112/60).permanent_(true);
	~parser = TheoryNoteParser.new;
	~bufPath = "/Users/karnpaponboonput/Desktop/fpc";
  ~flood = {|what, pre|
		var string = "";
		var prefix = if(pre.isNil, {">>>>"},{pre});
		string = "% %".format(prefix, what);
		string.postln;
	};

	//(10.do{~flood.(">>>>");})

	s.waitForBoot {
		~clean = SuperClean(2, s);
		~clean.loadSoundFiles;
		s.sync;
		~clean.start([0,2,4,6]);
		s.sync;
		SuperClean.default = ~clean;
		"[ SuperClean up + running ]".postln;
	};
)

~clean.loadSoundFiles(~bufPath);
