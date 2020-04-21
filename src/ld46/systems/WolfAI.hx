package ld46.systems;

import hxd.Res;
import hxd.res.Sound;
import h3d.Vector;
import hxd.Rand;
import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;

class WolfAI extends IteratingSystem {

    private var rand: Rand;
    public var crocSound: Sound;

    public function new() {
        super(Family.all([Wolf, Position, Speed, Alive]).get());
        this.rand = Rand.create();
        crocSound = null;
        if (Sound.supportedFormat(Wav)) {
            crocSound = Res.croc;
        }
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);
        var speed = entity.get(Speed);

        var w = entity.get(Wolf);
        var pos: Vector = entity.get(Position).v;

        var targets = space.getEntitiesFor(Family.all([Eaten, Alive]).get());
        for (target in targets) {
            if (closeEnough(target.get(Position).v, pos)) {
                eat(target, delta, w);
                speed.v.scale3(0);
                return;
            }
        }

        var sheep = space.getEntitiesFor(Family.all([Sheep, Alive]).get());

        if (sheep.length == 0) return;

        // compute nearest

        var nearestEntity = sheep.iterator().next();
        var nearest = nearestEntity.get(Position).v.sub(pos);
        for (e in sheep) {
            if (e.get(Position).v.sub(pos).lengthSq() < nearest.lengthSq()) {
                nearest = e.get(Position).v.sub(pos);
                nearestEntity = e;
            }
        }

        var sheeplike = space.getEntitiesFor(Family.all([SheepLike]).get());
        for (dog in sheeplike) {
            if (!dog.get(SheepLike).isAvailable()) continue;
            
            if (dog.get(Position).v.sub(pos).lengthSq() < nearest.lengthSq()) {
                nearest = dog.get(Position).v.sub(pos);
                nearestEntity = dog;
            }
        }

        w.isEating = false;

        if (nearest.lengthSq() > 40) {
            nearest.scale3(0);
            nearest = w.spawn.sub(pos);
        } else if (closeEnough(pos, nearestEntity.get(Position).v)) {
            if (!nearestEntity.has(Eaten)) {
                nearestEntity.add(new Eaten(nearestEntity.has(SheepLike) ? 2 : 1));
            } else {
                eat(nearestEntity, delta, w);
            }
        } 
        speed.v = nearest.getNormalized();
    }

    private function closeEnough(wolf: Vector, target: Vector): Bool {
        return wolf.distanceSq(target) <= 0.1;
    }

    private function eat(nearestEntity: Entity, delta: Float, w: Wolf) {
        var eaten = nearestEntity.get(Eaten);
        eaten.progression -= delta;
        w.isEating = true;
        if (eaten.progression <= 0) {
            if (nearestEntity.has(SheepLike)) {
                nearestEntity.remove(SheepLike);
            } else {
                nearestEntity.remove(Alive);
                if (crocSound != null) {
                    crocSound.play(false);
                }
            }
            nearestEntity.remove(Eaten);
            w.isEating = false;
        }
    }


    
}