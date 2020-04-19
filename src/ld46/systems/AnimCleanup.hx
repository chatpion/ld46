package ld46.systems;

import economy.Entity;
import ld46.components.Anim;
import ld46.components.Remove;
import economy.Family;
import economy.IteratingSystem;

class AnimCleanup extends IteratingSystem {

    public function new() {
        super(Family.all([Anim, Remove]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        entity.get(Anim).currentAnim.remove();
        space.removeEntity(entity);
    }

}