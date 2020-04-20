package ld46;

import hxd.Key;
import hxd.Direction;
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
    var dogDeadTiles: Array<h2d.Tile>;
    var dogSRunTiles: Array<h2d.Tile>;
    var dogSIdleTiles: Array<h2d.Tile>;
    var wolfRunTiles: Array<h2d.Tile>;
    var wolfIdleTiles: Array<h2d.Tile>;
    var wolfDeadTiles: Array<h2d.Tile>;
    var sheepRunTiles: Array<h2d.Tile>;
    var sheepIdleTiles: Array<h2d.Tile>;
    var sheepDeadTiles: Array<h2d.Tile>;

    var layers: h2d.Layers;

    override private function init() {
        super.init();

        //var project = ogmo.Project.create(hxd.Res.levels.entry.getText());
        //var level = ogmo.Level.create(hxd.Res.test_level.entry.getText());

        hxd.Window.getInstance().resize(640, 640);

        #if ask
        var loader = new hxd.res.Loader(new hxd.fs.LocalFileSystem("res/", ""));
        #end

        var project = ogmo.Project.create(hxd.Res.loader.load("levels.ogmo").toText());
        
        #if ask
        var level = ogmo.Level.create(loader.load(levelName + ".json").toText());
        #else
        var level = ogmo.Level.create(hxd.Res.loader.load(levelName + ".json").toText());
        #end


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
        dogDeadTiles = [tileImage.sub(4 * tw, 0, tw, th)];
        dogSRunTiles = [tileImage.sub(6 * tw, 0, tw, th), tileImage.sub(7 * tw, 0, tw, th)];
        dogSIdleTiles = [tileImage.sub(9 * tw, 0, tw, th)];
        wolfRunTiles = [tileImage.sub(tw, 8 * th, tw, th), tileImage.sub(2 * tw, 8 * th, tw, th)];
        wolfIdleTiles = [tileImage.sub(0, 8 * th, tw, th)];
        wolfDeadTiles = [tileImage.sub(3 * tw, 8 * th, tw, th)];
        sheepRunTiles = [tileImage.sub(0, th, tw, th), tileImage.sub(tw, th, tw, th)];
        sheepIdleTiles = [tileImage.sub(3 * tw, th, tw, th)];
        sheepDeadTiles = [tileImage.sub(4 * tw, th, tw, th)];

        for (t in [dogRunTiles, dogIdleTiles, dogDeadTiles, dogSRunTiles, dogSIdleTiles].flatten()) {
            t.dx = -16;
            t.dy = -28;
        }


        for (t in [sheepRunTiles, sheepIdleTiles, sheepDeadTiles].flatten()) {
            t.dx = -16;
            t.dy = -28;
        }

        for (t in [wolfRunTiles, wolfIdleTiles, wolfDeadTiles].flatten()) {
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
        space.addGlobal(new Background(tileSet, background, tw, th, Std.int(level.width / tw), Std.int(level.height / th)));

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
                    if (entity.name != "sheep") continue;
                    var x: Float = entity.x / tw;
                    var y: Float = entity.y / th;
                    makeSheep(x, y);
                }

                space.addGlobal(new Score(entities.length));
            } else if (layer.name == "wolves") {
                for (entity in entities) {
                    if (entity.name != "wolf") continue;
                    var x: Float = entity.x / tw;
                    var y: Float = entity.y / th;
                    makeWolf(x, y);
                }
            } else if (layer.name == "trucks") {
                for (entity in entities) {
                    if (entity.name != "truck_spawner") continue;
                    var x: Float = entity.x / tw;
                    var y: Float = entity.y / th;
                    var dir: hxd.Direction = switch (entity.values["Direction"]) {
                        case "NORTH": Direction.Up;
                        case "SOUTH": Direction.Down;
                        case "EAST": Direction.Right;
                        case "WEST": Direction.Left;
                        default: throw "halp";
                    };
                    var minDelay: Float = entity.values["MinDelay"];
                    var maxDelay: Float = entity.values["MaxDelay"];
                    var speed: Float = entity.values["Speed"];
                    var e = new Entity();
                    e.add(new Position(x, y));
                    e.add(new TruckSpawner(dir, minDelay, maxDelay, speed));
                    space.addEntity(e);
                }
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
        space.addSystem(new SheepAI());
        space.addSystem(new WolfAI());
        space.addSystem(new MoveEntities());

        space.addSystem(new SpawnTruck(tileImage.sub(11 * tw, 5 * th, 2 * tw, 2 * th, -32, -32), tileImage.sub(8 * tw, 5 * th, 3 * tw, 2 * th, -48, -44)));
        space.addSystem(new TruckManager());

        space.addSystem(new SheepVerif());

        space.addSystem(new AnimCleanup());

        space.addSystem(new Camera());

        space.addSystem(new AnimPos());
        space.addSystem(new AnimDirection());

        level.load();
    }

    private function makeDog(x: Float, y: Float) {
        var run = new h2d.Anim(dogRunTiles, 8, layers);
        var idle = new h2d.Anim(dogIdleTiles, 8, layers);
        var dead = new h2d.Anim(dogDeadTiles, 8, layers);
        var runS = new h2d.Anim(dogSRunTiles, 8, layers);
        var idleS = new h2d.Anim(dogSIdleTiles, 8, layers);

        var dog = new Entity();
        dog.add(new Position(x, y));
        dog.add(new Anim(["run" => run, "idle" => idle, "dead" => dead, "runS" => runS, "idleS" => idleS], "idle", false, true));
        dog.add(new Speed(3));
        dog.add(new Alive());
        dog.add(new Player());
        space.addEntity(dog);
    }

    private function makeSheep(x: Float, y: Float) {
        var sheepRunAnim = new h2d.Anim(sheepRunTiles, 8, layers);
        var sheepIdleAnim = new h2d.Anim(sheepIdleTiles, 8, layers);
        var sheepDeadAnim = new h2d.Anim(sheepDeadTiles, 8, layers);

        var sheep = new Entity();
        sheep.add(new Position(x, y));
        sheep.add(new Anim(["run" => sheepRunAnim, "idle" => sheepIdleAnim, "dead" => sheepDeadAnim], "idle", false, true));
        sheep.add(new Speed(1.5));
        sheep.add(new Alive());
        sheep.add(new Sheep());
        space.addEntity(sheep);
    }

    private function makeWolf(x: Float, y: Float) {
        var wolfRunAnim = new h2d.Anim(wolfRunTiles, 8, layers);
        var wolfIdleAnim = new h2d.Anim(wolfIdleTiles, 8, layers);
        var wolfDeadAnim = new h2d.Anim(wolfDeadTiles, 8, layers);

        var wolf = new Entity();
        wolf.add(new Position(x, y));
        wolf.add(new Anim(["run" => wolfRunAnim, "idle" => wolfIdleAnim, "dead" => wolfDeadAnim], "idle", false, true));
        wolf.add(new Speed(2.5));
        wolf.add(new Alive());
        wolf.add(new Wolf(x, y));
        space.addEntity(wolf);
    }

    var paused = false;

    public override function update(dt:Float) {
        super.update(dt);

        if (Key.isPressed(Key.P))
            paused = !paused;

        if (!paused)
            ecoEngine.update(dt);

        // layers.ysort(1);
    }

    private static var levelName = "test_level";

    static function main() {
        hxd.Res.initEmbed();

        #if ask
        trace("Input the level file (default: test_level) : ");
        levelName = Sys.stdin().readLine();
        #end
        new Main();
    }
}