package ld46.components;

import hxd.Direction;
import economy.Component;

class Truck implements Component {

    public var dir: Direction;
    public var speed: Float;

    public function new(dir: Direction, speed: Float) {
        this.dir = dir;
        this.speed = speed;
    }
}
