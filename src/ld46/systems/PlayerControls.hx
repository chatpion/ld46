package ld46.systems;

import hxd.Res;
import hxd.res.Sound;
import hxd.Key;
import economy.*;
import ld46.components.*;

class PlayerControls extends IteratingSystem {
    public function new() {
        super(Family.all([Player, Position, Speed, Alive]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var speed = entity.get(Speed);
        var musicResource: Sound = null;

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
            if (Sound.supportedFormat(Mp3)) {
                musicResource = Res.bark0;
            }
            if (musicResource != null) {
                musicResource.play(false);
            }
        }

        speed.x = dx;
        speed.y = dy;
    }
}