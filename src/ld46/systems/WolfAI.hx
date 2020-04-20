package ld46.systems;

import h3d.Vector;
import hxd.Rand;
import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;

class WolfAI extends IteratingSystem {

    private var rand: Rand;

    public function new() {
        super(Family.all([Wolf, Position, Speed, Alive]).get());
        this.rand = Rand.create();
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);
        var speed = entity.get(Speed);

        var pos: Vector = entity.get(Position).v;
        var sheep = space.getEntitiesFor(Family.one([Sheep]).get());

        if (sheep.length == 0) return;

        // compute nearest
        var nearest = sheep.iterator().next().get(Position).v.sub(pos);
        for (e in sheep) {
            if (e.get(Position).v.sub(pos).lengthSq() < nearest.lengthSq()) {
                nearest = e.get(Position).v.sub(pos);
            }
        }

        var sheeplike = space.getEntitiesFor(Family.all([SheepLike]).get());
        for (dog in sheeplike) {
            if (!dog.get(SheepLike).isAvailable()) continue;
            
            if (dog.get(Position).v.sub(pos).lengthSq() < nearest.lengthSq()) {
                nearest = dog.get(Position).v.sub(pos);
            }
        }

        if (nearest.lengthSq() > 40) {
            nearest.scale3(0);
            var w = entity.get(Wolf);
            nearest = w.spawn.sub(pos);
        } 

        speed.v = nearest.getNormalized();
    }

    
}