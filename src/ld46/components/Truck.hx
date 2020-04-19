package ld46.components;

import hxd.Direction;
import economy.Component;

class Truck implements Component {

    public var dir: Direction;

    public function new(dir: Direction) {
        this.dir = dir;
    }
}
