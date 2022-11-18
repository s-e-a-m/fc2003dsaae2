import("seam.lib");

//-----------------------signal flow 3-----------------------
//Role of the signal flow block: dispatching of audio signals to output channels

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
var3 = 0.2;
//VAR4
//distance (in meters) between the two farthest removed loudspeakers on the front-rear axis.
var4 = 11;

signal_flow_3(var4) = _,_ <:
                            _,_,
                            de.delay(sds.delMax, (var4/2/344)),
                            de.delay(sds.delMax, (var4/2/344)),
                            de.delay(sds.delMax, (var4/344)),
                            de.delay(sds.delMax, (var4/344))
                            :
              vgroup("Signal Flow 3",
               hbargraph("[01]out1",-1,1),
               hbargraph("[02]out2",-1,1),
                hbargraph("[03]out3",-1,1),
               hbargraph("[04]out4",-1,1),
               hbargraph("[05]out5",-1,1),
               hbargraph("[06]out6",-1,1)
              );

process = signal_flow_3;
