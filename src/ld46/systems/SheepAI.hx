package ld46.systems;

import h3d.Vector;
import h3d.Matrix;
import hxd.Rand;
import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;

class SheepAI extends IteratingSystem {

    private var rand: Rand;

    public function new() {
        super(Family.all([Sheep, Position, Speed]).get());
        this.rand = Rand.create();
    }

    private var mean: Vector;

    public override function beforeAll(delta:Float) {
        super.beforeAll(delta);

        mean = new Vector();

        for (e in entities) {
            var pos = e.get(Position);
            mean = mean.add(pos.v);
        }

        mean.scale3(1 / entities.length);
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var dog = space.getEntitiesFor(Family.all([Player]).get()).iterator().next();
        var dogPos = dog.get(Position);
        
        var pos = entity.get(Position);
        
        var speed = entity.get(Speed);

        var dist = dogPos.v.distanceSq(pos.v);

        var total = new Vector();

        if (dist < 7) {
            var factor = 2 * Math.exp(- dist / 4);

            // avoid the dog
            var angle = rand.rand() * 0.3;
            var rotation = new Matrix();
            rotation.initRotationZ(angle);
            var avoidDog = pos.v.sub(dogPos.v).getNormalized();
            avoidDog.transform(rotation);  // makes movement a bit random
            avoidDog.scale3(factor);

            total = total.add(avoidDog);
        }

        var toMean = mean.sub(pos.v);
        var closeEnough = toMean.lengthSq() < 1 ? 0 : 1;
        toMean.scale3(closeEnough);
        total = total.add(toMean.getNormalized()).getNormalized();

        speed.v = total;
    }

    
}