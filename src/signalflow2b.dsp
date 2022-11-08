import("seam.lib");

//-----------------------signal flow 2b-----------------------
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

signal_flow_2b(
              //variabili
              var1,
              //FEEDBACK da 2a
              graIN,
              //from 2a
              sig1,
              sig2,
              sig3,
              sig4,
              sig5,
              sig6,
              sig7,
              //from 1b
              timeIndex1,
              timeIndex2,
              triangle3,
              //from 1a
              memWriteDel1,
              memWriteDel2,
              memWriteLev,
              cntrlLev1,
              cntrlLev2
              ) =
            (
              (
                ( var1,timeIndex1,memWriteDel1,cntrlLev1,21,graIN :
                    sds.granular_sampling( 2 )    ),
                ( var1,timeIndex2,memWriteDel2,cntrlLev2,20,graIN :
                    sds.granular_sampling( 2 )    ) <:
              _,_,   *(1-(memWriteLev)),*(1-(memWriteLev)),*(memWriteLev),*(memWriteLev)
              ) :
              _,_,_,_,ro.cross(2)
            ),
            (sig5 <: _,de.delay(sds.delMax, ba.sec2samp(0.05)) <:
                _*(triangle3),_*(triangle3), _*(1-triangle3),_*(1-triangle3)),
            (
              (sig6 <: _,de.delay(sds.delMax, ba.sec2samp(0.036)) <:
                _*(1-triangle3),_*(1-triangle3),_*(triangle3),_*(triangle3)) :
                ro.cross(2),ro.cross(2)
            ),
            sig1,sig2,sig2,sig3,sig4,sig7 :
            _,_,(si.bus(18):> _,_);

process = signal_flow_2b;
