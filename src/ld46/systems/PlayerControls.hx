package ld46.systems;

import hxd.Key;
import economy.*;
import ld46.components.*;

class PlayerControls extends IteratingSystem {
    public function new() {
        super(Family.all([Player, Position, Speed]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var speed = entity.get(Speed);

        var dx = 0;
        var dy = 0;

        if (Key.isDown(Key.DOWN)) {
            dy = 1;
        } else if (Key.isDown(Key.UP)) {
            dy = -1;
        }

        if (Key.isDown(Key.LEFT)) {
            dx = -1;
        } else if (Key.isDown(Key.RIGHT)) {
            dx = 1;
        }

        speed.x = dx;
        speed.y = dy;
    }
}