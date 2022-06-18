import("seam.discipio.lib");

//-----------------------signal flow 2a-----------------------
//Role of the signal flow block: signal processing of audio input from mic1 and mic2, and mixing of all audio signals

signal_flow_2a(
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
};

process = signal_flow_2a;
