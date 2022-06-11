import("seam.discipio.lib");

//------------------------------------------- signal flow 1a
/*signal_flow_1a(var1, var2, mic1, mic2, mic3, mic4) = mic1, mic2,(mic3, mic4 <: +,(
  _,_,(integrator(0.01), integrator(0.01) :
  delay(0.01,0.95),delay(0.01,0.95) :
  + :
  mapsum(_,6,6) <:
  _,_,_) :
  _,ro.cross(2),_,_  :
  localmax, localmax,_ :
  -,_ :
  localmax <:
  delay(12,0),_ :
  + :
  mapsum(_,0,0.5) :
  lp1p(0.5)) :
  _ ,(_<: _,_) :
  ro.cross(2),_ :
  _, (_<: _,_,_,_),_ :
  _,_,_,_,* :
  mapsub(_,1,1),
  (fi.highpass(3,var2) : integrator(0.05)),
  (fi.lowpass(3,var2) : integrator(0.1)),
  integrator(0.1),
  integrator(0.01) :
  _,-,_,_ :
  *,_,_:
  delay(0.01,0.995),
    delay(0.01,0.9),
    delay(0.01,0.995) :
par(i,3,fi.lowpass(5,25)):
mapsum(_,0.5,0.5),
(( mapsub(_^2,1,1)) <: delay(var1/2,0),delay(var1/3,0),_),
(_<: delay(var1/3,0),delay(var1/2,0), mapcond,_));*/
signal_flow_1a = component("signalflow1a.dsp").signal_flow_1a;



//------------------------------------------- signal flow 1b

/*signal_flow_1b(var1, var3, grainOut1, grainOut2, mic1, mic2, memWriteLev, cntrlMain) =
(
    mic1, mic2 : hp1(50),hp1(50) : lp1p(6000), lp1p(6000) : integrator(0.01), integrator(0.01) : delay(0.01,0.999), delay(0.01,0.999) : fi.lowpass(5, 0.5), fi.lowpass(5, 0.5)
    ),
    (
 grainOut1, grainOut2: + : integrator(0.01) : delay(0.01, 0.97) : fi.lowpass(5,0.5) <: _+delay(var1*(2), (1-var3)*(0.5)) : mapsub(_,1,0.5)
), (
    (timeIndex(var1)<: mapmul(_,-2,0.5),mapmul(_,1,0.5)), triangle1(var1, memWriteLev)*memWriteLev,triangle2(var1, cntrlMain), triangle3(var1)
)with{
    timeIndex(var1) = os.lf_trianglepos(1/(var1*(2)));
    triangle1(var1, memWriteLev) = os.lf_trianglepos(1/(var1*(6)));
    triangle2(var1, cntrlMain) = os.lf_trianglepos(var1*(1-cntrlMain));
    triangle3(var1) = os.lf_trianglepos(1/var1);
}
;*/
signal_flow_1b = component("signalflow1b.dsp").signal_flow_1b;


/*, cntrlMic1, cntrlMic2, directLevel, triangle1, triangle2, mic1, mic2, diffHL, memWriteDel1, memWriteDel2, memWriteLev, cntrlFeed, cntrlMain*/
signal_flop_2a(
  var1,
  var2,
  cntrlMic1,
  cntrlMic2,
  directLevel,
  triangle1,
  triangle2,
  mic1,
  mic2,
  diffHL,
  memWriteDel1,
  memWriteDel2,
  memWriteLev,
  cntrlFeed,
  cntrlMain
  ) = mic1,mic2,sampleread(ratio1, memchunk1), sampleread(ratio2, memchunk2), sampleread(ratio3, memchunk3), sampleread(ratio4, memchunk4), sampleread(ratio5, memchunk5) /* :
  hp1(50), hp1(50), par(i,5,fi.highpass(4, 50)) : lp1p(6000), lp1p(6000), de.delay(pm.l2s(var1)/2), de.delay(pm.l2s(var1)), de.delay(pm.l2s(var1)/1.5), de.delay(pm.l2s(var1)/3), de.delay(pm.l2s(var1)/2.5) : *(1-cntrlMic1), *(1-cntrlMic2) <:
  *(directLevel), *(directLevel), _, _ */

with{
        ratio1 = (var2+(diffHL*1000))/261;
        memchunk1 = (1-memWriteDel2);
        ratio2 = (var2+(diffHL*1000))/261;
        memchunk2 = (1-memWriteDel2);
        ratio3 = (var2+(diffHL*1000))/261;
        memchunk3 = (1-memWriteDel2);
         ratio4 = (var2+(diffHL*1000))/261;
        memchunk4 = (1-memWriteDel2);
         ratio5 = (var2+(diffHL*1000))/261;
        memchunk5 = (1-memWriteDel2);
};

//signal_flow_2b() = ;

//process = no.no.multinoise(2) : *(0.1),*(0.1) : signal_flow_1a;

//process = signal_flow_1b(no.noise*(0.1),no.pink_noise*(0.2), _, _, 0.5,23,1,23);

/*
process = signal_flow_1a(var1,var2) <:
si.bus(20) :
23, 42, _,_,!,!,!,_,!,!,!,_,
_,_,_,_,_,_,!,!,_,_
: (signal_flow_1b(var1,var3) <: si.bus(16)) , _,_,_,_,_,!,!,!:
!,!,!,_,_,!,!,_, signal_flow_2a(var1, var2);
*/
//ciccio = signal_flow_2a;

/*signal_flow_2a(
  var1,
  var2,
  cntrlMic1,
  cntrlMic2,
  directLevel,
  triangle1,
  triangle2,
  mic1,
  mic2,
  diffHL,
  memWriteDel1,
  memWriteDel2,
  memWriteLev,
  cntrlFeed,
  cntrlMain
  ) = (_ <:
(sampleread(ratio1, memchunk1), sampleread(ratio2, memchunk2), sampleread(ratio3, memchunk3) :
par(i,3,fi.highpass(4,50)) : si.bus(2), (_<: _,_):  de.delay(delMax,pm.l2s(var1)/2), de.delay(delMax,pm.l2s(var1)),(_<: fi.svf.bp(1000,1), fi.svf.bp(2000,1)), de.delay(delMax, pm.l2s(var1)/1.5)  :> (si.bus(4) :> _*(cntrlFeed)*(memWriteLev) <: _,_ : (_,(mic1 : hp1(50) : lp1p(6000) *(1-cntrlMic1)),(mic2 : hp1(50) : lp1p(6000) *(1-cntrlMic2)) <: _,_,_,_,_,_ : (_,_,_ :> *(triangle1)), !,*(directLevel),*(directLevel)) ,(*(memWriteLev) <: (de.delay(delMax,(0.05*ba.sec2samp(cntrlMain))) *(triangle2)*(directLevel)),*(1-triangle2)*(directLevel))),_), (sampleread(ratio4, memchunk4) : fi.highpass(4,50) : de.delay(delMax,pm.l2s(var1)/3)), (sampleread(ratio5, memchunk5) : fi.highpass(4,50) : de.delay(delMax,pm.l2s(var1)/2.5)) )~_ : !,si.bus(7) : si.bus(4),ro.crossNM(1,2)

with{
        ratio1 = (var2+(diffHL*1000))/261;
        memchunk1 = (1-memWriteDel2);
        ratio2 = (var2+(diffHL*1000))/261;
        memchunk2 = (1-memWriteDel2);
        ratio3 = (var2+(diffHL*1000))/261;
        memchunk3 = (1-memWriteDel2);
         ratio4 = (var2+(diffHL*1000))/261;
        memchunk4 = (1-memWriteDel2);
         ratio5 = (var2+(diffHL*1000))/261;
        memchunk5 = (1-memWriteDel2);
};*/
signal_flow_2a = component("signalflow2a.dsp").signal_flow_2a;


/*signal_flow_2b(timeIndex1,timeIndex2,triangle3,sig1,sig2,sig3,sig4,sig5,sig6,sig7, memWriteDel1, memWriteDel2, memWriteLev, cntrlLev1,cntrlLev2) =
((granular_sampling(timeIndex1,memWriteDel1,cntrlLev1,21),
granular_sampling(timeIndex2,memWriteDel2,cntrlLev2,20) <:
 _,_,   *(1-(memWriteLev)),*(1-(memWriteLev)),*(memWriteLev),*(memWriteLev)) : _,_,_,_,ro.cross(2)),
(sig5 <: _,de.delay(delMax, ba.sec2samp(0.05)) <:
    _*(triangle3),_*(triangle3), _*(1-triangle3),_*(1-triangle3)),
((sig6 <: _,de.delay(delMax, ba.sec2samp(0.036)) <:
    _*(1-triangle3),_*(1-triangle3),_*(triangle3),_*(triangle3)) : ro.cross(2),ro.cross(2)),
sig1,sig2,sig2,sig3,sig4,sig7 : _,_,(si.bus(18):> _,_);*/
signal_flow_2b = component("signalflow2b.dsp").signal_flow_2b;

/*signal_flow_3= _,_ <:
_,_,de.delay(delMax, (var4/2/344)), de.delay(delMax, (var4/2/344)),de.delay(delMax, (var4/344)), de.delay(delMax, (var4/344));*/
signal_flow_3 = component("signalflow3.dsp").signal_flow_3;

process = signal_flow_1a(var1,var2) <:
si.bus(30) :
(_, _, _,_,!,!,!,_,!,!,!,_,
_,_,_,_,_,_,!,!,_,_,
!,!,!,_,_,_,_,_,!,!:
(signal_flow_1b(var1,var3) <: si.bus(16)) , _,_,_,_,_,!,!,!,_,_,_,_,_:
!,!,!,_,_,!,!,_, signal_flow_2a(var1, var2),_,_,_,_,_ :
signal_flow_2b)~si.bus(2) : !,!,_,_ : signal_flow_3;
