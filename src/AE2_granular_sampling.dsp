declare name "granular_sampling for AUDIBLE ECOSYSTEMICS n.2";
declare version "xxx";
declare author "Luca Spanedda";
declare author "Dario Sanfilippo";
declare description "Realised on composer's instructions of the year 2017 edited in L’Aquila, Italy";

import("seam.lib");

varUno = 3;

primesnumbers(index) = ba.take(index , list)
    with{
        list = sma.primes;
};

primenoise(seed) = (+(primesnumbers(1000+seed))~*(1103515245))/(2147483647.0);


grain(seed,varUno,timeIndex,memWriteDel,cntrlLev, divDur, x) = hann(readingSegment) * buffer(bufferSize, readPtr, x)
    with {

        // density
        _grainRate = (cntrlLev*(100-1))+1;
        // target grain duration in seconds
        _grainDuration = 0.023 + ((1 - memWriteDel) / divDur);
        // target grain position in the buffer
        _grainPosition = ((timeIndex)+1)/2;
        // make sure to have decorrelated noises
        // grain.dur.jitter: 0.1 - constant value
        durationJitter = primenoise(seed+1) * .1 + .1;
        positionJitter = primenoise(seed+2) * (1-memWriteDel)/100;

        // buffer size
        bufferSize = varUno*196000;
        // hann window
        hann(x) = sin(ma.PI * x) ^ 2.0;

        // a phasor that read new params only when: y_1 < y_2
        phasorLocking = loop ~ _
            with {
                loop(y_1) = ph , unlock
                    with{
                        y_2 = y_1';
                        ph = os.phasor(1, ba.sAndH(unlock, _grainRate));
                        unlock = (y_1 < y_2) + 1 - 1';
                    };
            };
        // two outputs of the phasor: phasor, trigger(y_1<y_2)
        phasor = phasorLocking : _ , !;
        unlocking = phasorLocking : ! , _;

        // new param with lock function based on the phasor
        lock(param) = ba.sAndH(unlocking, param);

        // TO DO: wrap & receive param from AE2
        grainPosition = lock(_grainPosition * positionJitter);
        // TO DO: wrap & receive param from AE2
        grainRate = lock(_grainRate);
        // TO DO: wrap & receive param from AE2
        grainDuration = lock(_grainDuration * durationJitter);

        // maximum allowed grain duration in seconds
        maxGrainDuration = 1.0 / grainRate;
        // phase segment multiplication factor to complete a Hann cycle in the target duration
        phasorSlopeFactor = maxGrainDuration / min(maxGrainDuration, grainDuration);


        readingSegment = min(1.0, phasor * phasorSlopeFactor);
        // read pointer
        readPtr = grainPosition * bufferSize + readingSegment * (ma.SR / (grainRate * phasorSlopeFactor));
        buffer(length, readPtr, x) = it.frwtable(5, 1920000, .0, writePtr, x, readPtr)
            with {
                writePtr = ba.period(length);
            };
    };

// par (how much grains/instances do you want?)
grainN(voices,timeIndex,memWriteDel,cntrlLev, divDur,x) =
    par(i, voices, grain(i,varUno,timeIndex,memWriteDel,cntrlLev, divDur,x/voices));


// timeIndex1 - a signal between -1 and -0.5
GtimeIndex = hslider("timeIndex1", -1, -1, -0.5, .001);
// memWriteDel1 - a signal between 0 and 1
GmemWriteDel = hslider("memWriteDel1", 0, 0, 1, .001);
volume = hslider("volume", 0, 0, 10, .001);
// cntrlLev: a signal between 0 and 1 (1 max, 0 no grains)
GcntrlLev = hslider("cntrlLev", .5, 0, 1, .001);
// varUno distance (in meters) between the two farthest removed loudspeakers

GnVoices = 8;

GdivDur = 21;

granular_sampling(nVoices, timeIndex, memWriteDel, cntrlLev, divDur, x) =  grainN(nVoices, timeIndex, memWriteDel, cntrlLev, divDur,x) :> +;

process = os.osc(600): granular_sampling(GnVoices, GtimeIndex,GmemWriteDel, GcntrlLev, GdivDur);
