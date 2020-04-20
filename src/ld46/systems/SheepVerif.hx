package ld46.systems;

import ld46.components.Remove;
import economy.Entity;
import ld46.components.Position;
import ld46.components.Sheep;
import ld46.components.Alive;
import economy.Family;
import economy.IteratingSystem;
import ld46.Globals;

class SheepVerif extends IteratingSystem {

    public function new() {
        super(Family.all([Sheep, Position, Alive]).get());
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var pos = entity.get(Position);
        var x = Std.int(pos.x);
        var y = Std.int(pos.y);

        var cl = space.getGlobal(CollisionLayer);
        var score = space.getGlobal(Score);

        if (cl.isGoal(x, y)) {
            entity.add(new Remove());
            score.saved++;
        } else if (cl.isTrap(x, y)) {
            entity.add(new Remove());
            score.dead++;
            cl.set(x, y, Value.NONE);
            space.getGlobal(Background).replace(x, y, 38);
        }
    }

}