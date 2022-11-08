
declare name "Agostino Di Scipio - AUDIBLE ECOSYSTEMICS n.2";
declare version "xxx";
declare author "Giuseppe Silvi";
declare author "Luca Spanedda";
declare author "Davide Tedesco";
declare author "Giovanni Michelangelo D'urso";
declare author "Alessandro Malcangi";
declare license "GNU-GPL-v3";
declare copyright "(c)SEAM 2022";
declare description "Realised on composer's instructions of the year 2017 edited in L’Aquila, Italy";
//declare options "[midi:on]";
import("seam.lib");



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


//------------------------------------------- signal flow 1a

signal_flow_1a = component("signalflow1a.dsp").signal_flow_1a;


//------------------------------------------- signal flow 1b

signal_flow_1b = component("signalflow1b.dsp").signal_flow_1b;


//------------------------------------------- signal flow 2a

signal_flow_2a = component("signalflow2a.dsp").signal_flow_2a;


//------------------------------------------- signal flow 2b

signal_flow_2b = component("signalflow2b.dsp").signal_flow_2b;


//------------------------------------------- signal flow 3

signal_flow_3 = component("signalflow3.dsp").signal_flow_3;


//------------------------------------------- ae2 signal flow

/*process = //fakesig : _,_,
          signal_flow_1a(var1,var2) <: si.bus(24) :
          ( !,!,!,_,!,!,!,_,
            _,_,_,_,!,!,_,_,
            !,_,_,_,_,_,!,! :
          (signal_flow_1b(var1,var3) <:
            si.bus(16)) , _,_,_,_,_,!,!,!,_,_,_,_,_:
            //!,!,!,_,_,!,!,_,
            !,!,!,_,_,!,!,_,
            _,_,_,!,!,_,_,!,
            //signal_flow_2a(var1, var2),_,_,_,_,_ :
            signal_flow_2a(var1, var2),_,_ :

          signal_flow_2b(var1))~si.bus(2) :
          !,!,_,_ :
          signal_flow_3(var4);
*/

ae2 = (_,_ <: si.bus(4)),
        (_,_: signal_flow_1a(var1,var2)<: si.bus(24) :
            //to 1b
            !,!,!,_,!,!,!,_,
            //to 2a
            _,_,_,_,!,!,_,_,
            //to 2b
            !,_,_,_,_,_,!,!


)  : ro.crossNM(2,4), si.bus(11)  :
((signal_flow_1b(var1,var3) <:

//to 2a
  _,_,_,!,!,_,_,!,
  //to 2b
!,!,!,_,_,!,!,_
  ), si.bus(13)
  : ro.crossNM(8,2), si.bus(11)
  : si.bus(7), ro.crossNM(3,6), si.bus(5)
 : signal_flow_2a(var1,var2), si.bus(8)
: signal_flow_2b(var1)
)~ si.bus(2)//feedback 1b
            : si.block(2),si.bus(2)
            : signal_flow_3(var4);


process = fakesig(4) : ae2;

fakesig(N) = no.multinoise(N) : par(i,N,*(ba.db2linear(-18)));
//process = fakesig :  signal_flow_1a(var1,var2) : (_,_,ae2gui);

//------------------------------------------- ae2 GUI

ae2gui = tgroup("AE2GUI", sfg1);

sfg1 =
    vgroup("[10]Signal Flow 1a",
    hbargraph("[00]diffHL",0,1),
    hbargraph("[01]memWriteDel1", 0,1),
    hbargraph("[02]memWriteDel2", 0,1),
    hbargraph("[03]memWriteLev", 0,1),
    hbargraph("[04]cntrlLev1", 0,1),
    hbargraph("[05]cntrlLev2", 0,1),
    hbargraph("[06]cntrlFeed", 0,1),
    hbargraph("[07]cntrlMain", 0,1));

sfg2 =
    vgroup("[20]Signal Flow 1b",
    hbargraph("[00]cntrlMic1",0,1),
    hbargraph("[01]cntrlMic2", 0,1),
    hbargraph("[02]directLevel", 0,1),
    hbargraph("[03]timeIndex1", 0,1),
    hbargraph("[04]timeIndex2", 0,1),
    hbargraph("[05]triangle1", 0,1),
    hbargraph("[06]triangle2", 0,1),
    hbargraph("[07]triangle3", 0,1));
