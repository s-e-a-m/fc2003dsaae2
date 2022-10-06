import("../../faust-libraries/seam.lib");

//-----------------------signal flow 1b-----------------------
//Role of the signal flow block: generation of control signals based on mic1 and mic2 input, plus internal signal generators

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

signal_flow_1b(
              var1,
              var3,
              grainOut1,
              grainOut2,
              mic1,
              mic2,
              memWriteLev,
              cntrlMain
              ) =
              (
                  mic1, mic2 : sfi.hp1(50), sfi.hp1(50) : sfi.lp1p(6000), sfi.lp1p(6000) : sds.integrator(0.01), sds.integrator(0.01) : sds.delayfb(0.01,0.999), sds.delayfb(0.01,0.999) : fi.lowpass(5, 0.5), fi.lowpass(5, 0.5)
              ),
              (
               grainOut1, grainOut2: + : sds.integrator(0.01) : sds.delayfb(0.01, 0.97) : fi.lowpass(5,0.5) <: _+sds.delayfb(var1*(2), (1-var3)*(0.5)) : sds.mapsub(_,1,0.5)
              ),
              (
                  (timeIndex(var1)<: sds.mapmul(_,-2,0.5),sds.mapmul(_,1,0.5)), triangle1(var1, memWriteLev)*memWriteLev,triangle2(var1, cntrlMain), triangle3(var1)
              )
              with{
                  timeIndex(var1) = os.lf_trianglepos(1/(var1*(2)));
                  triangle1(var1, memWriteLev) = os.lf_trianglepos(1/(var1*(6)));
                  triangle2(var1, cntrlMain) = os.lf_trianglepos(var1*(1-cntrlMain));
                  triangle3(var1) = os.lf_trianglepos(1/var1);
              };

process = signal_flow_1b;
