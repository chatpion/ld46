package ld46.systems;

import ld46.Globals.Background;
import h3d.Vector;
import economy.Entity;
import economy.Family;
import economy.IteratingSystem;

import ld46.components.*;

class Camera extends IteratingSystem {

    public function new() {
        super(Family.all([Player, Position, Alive]).get());
    }

    private var camPos: Vector = new Vector();

    private final minX: Float = 4;
    private final maxX: Float = -4;
    private final minY: Float = 4;
    private final maxY: Float = -4;

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var ePos = entity.get(Position).v;
        var relPos = ePos.sub(camPos);

        var bg = space.getGlobal(Background);

        if (relPos.x < 0 || (relPos.x < minX && ePos.x > minX))  // player on left edge
            camPos.x = ePos.x - minX;
        else if (relPos.x > bg.sw || (relPos.x > bg.sw + maxX && ePos.x < bg.ww + maxX))  // player on right edge
            camPos.x = ePos.x - bg.sw - maxX;

        if (relPos.y < 0 || (relPos.y < minY && ePos.y > minY))  // player on top edge
            camPos.y = ePos.y - minY;
        else if (relPos.y > bg.sh || (relPos.y > bg.sh + maxY && (ePos.y < bg.wh + maxY)))  // palyer on bottom edge
            camPos.y = ePos.y - bg.sh - maxY;

        space.getGlobal(h2d.Layers).setPosition(-camPos.x * bg.tw, -camPos.y * bg.th);
        
    }

}