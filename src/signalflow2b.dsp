import("../../faust-libraries/seam.lib");

//-----------------------signal flow 2b-----------------------
//Role of the signal flow block: signal processing of audio input from mic1 and mic2, and mixing of all audio signals

var1 = 12;

signal_flow_2b(timeIndex1,timeIndex2,triangle3,graIN,sig1,sig2,sig3,sig4,sig5,sig6,sig7, memWriteDel1, memWriteDel2, memWriteLev, cntrlLev1,cntrlLev2) =
((
sds.granular_sampling(8,var1,timeIndex1,memWriteDel1,cntrlLev1,21, graIN),//TODO da cambiare oscillatore
sds.granular_sampling(8,var1,timeIndex2,memWriteDel2,cntrlLev2,20, graIN)
//granular_sampling1(timeIndex1,memWriteDel1,cntrlLev1,21), granular_sampling1(timeIndex2,memWriteDel2,cntrlLev2,20)
<:
 _,_,   *(1-(memWriteLev)),*(1-(memWriteLev)),*(memWriteLev),*(memWriteLev)) : _,_,_,_,ro.cross(2)),
(sig5 <: _,de.delay(sds.delMax, ba.sec2samp(0.05)) <:
    _*(triangle3),_*(triangle3), _*(1-triangle3),_*(1-triangle3)),
((sig6 <: _,de.delay(sds.delMax, ba.sec2samp(0.036)) <:
    _*(1-triangle3),_*(1-triangle3),_*(triangle3),_*(triangle3)) : ro.cross(2),ro.cross(2)),
sig1,sig2,sig2,sig3,sig4,sig7 : _,_,(si.bus(18):> _,_);

process = signal_flow_2b;
