package ld46.systems;

import h2d.Layers;
import economy.Entity;
import ld46.components.Anim;
import ld46.components.Sheep;
import ld46.components.Remove;
import economy.Family;
import economy.IteratingSystem;

class SheepCleanup extends IteratingSystem {

    public function new() {
        super(Family.all([Sheep, Anim, Remove]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        entity.get(Anim).currentAnim.remove();
        space.removeEntity(entity);
    }

}