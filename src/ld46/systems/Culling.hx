package ld46.systems;

import h2d.col.Bounds;
import ld46.Globals;
import economy.Entity;
import ld46.components.Position;
import ld46.components.Anim;
import economy.Family;
import economy.IteratingSystem;

class Culling extends IteratingSystem {
    public function new() {
        super(Family.all([Anim, Position]).get());
    }

    private var bg: Background;
    private var camera: CameraPos;

    public override function beforeAll(delta:Float) {
        super.beforeAll(delta);

        if (bg == null) {
            bg = space.getGlobal(Background);
            camera = space.getGlobal(CameraPos);
        }
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var pos = entity.get(Position);
        var anim = entity.get(Anim);
        var aabb = anim.aabb;

        var camPos = camera.pos;

        var bounds = Bounds.fromValues(aabb.x + pos.x - camPos.x, aabb.y + pos.y - camPos.y, aabb.xMax - aabb.xMin, aabb.yMax - aabb.yMin);

        var out = (bounds.x > bg.sw || bounds.xMax < 0 || bounds.y > bg.sh || bounds.yMax < 0);

        if (out == anim.visible) {
            anim.visible = !out;
        }

    }
}