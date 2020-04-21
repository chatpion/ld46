package ld46.systems;

import hxd.Res;
import hxd.res.Sound;
import ld46.components.Remove;
import economy.Entity;
import ld46.components.Position;
import ld46.components.*;
import ld46.components.Alive;
import economy.Family;
import economy.IteratingSystem;
import ld46.Globals;

class SheepVerif extends IteratingSystem {

    public var protchSound: Sound;
    public var harpSound: Sound;

    public function new() {
        super(Family.all([Position, Alive]).one([Sheep, Wolf]).get());
        protchSound = null;
        harpSound = null;
        if (Sound.supportedFormat(Wav)) {
            protchSound = Res.protch;
            harpSound = Res.harp;
        }
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var pos = entity.get(Position);
        var x = Std.int(pos.x);
        var y = Std.int(pos.y);

        var cl = space.getGlobal(CollisionLayer);
        var score = space.getGlobal(Score);

        if (cl.isGoal(x, y) && entity.has(Sheep)) {
            entity.add(new Remove());
            score.saved++;
            if (harpSound != null) {
                harpSound.play(false);
            }
        } else if (cl.isTrap(x, y)) {
            entity.add(new Remove());

            if (entity.has(Sheep)) {
                score.dead++;
                if (protchSound != null) {
                    protchSound.play(false);
                }
            }
            cl.set(x, y, Value.NONE);

            if (entity.has(Sheep))
                space.getGlobal(Background).replace(x, y, 38);
            else 
                space.getGlobal(Background).replace(x, y, 39);
        }
    }

}