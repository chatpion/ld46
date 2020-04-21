package ld46.components;

import h3d.Vector;
import economy.Component;
import economy.Entity;

class Wolf implements Component {

    public var spawn: Vector;
    public var isEating: Bool = false;

    public function new(spawnX: Float, spawnY: Float) {
        this.spawn = new Vector(spawnX, spawnY);
    }
}