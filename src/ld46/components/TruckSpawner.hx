package ld46.components;

import economy.Component;
import hxd.Rand;
import hxd.Direction;

class TruckSpawner implements Component {

    private static var rand: Rand;
    
    public var dir: Direction;
    private var minDelay: Float;
    private var maxDelay: Float;
    private var currentDelay: Float;

    public function new(dir: Direction, minDelay: Float, maxDelay: Float) {
        this.dir = dir;
        this.minDelay = minDelay;
        this.maxDelay = maxDelay;
        this.currentDelay = minDelay;

        rand = Rand.create();
    }

    public function shouldSpawnTruck(delta: Float): Bool {
        currentDelay -= delta; 
        if (currentDelay <= 0) { 
            this.currentDelay = minDelay + rand.rand() * (maxDelay - minDelay); 
            return true;
        }
        return false;
    }

}