import("seam.discipio.lib");

//-----------------------signal flow 1a-----------------------
//Role of the signal flow block: generation of control signals based on mic3 and mic4 input

signal_flow_1a(var1, var2, mic1, mic2, mic3, mic4) = mic1, mic2,(mic3, mic4 <: +,(
  _,_,(integrator(0.01), integrator(0.01) :
  delay(0.01,0.95),delay(0.01,0.95) :
  + :
  mapsum(_,6,6) <:
  _,_,_) :
  _,ro.cross(2),_,_  :
  localmax, localmax,_ :
  -,_ :
  localmax <:
  delay(12,0),_ :
  + :
  mapsum(_,0,0.5) :
  lp1p(0.5)) :
  _ ,(_<: _,_) :
  ro.cross(2),_ :
  _, (_<: _,_,_,_),_ :
  _,_,_,_,* :
  mapsub(_,1,1),
  (fi.highpass(3,var2) : integrator(0.05)),
  (fi.lowpass(3,var2) : integrator(0.1)),
  integrator(0.1),
  integrator(0.01) :
  _,-,_,_ :
  *,_,_:
  delay(0.01,0.995),
    delay(0.01,0.9),
    delay(0.01,0.995) :
par(i,3,fi.lowpass(5,25)):
mapsum(_,0.5,0.5),
(( mapsub(_^2,1,1)) <: delay(var1/2,0),delay(var1/3,0),_),
(_<: delay(var1/3,0),delay(var1/2,0), mapcond,_));

process = signal_flow_1a;
