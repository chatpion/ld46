package ld46.systems;

import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;

class TruckManager extends IteratingSystem {
    public function new() {
        super(Family.all([Truck, Position]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);
        var pos = entity.get(Position);
        var dir = entity.get(Truck).dir;
        pos.x += dir.x * delta * 20;
        pos.y += dir.y * delta * 20;

        var aabb = dir.x == 0 ? {x: pos.x - 0.5, y: pos.y - 1.5, w: 1, h: 3} : {x: pos.x - 1.5, y: pos.y - 0.5, w: 3, h: 1};

        var sheeps = space.getEntitiesFor(Family.all([Position, Alive]).get());

        for (sheep in sheeps) {
            var sheepPos = sheep.get(Position);
            var sx = sheepPos.x;
            var sy = sheepPos.y;
            if (!(sx < aabb.x || sx > aabb.x + aabb.w || sy < aabb.y || sy > aabb.y + aabb.h)) {
                // TODO: Ragdoll the sheep
                sheep.remove(Alive);
            }
        }

        if (Math.abs(pos.x) > 100 || Math.abs(pos.y) > 100)
            entity.add(new Remove());
    }
}