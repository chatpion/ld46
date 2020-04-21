package ld46.systems;

import hxd.Res;
import hxd.res.Sound;
import hxd.Rand;
import economy.System;

class BGSound extends System {
    private var rand: Rand;
    private var timeLeft: Float;
    private var sheepSound1: Sound;
    private var sheepSound2: Sound;
    private var sheepSound3: Sound;
    private var sheepSound4: Sound;

    public function new() {
        rand = Rand.create();
        timeLeft = 0;
        sheepSound1 = null;
        sheepSound2 = null;
        sheepSound3 = null;
        sheepSound4 = null;

        if (Sound.supportedFormat(Wav)) {
            sheepSound1 = Res.sheepSound1;
            sheepSound2 = Res.sheepSound2;
            sheepSound3 = Res.sheepSound3;
            sheepSound4 = Res.sheepSound4;
        }
    }

    public override function update(delta:Float) {
        super.update(delta);
        if (timeLeft == 0) {
            timeLeft = 3;
            var random = rand.rand();
            if (random < 0.5) {
                random *= 2;
                if (random < 0.25) {
                    if (sheepSound1 != null) {
                        sheepSound1.play(false);
                    }
                } else if (random < 0.5) {
                    if (sheepSound2 != null) {
                        sheepSound2.play(false);
                    }
                } else if (random < 0.75) {
                    if (sheepSound3 != null) {
                        sheepSound3.play(false);
                    }
                } else {
                    if (sheepSound4 != null) {
                        sheepSound4.play(false);
                    }
                }
            }
        }
        timeLeft -= delta;
        if (timeLeft <= 0) {
            timeLeft = 0;
        }
    }
}