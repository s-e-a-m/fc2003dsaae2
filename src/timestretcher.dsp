declare name        "Timestretching";
declare author      "Luca Spanedda";

// FAUST standard library
import("stdfaust.lib");

GRec = checkbox("[0]Cyclic Recording");
GBuffer = hslider("[1]Buffer Dimension",1000,120,8000,1):si.smoo;
GStretch = hslider("[2]Stretch Factor",1,1,100,0.01):si.smoo;
GGraindim = hslider("[3]Grain Dimension",80,1,100,0.01):si.smoo;
GFreq = hslider("[4]Reading Frequency",1,1,10,0.001):si.smoo;

timestretching(MSbuffer,MSgraindim,record,Stretchfactor,Freq) = _ <: A_grain+B_grain
    with{
        // Sample and Hold: input --> sah(control sig)
        sah(x) = sahf
            with{trigger = (((x*-1+1)-0.5)>0)-((((x*-1+1)-0.5)>0):mem)>0;
                sahf(y) = (*(1-trigger) + (y*trigger))~ _;};
        // Phasor
        phasor(f) = fb
            with{wrap(x)=x-int(x); fb=(f/ma.SR):(+ : wrap)~_;};
        // Gaussian Windowing: phasor input, power
        gaussian(x,powv) = sin(x*ma.PI),powv:pow; 
    // offset for the index write and read
    offset = 2;
    // buffer dynamic dimension
    dimension = (ma.SR/1000)*MSbuffer:int; 
    // graindim = dimension of the grain in ms.
    graindim = (ma.SR/1000)*MSgraindim:int;
    //  indexwrite = cyclic constant writing on all the buffer + offset
    indexwrite = ((+(1):%(dimension-offset))~_*(record))+(offset*record):int;
    // wrap reset the int
    wrap(x)=x-int(x);
    Grainphasor = phasor((dimension/graindim)*Freq);
    Positionphasor = phasor(1/Stretchfactor);
    // X_grainreader = phasor * dimension of the grain
    A_grainreader = (Grainphasor)*(graindim);
    B_grainreader = (Grainphasor+0.5:wrap)*(graindim);
    // X_bufferpos = Buffer index position, offset for the read
    A_bufferpos = (Positionphasor : sah(A_grainreader/graindim))*(dimension-(graindim));
    B_bufferpos = (Positionphasor : sah(B_grainreader/graindim))*(dimension-(graindim));
    A_indexread = A_grainreader+A_bufferpos+offset:int;
    B_indexread = B_grainreader+B_bufferpos+offset:int;
    buffer_A = rwtable(1920000+offset:int,0.0,indexwrite,_,A_indexread);
    buffer_B = rwtable(1920000+offset:int,0.0,indexwrite,_,B_indexread);
    A_grain = buffer_A*gaussian(Grainphasor,2);
    B_grain = buffer_B*gaussian(Grainphasor+0.5:wrap,2);
};

process = timestretching(1000,GGraindim,GRec,GStretch,GFreq) <: _,_;
