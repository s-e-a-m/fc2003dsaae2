import("../../faust-libraries/seam.lib");

//-----------------------signal flow 3-----------------------
//Role of the signal flow block: dispatching of audio signals to output channels

signal_flow_3(var4) = _,_ <:
               _,_,de.delay(sds.delMax, (var4/2/344)),
                   de.delay(sds.delMax, (var4/2/344)),
                   de.delay(sds.delMax, (var4/344)),
                   de.delay(sds.delMax, (var4/344));

process = signal_flow_3;
