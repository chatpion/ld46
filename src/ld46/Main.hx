package ld46;

import economy.Entity;
import economy.Space;
import economy.Engine as EEngine;
import ld46.components.*;
import ld46.systems.*;
import ld46.systems.Animations;
import ld46.Globals;


using Lambda;

class Main extends hxd.App {
    var ecoEngine: EEngine;
    var space: Space;
    
    var tileImage: h2d.Tile;
    
    var dogRunTiles: Array<h2d.Tile>;
    var dogIdleTiles: Array<h2d.Tile>;
    var sheepRunTiles: Array<h2d.Tile>;
    var sheepIdleTiles: Array<h2d.Tile>;

    var layers: h2d.Layers;

    override private function init() {
        super.init();

        //var project = ogmo.Project.create(hxd.Res.levels.entry.getText());
        //var level = ogmo.Level.create(hxd.Res.test_level.entry.getText());

        var project = ogmo.Project.create(hxd.Res.loader.load("levels.ogmo").toText());
        var level = ogmo.Level.create(hxd.Res.loader.load(levelName).toText());


        var tw = project.tilesets[0].tileWidth;
        var th = project.tilesets[0].tileHeight;

        tileImage = hxd.Res.tileset_png.toTile();

        var tileSet = [
            for (y in 0 ... Std.int(tileImage.height / th))
                for(x in 0 ... Std.int(tileImage.width / tw))
                    tileImage.sub(x * tw, y * th, tw, th)
        ];

        dogRunTiles = [tileImage.sub(0, 0, tw, th), tileImage.sub(tw, 0, tw, th)];
        dogIdleTiles = [tileImage.sub(3 * tw, 0, tw, th)];
        sheepRunTiles = [tileImage.sub(0, th, tw, th), tileImage.sub(tw, th, tw, th)];
        sheepIdleTiles = [tileImage.sub(3 * tw, th, tw, th)];

        for (t in [dogRunTiles, dogIdleTiles].flatten()) {
            t.dx = -16;
            t.dy = -28;
        }

        for (t in [sheepRunTiles, sheepIdleTiles].flatten()) {
            t.dx = -16;
            t.dy = -28;
        }

        var root = new h2d.Object(s2d);
        root.setScale(2);

        layers = new h2d.Layers(root);

        var background = new h2d.TileGroup(tileImage, layers);
        layers.addChildAt(background, 0);

        ecoEngine = new EEngine();
        space = new Space();
        space.addGlobal(layers);
        space.addGlobal(project);
        space.addGlobal(level);
        space.addGlobal(new WorldSize(tw, th));
        space.addGlobal(new Background(tileSet, background, tw, th));

        ecoEngine.add(space, 0);

        level.onTileLayerLoaded = (tiles, layer) -> {
            if (layer.name != "background") return;

            for (i in 0 ... tiles.length) {
                if (tiles[i] > -1) {
                    var x = i % layer.gridCellsX;
                    var y = Math.floor(i / layer.gridCellsX);
                    background.add(x * layer.gridCellWidth, y * layer.gridCellHeight, tileSet[tiles[i]]);
                }
            }
        }

        level.onEntityLayerLoaded = (entities, layer) -> {
            if (layer.name == "sheeps") {
                for (entity in entities) {
                    var x: Float = entity.x / tw;
                    var y: Float = entity.y / th;
                    makeSheep(x, y);
                }

                space.addGlobal(new Score(entities.length));
            } 
        }

        level.onGrid2DLayerLoaded = (grid, layer) -> {
            if (layer.name == "collisions") {
                var array = [for (x in 0...grid[0].length) [for (y in 0...grid.length) Value.NONE]];
                space.addGlobal(new CollisionLayer(array));

                for (y in 0...grid.length) {
                    for (x in 0...grid[0].length) {
                        switch (grid[y][x]) {
                            case "s": makeDog(x, y);
                            case "w": array[x][y] = Value.WALL;
                            case "g": array[x][y] = Value.GOAL;
                            case "t": array[x][y] = Value.TRAP;
                        }
                    }
                }
                space.addGlobal(new CollisionLayer(array));
            }
        }


        space.addSystem(new PlayerControls());
        space.addSystem(new MoveEntities());
        space.addSystem(new SheepAI());

        space.addSystem(new AnimPos());
        space.addSystem(new AnimDirection());

        space.addSystem(new SheepVerif());
        space.addSystem(new SheepCleanup());


        level.load();
    }

    private function makeDog(x: Float, y: Float) {
        var dog = new Entity();
        dog.add(new Position(x, y));
        dog.add(new Anim(["run" => new h2d.Anim(dogRunTiles, 8, layers), "idle" => new h2d.Anim(dogIdleTiles, 8, layers)], "idle", 16, 28));
        dog.add(new Speed(3));
        dog.add(new Player());
        space.addEntity(dog);
    }

    private function makeSheep(x: Float, y: Float) {
        var sheepRunAnim = new h2d.Anim(sheepRunTiles, 8, layers);
        var sheepIdleAnim = new h2d.Anim(sheepIdleTiles, 8, layers);

        var sheep = new Entity();
        sheep.add(new Position(x, y));
        sheep.add(new Anim(["run" => sheepRunAnim, "idle" => sheepIdleAnim], "idle", 16, 28));
        sheep.add(new Speed(1.5));
        sheep.add(new Sheep());
        space.addEntity(sheep);
    }

    public override function update(dt:Float) {
        super.update(dt);
        ecoEngine.update(dt);
    }

    private static var levelName = "test_level.json";

    static function main() {
        hxd.Res.initEmbed();

        //trace("Input the level file (default: test_level.json) : ");
        //levelName = Sys.stdin().readLine();
        new Main();
    }
}