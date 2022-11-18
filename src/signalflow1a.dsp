import("seam.lib");



//-----------------------signal flow 1a-----------------------
//Role of the signal flow block: generation of control signals based on mic3 and mic4 input

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

signal_flow_1a(
              var1,
              var2,
            //mic1,
            //mic2,
              mic3,
              mic4
              ) =
              //mic1, mic2,
              (mic3, mic4 <:
              +,(
                _,_,(sds.integrator(0.01), sds.integrator(0.01) :
                sds.delayfb(0.01,0.95),sds.delayfb(0.01,0.95) :
                + :
                sds.mapsum(_,6,6) <:
                _,_,_) :
                _,ro.cross(2),_,_  :
                sds.localmax, sds.localmax,_ :
                -,_ :
                sds.localmax <:
                de.delay(ba.sec2samp(12), ba.sec2samp(12)),_ :
                + :
                sds.mapsum(_,0,0.5) :
              scy.onepole(0.5) ) :
              _ ,(_<: _,_) :
              ro.cross(2),_ :
              _, (_<: _,_,_,_),_ :
              _,_,_,_,* :
              sds.mapsub(_,1,1),
              (fi.highpass(3,var2) : sds.integrator(0.05)),
              (fi.lowpass(3,var2) : sds.integrator(0.1)),
              sds.integrator(0.1),
              sds.integrator(0.01) :
              _,- ,_,_ :
              * ,_,_:
              sds.delayfb(0.01,0.995),
                sds.delayfb(0.01,0.9),
                sds.delayfb(0.01,0.995) :
              par(i,3,fi.lowpass(5,25)):
              sds.mapsum(_,0.5,0.5), (( sds.mapsub(_^2,1,1)) <:

              de.delay(sma.imt2samp(var1/2),sma.imt2samp(var1/2)),
              de.delay(sma.imt2samp(var1/3),sma.imt2samp(var1/3)),_), (_<:
              de.delay(sma.imt2samp(var1/3),sma.imt2samp(var1/3)),
              de.delay(sma.imt2samp(var1/2),sma.imt2samp(var1/2)), sds.mapcond,_)) :              
              vgroup("Signal Flow 1a",
               (max(0, min(1)) : hbargraph("[01]diffHL",0,1)),
               (max(0, min(1)) : hbargraph("[02]memWriteDel1", 0,1)),
               (max(0, min(1)) : hbargraph("[03]memWriteDel2",0,1)),
               (max(0, min(1)) : hbargraph("[04]memWriteLev", 0,1)),
               (max(0, min(1)) : hbargraph("[05]CntrlLev1",0,1)),
               (max(0, min(1)) : hbargraph("[06]CntrlLev2",0,1)),
               (max(0, min(1)) : hbargraph("[07]CntrlFeed",0,1)),
               (max(0, min(1)) : hbargraph("[08]CntrlMain",0,1))
              )

              ;



//process = no.multinoise(2) : par(i,2,si.smooth(0.7)*(0.1)) : signal_flow_1a(var1,var2);

fakeosc(N) =  par(i,N,os.osc(i+0.001)*(ba.db2linear(-42)));

process =  _,_@(ma.SR) : signal_flow_1a(var1,var2);

//debugging

//generic test
mmeter(N) = par(i, N, hbargraph("%i",-1, 1));
