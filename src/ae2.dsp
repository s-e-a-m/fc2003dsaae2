import("seam.discipio.lib");

signal_flow_1a = _,_ <: +,(
  _,_,(integrator(0.01), integrator(0.01) :
  delay(0.01,0.95),delay(0.01,0.95) :
  + :
  map1 <:
  _,_,_) :
  _,ro.cross(2),_,_  :
  localmax, localmax,_ :
  -,_ :
  localmax <:
  delay(12,0),_ :
  + :
  map2 :
  eavg(acor(0.5)) <: _,_) : ro.cross(2),_
with{
    map1 = 6 + (_*(6));
    map2 = *(0.5);
};

process = signal_flow_1a;
