import("seam.lib");

//-----------------------signal flow 2a-----------------------
//Role of the signal flow block: signal processing of audio input from mic1 and mic2, and mixing of all audio signals

//--------------------Four variables are to be initialized prior to performance:
//VAR1
//distance (in meters) between the two farthest removed loudspeakers on the left-right axis.
var1 = 23;
//VAR2
//rough estimate of the center frequency in the spectrum of the room’s background noise (spectral centroid):
//to evaluate at rehearsal time, in a situation of "silence".
var2 = 1000;
//VAR3
//subjective estimate of how the room revereberance, valued between 0 ("no reverb") and 1 (“very long reverb”).
var3 = 1000;
//VAR4
//distance (in meters) between the two farthest removed loudspeakers on the front-rear axis.
var4 = 11;

signal_flow_2a(
              //variabili
              var1,
              var2,
              //microfoni
              mic1,
              mic2,
              //signal flow 1b
              cntrlMic1,
              cntrlMic2,
              directLevel,
              triangle1,
              triangle2,
              // signal flow 1a
              diffHL,
              memWriteDel1,
              memWriteDel2,
              memWriteLev,
              cntrlFeed,
              cntrlMain
              ) =
              (_ <:
(
sds.sampleRead(var1, (var2+(diffHL*1000)/261), (1-memWriteDel2)),
sds.sampleRead(var1, ((290-(diffHL*90))/261), ((memWriteLev+memWriteDel1)/2)),
sds.sampleRead(var1, (((var2*2)-(diffHL*1000))/261), (1-memWriteDel1)) :
                  par(i,3,fi.highpass(4,50)) :
                  si.bus(2), (_<: _,_):
                    de.delay(sds.delMax,pm.l2s(var1)/2),
                    de.delay(sds.delMax,pm.l2s(var1)),
                    (_<: sfi.bpbw(((var2/2)*memWriteDel2),diffHL*(400)), sfi.bpbw((var2*(1-memWriteDel1)),1-diffHL*(800))),
                    de.delay(sds.delMax, pm.l2s(var1)/1.5)  :> (si.bus(4) :>
                  _*(cntrlFeed)*(memWriteLev) <:
                  _,_ : (_,(mic1 : sfi.hp1a(50) : sfi.lp1pa(6000) *(1-cntrlMic1)),(mic2 : sfi.hp1a(50) : sfi.lp1pa(6000) *(1-cntrlMic2)) <:
                   _,_,_,_,_,_ : (_,_,_ :> *(triangle1)), !,*(directLevel),*(directLevel)) ,(*(memWriteLev) <:
                  (de.delay(sds.delMax,(0.05*ba.sec2samp(cntrlMain))) *(triangle2)*(directLevel)),
                  *(1-triangle2)*(directLevel))),_),
                  (
sds.sampleRead(var1, ((250+(diffHL*20))/261), 1)
: fi.highpass(4,50) : de.delay(sds.delMax,pm.l2s(var1)/3)),
                (
sds.sampleRead(var1, 0.766283, memWriteLev)
: fi.highpass(4,50) : de.delay(sds.delMax,pm.l2s(var1)/2.5)))~_ :
                  _,si.bus(7) : si.bus(5),ro.crossNM(1,2);

process = no.multinoise(13) : par(i,13,*(0.1)) : signal_flow_2a(var1,var2);
