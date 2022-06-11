import("seam.discipio.lib");

signal_flow_3= _,_ <:
               _,_,de.delay(delMax, (var4/2/344)),
                   de.delay(delMax, (var4/2/344)),
                   de.delay(delMax, (var4/344)),
                   de.delay(delMax, (var4/344));

process = signal_flow_3;
