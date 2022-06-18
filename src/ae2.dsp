
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

import("seam.discipio.lib");

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

process = signal_flow_1a(var1,var2) <:
              si.bus(30) :
                                      (_, _, _,_,!,!,!,_,!,!,!,_,
                                      _,_,_,_,_,_,!,!,_,_,
                                      !,!,!,_,_,_,_,_,!,! :
          (signal_flow_1b(var1,var3) <:
                                      si.bus(16)) , _,_,_,_,_,!,!,!,_,_,_,_,_:
                                      !,!,!,_,_,!,!,_,
          signal_flow_2a(var1, var2),_,_,_,_,_ :
          signal_flow_2b)~si.bus(2) :
                                    !,!,_,_ :
          signal_flow_3;
