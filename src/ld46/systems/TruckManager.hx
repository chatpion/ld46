package ld46.systems;

import hxd.Res;
import hxd.res.Sound;
import ld46.Globals.Background;
import economy.Space;
import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import h2d.Camera;

import ld46.components.*;

class TruckManager extends IteratingSystem {
    public var protchSound: Sound;

    public function new() {
        super(Family.all([Truck, Position]).get());
        protchSound = null;
        if (Sound.supportedFormat(Wav)) {
            protchSound = Res.protch_wav;
        }
    }

    private var g: h2d.Graphics;

    public override function addedToSpace(space:Space) {
        super.addedToSpace(space);
        g = new h2d.Graphics();
        space.getGlobal(h2d.Layers).addChildAt(g, 2);
    }

    public override function beforeAll(delta:Float) {
        super.beforeAll(delta);
        g.clear();
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);
        var pos = entity.get(Position);
        var dir = entity.get(Truck).dir;
        var speed = entity.get(Truck).speed;
        pos.x += dir.x * delta * speed;
        pos.y += dir.y * delta * speed;

        var aabb = dir.x == 0 ? {x: pos.x - 0.8, y: pos.y - 1, w: 1.6, h: 2} : {x: pos.x - 1.7, y: pos.y - 0.3, w: 3.4, h: 0.5};

        var bg = space.getGlobal(Background);

        g.beginFill(0xCCFF0000);
        g.alpha = 0.5;
        //g.drawRect(aabb.x * bg.tw, aabb.y * bg.th, aabb.w * bg.tw, aabb.h * bg.th);

        var sheeps = space.getEntitiesFor(Family.all([Position, Alive]).get());

        for (sheep in sheeps) {
            var sheepPos = sheep.get(Position);
            var sx = sheepPos.x;
            var sy = sheepPos.y;
            if (!(sx < aabb.x || sx > aabb.x + aabb.w || sy < aabb.y || sy > aabb.y + aabb.h)) {
                // TODO: Ragdoll the sheep
                if (protchSound != null) {
                    protchSound.play(false);
                }
                sheep.remove(Alive);
            }
        }
        
        if (pos.x < -2 || pos.x > bg.ww + 2 || pos.y < -2 || pos.y > bg.wh + 2)
            entity.add(new Remove());
    }
}