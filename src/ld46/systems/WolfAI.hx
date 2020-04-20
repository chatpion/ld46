package ld46.systems;

import haxe.PosInfos;
import h3d.Vector;
import h3d.Matrix;
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

    private var nearest: Vector;

    public override function beforeAll(delta:Float) {
        super.beforeAll(delta);

        var pos: Vector = entities.iterator().next().get(Position).v;
        var sheep = space.getEntitiesFor(Family.one([Sheep, SheepLike]).get());

        nearest = sheep.iterator().next().get(Position).v.sub(pos);
        
        for (e in sheep) {
            if (e.get(Position).v.sub(pos).lengthSq() < nearest.lengthSq()) {
                nearest = e.get(Position).v.sub(pos);
            }
        }

        if (nearest.lengthSq() > 100) {
            nearest.scale3(0);
        }
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);
        var speed = entity.get(Speed);
        speed.v = nearest.getNormalized().getNormalized();
    }

    
}