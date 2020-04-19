package ld46.systems;

import h2d.Layers;
import economy.Entity;
import economy.Family;
import economy.IteratingSystem;
import ld46.components.*;

class SpawnTruck extends IteratingSystem {

    private var truckTileVert: h2d.Tile;
    private var truckTileHori: h2d.Tile;

    public function new(truckTileVert: h2d.Tile, truckTileHori: h2d.Tile) {
        super(Family.all([TruckSpawner, Position]).get());

        this.truckTileVert = truckTileVert;
        this.truckTileHori = truckTileHori;
    }

    public override function processEntity(delta:Float, entity:Entity) {
        super.processEntity(delta, entity);

        var spawner = entity.get(TruckSpawner);
        if (spawner.shouldSpawnTruck(delta)) {
            var pos = entity.get(Position);
            spawnTruck(pos.x + 0.5, pos.y + 0.5, spawner.dir);
        }
    }

    private function spawnTruck(x: Float, y: Float, dir: hxd.Direction) {
        var entity = new Entity();
        entity.add(new Truck(dir));
        entity.add(new Position(x - 2 * dir.x, y - 2 * dir.y));

        var anim = if (dir.x == 0) {  // vertical
            var a = new h2d.Anim([truckTileVert], 1, space.getGlobal(Layers));
            a.scaleY = dir.y;
            a;
        } else {  // horizontal
            var a = new h2d.Anim([truckTileHori], 1, space.getGlobal(Layers));
            a.scaleX = dir.x;
            a;
        }

        entity.add(new Anim(["" => anim], ""));
        space.addEntity(entity);
    }

}