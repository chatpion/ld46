package ld46.systems;

import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;
import ld46.Globals;

class MoveEntities extends IteratingSystem {
    public function new() {
        super(Family.all([Position, Speed, Alive]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        this.bg = space.getGlobal(Background);

        var speed = entity.get(Speed);
        move(entity, delta, speed.x, 0);
        move(entity, delta, 0, speed.y);
    }

    private function move(entity: Entity, delta: Float, dx: Float, dy: Float) {
        if (entity.has(Sheep) && entity.has(Eaten)) return;
        
        var speed = entity.get(Speed);
        var s = speed.speed;
        var pos = entity.get(Position);

        var newX = pos.x + dx * delta * s;
        var newY = pos.y + dy * delta * s;

        if (!isValid(newX, newY))
            return;

        pos.x = newX;
        pos.y = newY;
    }

    private var bg: Background;

    private function isValid(x: Float, y: Float): Bool {
        var tx = Std.int(x);
        var ty = Std.int(y);
        return x > 0 && x < bg.ww && y > 0 && y < bg.wh && !space.getGlobal(CollisionLayer).isWall(tx, ty);
    }

}