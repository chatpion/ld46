package ld46.systems;

import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;

import ld46.Globals;

class AnimPos extends IteratingSystem {
    
    public function new() {
        super(Family.all([Position, Anim]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var anim = entity.get(Anim);
        var pos = entity.get(Position);

        var speed = entity.get(Speed);
        if (speed != null) {
            if (!entity.has(Alive)) {
                anim.setCurrentAnim("dead");
            } else if (speed.v.lengthSq()>  0) {
                if (entity.has(SheepLike))
                    anim.setCurrentAnim("runS");
                else 
                    anim.setCurrentAnim("run");
            } else {
                if (entity.has(SheepLike))
                    anim.setCurrentAnim("idleS");
                else if (entity.has(Wolf) && entity.get(Wolf).isEating) {
                    anim.setCurrentAnim("eat");
                } else
                    anim.setCurrentAnim("idle");
            }
        }

        var worldSize = space.getGlobal(WorldSize);

        anim.currentAnim.setPosition(pos.x * worldSize.tw, pos.y * worldSize.th);
    }

}

class AnimDirection extends IteratingSystem {

    public function new() {
        super(Family.all([Speed, Anim]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var anim = entity.get(Anim);
        var speed = entity.get(Speed);

        if (!anim.lockX) {
            var directionX = anim.currentAnim.scaleX * (-speed.v.x) > 0 ? -1 : 1;
            anim.currentAnim.scaleX *= directionX;
        }
        if (!anim.lockY) {
            var directionY = anim.currentAnim.scaleY * (-speed.v.y) > 0 ? -1 : 1;
            anim.currentAnim.scaleY *= directionY;
        }
    }
}