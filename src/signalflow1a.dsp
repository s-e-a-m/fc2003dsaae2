import("../../faust-libraries/seam.lib");

//-----------------------signal flow 1a-----------------------
//Role of the signal flow block: generation of control signals based on mic3 and mic4 input

signal_flow_1a(var1, var2, mic1, mic2, mic3, mic4) = mic1, mic2,(mic3, mic4 <: +,(
  _,_,(sds.integrator(0.01), sds.integrator(0.01) :
  sds.delayfb(0.01,0.95),sds.delayfb(0.01,0.95) :
  + :
  sds.mapsum(_,6,6) <:
  _,_,_) :
  _,ro.cross(2),_,_  :
  sds.localmax, sds.localmax,_ :
  -,_ :
  sds.localmax <:
  sds.delayfb(12,0),_ :
  + :
  sds.mapsum(_,0,0.5) :
  sfi.lp1p(0.5)) :
  _ ,(_<: _,_) :
  ro.cross(2),_ :
  _, (_<: _,_,_,_),_ :
  _,_,_,_,* :
  sds.mapsub(_,1,1),
  (fi.highpass(3,var2) : sds.integrator(0.05)),
  (fi.lowpass(3,var2) : sds.integrator(0.1)),
  sds.integrator(0.1),
  sds.integrator(0.01) :
  _,-,_,_ :
  *,_,_:
  sds.delayfb(0.01,0.995),
    sds.delayfb(0.01,0.9),
    sds.delayfb(0.01,0.995) :
par(i,3,fi.lowpass(5,25)):
sds.mapsum(_,0.5,0.5),
(( sds.mapsub(_^2,1,1)) <: sds.delayfb(var1/2,0),sds.delayfb(var1/3,0),_),
(_<: sds.delayfb(var1/3,0),sds.delayfb(var1/2,0), sds.mapcond,_));

process = signal_flow_1a;
