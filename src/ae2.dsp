import("seam.discipio.lib");

signal_flow_1a = _,_ <:
  _,_,(integrator(0.01), integrator(0.01) :
  delay(0.01,0.95),delay(0.01,0.95) : + :
  frame <: _,_,_) : _,ro.cross(2),_,_  :
  localmax, localmax,_ : -,_ : localmax // delay 12…
with{
    frame = 6 + (_*(6));
};

process = signal_flow_1a;
