(

var basename = 'nanokontrol_';
var numChans = 2;
var lagtime = 0.1;

SynthDef(basename ++ 'amp', {|envatt = 0.01, envrel = 0.01, bus, outbus|
  var sig = In.ar(bus, numChans).sum;
  sig = Amplitude.kr(sig, envatt, envrel);
  Out.kr(outbus, sig);
}, lagtime.dup(2)).add;

SynthDef(basename ++ 'player', {
  |out, bus, sndbuf, envbuf, gate, imphz=1, pos=0 |
  var grain, spos, trig, chainL, chainR, output;
  trig = Impulse.kr(imphz);
  spos = TIRand.kr(0, BufFrames.kr(sndbuf)-1, trig);
  grain = GrainBuf.ar(
    2,
    gate,
    LFNoise2.kr(LFNoise2.kr(0.5).range(0.01, 3)).range(0.1, 1),
    sndbuf,
    1,
    spos,
    2,
    LFNoise2.kr(LFNoise2.kr(10).range(0.5, 4)).range(-1, 1),
    envbuf);
  output = grain;

  Out.ar(bus, output);
}).add;

SynthDef(basename ++ 'clouds', { |out, mode=0, freeze=0, dry=0|
  var signal;
	var position = LFNoise1.kr(0.5,0.5,0.5);
	var dens = LFNoise1.kr(0.3).range(0.3, 0.45);
  signal = In.ar(out, 2);
  ReplaceOut.ar(out, MiClouds.ar(signal, 0, position, 0.1, 1, 0.5, drywet: dry, freeze: freeze, mode: mode));
}).add;


SynthDef(basename ++ 'lpf' , {|cutoff = 1, bus|
  var sig = LPF.ar(In.ar(bus, numChans), cutoff.linexp(0.0, 1.0, 40, 20000));
  ReplaceOut.ar(bus, sig)
}, lagtime).add;

SynthDef(basename ++ 'hpf' , {|cutoff = 1, bus|
  var sig = HPF.ar(In.ar(bus, numChans), cutoff.linexp(0.0, 1.0, 20000, 40));
  ReplaceOut.ar(bus, sig)
}, lagtime).add;

SynthDef(basename ++ 'comp' , {|slopeBelow = 1, bus|
  var sig = In.ar(bus, numChans);
  sig =  Compander.ar(sig, sig,
      thresh: 0.9,
      slopeBelow: slopeBelow,
      slopeAbove: 0.5, // Ratio, 1/3 == 3: 1
      clampTime:  0.01,
      relaxTime:  0.1
  );
  ReplaceOut.ar(bus, sig)
}, lagtime).add;

SynthDef(basename ++ 'eq' , {|loBoost = 0, hiBoost = 0, q = 0.3, hiFreq = 3000,  loFreq = 250, bus|
  var sig = In.ar(bus, numChans);
  sig = MidEQ.ar(sig, loFreq, q.linlin(0.0, 1.0, 0.1, 1.0), loBoost.linlin(0.0, 1.0, - 12.0, 12.0));
  sig = MidEQ.ar(sig, hiFreq, q.linlin(0.0, 1.0, 0.1, 1.0), hiBoost.linlin(0.0, 1.0, - 12.0, 12.0));
  ReplaceOut.ar(bus, sig)
}, lagtime.dup(5)).add;

SynthDef(basename ++ 'shape', {
		|out, shape = 0, amp = 1.0,  amp_compensation_amount = 0.99, lo = 1, hi = 0, offset = 0, lo_thresh = 0, hi_thresh = 0|
		var abs, diff;
		var signal = In.ar(out, 2);
		shape = min(shape, 1.0 - 4e-10).explin(0.001, 1, 0.0, 0.999999);
		amp_compensation_amount = amp_compensation_amount.linlin(0.0,1.0,0.0001,1.0);
		amp = 1.0 - (amp_compensation_amount * shape / (shape +amp_compensation_amount )) * amp;
		shape = (1.0 * shape) / (1.0 - shape);
		signal = (1 + shape) * signal / (1 + (shape * abs(signal)));
		offset = offset.linlin(0.0,1.0,1.0,5.0);
		hi = hi * offset; lo = lo * offset;
		abs = hi - lo;
		lo_thresh = lo_thresh.linlin(0.0,1.0,-1.0,1.0);
		lo = lo + (abs * lo_thresh);
		hi_thresh = hi_thresh.linlin(0.0,1.0,-1.0,1.0);
		hi = hi - (abs * hi_thresh);
		signal = Fold.ar(signal, lo, hi);
		diff = 1 - (lo - hi + (hi * lo));
		ReplaceOut.ar(out, Limiter.ar(LeakDC.ar(signal * (amp+diff))));
	}).add;

SynthDef(basename ++ 'freqshift' , {|drywet = 0, freq = 0.5, bus|
  var in = In.ar(bus, numChans);
  var sig = FreqShift.ar(in, freq: freq.linexp(0.0, 1.0, 40, 4000), phase: 0);
  XOut.ar(bus, drywet, sig)
}, lagtime.dup(2)).add;

SynthDef(basename ++ 'verb', {|time = 1, size = 1, drywet = 0, modDepth = 0.1, bus|
  var sig = In.ar(bus, numChans);
  sig = JPverb.ar(sig, t60: time,
      damp: 1 - drywet,
      size: size.linlin(0.0, 1.0, 0.1, 5.0),
      earlyDiff: modDepth.linlin(0.0, 1.0, 1.0, 0.5),
      modDepth: modDepth.linlin(0.0, 1.0, 0.01, 1.0),
      modFreq: 2,
      lowcut: 500, highcut: 2000);
  XOut.ar(bus, drywet, sig);
}, lagtime.dup(4)).add;

SynthDef(basename ++ 'sub', {|freq = 0.5, subamp, drywet = 0, bus|
  var dry = In.ar(bus, numChans);
  var sig = SinOsc.ar(freq.linlin(0.0, 1.0, 40, 120),
      0,
      (subamp * 4).clip(0, 1)
  );
  sig = LPF.ar(sig, 150);
  sig = dry + sig;
  sig = LeakDC.ar(sig);
  XOut.ar(bus, drywet, sig);
}, lagtime.dup(3)).add;


SynthDef(basename ++ 'grain', {|grainsize = 0.25, grainrand = 0.8, drywet = 1, fbGain = 0, bus|
  var input = In.ar(bus, numChans);
  var bufLength = 1.0;
  var localBuf = LocalBuf(bufLength * SampleRate.ir, numChans).clear;

  var warp = Warp1.ar(
      numChans,
      localBuf,
      LFSaw.ar(1/bufLength).range(0, 1),
      Drand([ 2, - 2 ], inf),
      grainsize.linlin(0.0, 1.0, 2.0, 0.31),
      - 1,
      2,
      grainrand.linlin(0.0, 1.0, 0.2, 1.0),
      4
  );

  // record w/ feedback
  RecordBuf.ar(tanh(input + HPF.ar(tanh(warp * fbGain), 30)), localBuf);
  warp = warp.tanh;
  warp = HPF.ar(warp * 0.5, 150);
  warp = warp.sanitize;
  XOut.ar(bus, drywet, warp);
}, lagtime.dup(4)).add;

SynthDef(basename ++ 'out', {|bus|
	var in = In.ar(bus, numChans);
	// apply limiter
  var sig = Compander.ar(in, in,
      thresh: 0.75,
      slopeBelow: 1,
      slopeAbove: 0.1,
      clampTime:  0.01,
      relaxTime:  0.01
  );
  ReplaceOut.ar(0, sig * 0.5)
}).add;
)
