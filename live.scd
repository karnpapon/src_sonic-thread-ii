(
Pdef(\inst_name_sin,
  Pbind(*[
    type: \cln,
    snd: \sin,
    scale: Pseq([Scale.minorPentatonic, Scale.melodicMinor],inf),
    degree: Pseq([
      [0,2,4,8],
      [0,2,3,10]
    ],inf),
    octave: 3,
    atk: 4,
    amp: 0.5,
    dst: Pexprand(0.01,0.2),
    shp: 1,
    sac: 0.0,
    slo: 0.2,
    shi: Pwhite(0,0.5),
    sho: 1,
    lot: Pwhite(0,0.5),
    hit: 1,
    tri: 1, 
    cav: 0.1,
    cvt: 0.2,
    dlf: 0.94,
    dlt: 1/2 / Pdup(
          Pwrand([1, 2, 3], [256, 16, 1].normalizeSum,inf),
          Pbrown(1, 199, Prand((1 .. 19), inf))
    ),
    dur: Pkey(\atk,inf)* 1,
    sustain: Pkey(\atk,inf) * 1,
    rel: Pkey(\atk,inf) * Pexprand(2,3,inf),
  ])
).play(~tempo, quant: 4)
)

(
Pdef(0,
  Pbind(*[
    type: \cln,
    snd: \kps,
    amp: Pexprand(0.5,1.01),
    freq: 24*Prand([1,2,4,8,16],inf)*(1 .. 3),
    dur: 1/Pdup(Pwhite(5,11),Pwhite(5,11)),
    sustain: Pexprand(0.5,4.0),
    hpf: Pexprand(20,20000),
    pan: Pwhite(0.0,1.0),
    ])
).play(~tempo, quant: 4);
)

( 
Pdef(0,
    Pbind(*[
        type: \cln,
        rps: Pwhite(33,333),
        snd: \fpc,
        num: Pxshuf((0..5),inf),
        amp: Pdup(Pkey(\rps),Pwhite(1.0,4.0)),
        dur: 11/Pdup(Pkey(\rps),Pwhite(5,22))/Pn(Pgeom(1,2,19),inf),
        bgn: 0.5-Pexprand(0.01,0.5),
        pan: Pwhite(0.0,1.0),
        cai: 0.25,
        cav: 0.5,
        spd: 0.666-Pwrand([0,1.332],[10,1].normalizeSum,inf)/1,
        dla: 1/32,
        dlf: 0.95,
        dlt: 2.0625/Pdup(2,Pn(Pgeom(1,2,14),inf)),
    ])
).play;
)

(
Pdef(1,
  Pbind(*[
    type: \cln,
    snd: \fpc,
    frm: Pseg(Pseq([0.5, 1],inf), Pseq([8, 4],inf), \lin, 1),
    num: Pseq((5..12),inf),
    dur: 1 / Pxshuf([2, 4, 6,8],inf),
    cav: 0.25,
    cai: 0.2,
    amp: 0.25,
    tri: 0.5,
    dst: Pseq([0.5, 0.25, 0.75, 1.0], inf),
    shp: Pseq((0.5 .. 1.0), inf),
    shi: Pkey(\frm).linlin(0.0, 0.8, 0.01, 0.5),
    slo: Pkey(\frm).linlin(0.0, 0.7, 0.9, 0.1),
    lot: Pkey(\frm).linexp(0.0, 0.6, 0.3, 0.1),
    hit: Pkey(\frm).linlin(0.0, 0.5, 0.7, 0.3),
    hr1: Pkey(\frm).linexp(0.25, 0.75, 1, 2),
    fdb: Pkey(\frm).linlin(0.35, 0.85, 1, 10),
    mi1: Pkey(\frm).linlin(0.4, 0.90, 1, 10),
    mi2: Pkey(\frm).linlin(0.45, 0.95, 1, 10),
    mi3: Pkey(\frm).linlin(0.5, 1.0, 1, 10),    
    octave: 4,
  ])
).play(~tempo, quant: 4);
)

Pdef(0).stop;


(
Pdef(0,
    Pseed(5,
        Pbind(*[
            type: \cln,
            snd: Pwrand2([\drm, \hat], [100, 1], inf),
            dur: 0.5 / Pdup(12, Pwrand2([0, 0.5], [10, 1], inf)),
            legato: Pseg(Plprand(0.25, 4.0), Plprand(30.0, 90.0), \wel, inf),
            sustain: Pseg(Plprand(0.25, 4.0), Plprand(30.0, 90.0), \wel, inf),
            shp: Pseg(Phprand(0.25, 1.0), Plprand(30.0, 90.0), \wel, inf),
            sho: Pseg(Pwhite(0.0, 1.0), Plprand(30.0, 90.0), \wel, inf),
            hit: Pseg(Pwhite(0.0, 1.0), Plprand(30.0, 90.0), \wel, inf),
            lot: Pseg(Pwhite(0.0, 1.0), Plprand(30.0, 90.0), \wel, inf),
            sha: 0.5,
            pan: Pmeanrand(0.0, 1.0),
            tun: Pdup(Plprand(9, 99), Plprand(0.0, 7.0)),
            dla: 1/2,
            dlf: 0.5,
            dlt: 0.333 / 3,
            rma: 1,
            rmf: (Pdup(Plprand(9, 99), Pkey(\dur)) * 2500),
            fsh: Pdup(Plprand(9, 99), Pmeanrand(-4.0, 4.0)),
            ocu: Pseg(Phprand(0.0, 1.0), Plprand(30.0, 90.0), \wel, inf),
            ocq: Pseg(Phprand(0.0, 1.0), Plprand(30.0, 90.0), \wel, inf),
            amp: Pdup(Plprand(9, 99), Plprand(0.25, 4.0)),
        ])
    )
).play;
)

CmdPeriod.run;