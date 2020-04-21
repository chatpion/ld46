package ld46.systems;

import hxd.Res;
import hxd.res.Sound;
import hxd.Key;
import economy.*;
import ld46.components.*;

class PlayerControls extends IteratingSystem {
    private var barkSound: Sound;

    public function new() {
        super(Family.all([Player, Position, Speed, Alive]).get());
        barkSound = null;
        if (Sound.supportedFormat(Wav)) {
            barkSound = Res.bark;
        }
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
        
        if (entity.has(SheepLike)) {
            entity.get(SheepLike).update(delta);
        }

        if (Key.isPressed(Key.Q)) {
            if (!entity.has(SheepLike)) {
                entity.add(new SheepLike());
            } else if (entity.get(SheepLike).isAvailable()) {
                entity.remove(SheepLike);
            }
        }

        if (Key.isPressed(Key.B)) {
            if (barkSound != null) {
                barkSound.play(false);
            }
        }

        speed.x = dx;
        speed.y = dy;
    }
}