package ld46;

enum Value {
    GOAL; TRAP; WALL; NONE;
}

class CollisionLayer {
    private var grid: Array<Array<Value>>;

    public function new(grid: Array<Array<Value>>) {
        this.grid = grid;
    }

    public inline function isGoal(x: Int, y: Int): Bool {
        return grid[x][y] == GOAL;
    }

    public inline function isTrap(x: Int, y: Int): Bool {
        return grid[x][y] == TRAP;
    }

    public inline function isWall(x: Int, y: Int): Bool {
        return grid[x][y] == WALL;
    }

    public function set(x: Int, y: Int, v: Value) {
        grid[x][y] = v;
    }
}

typedef Vec2 = { x: Int, y: Int };

class WorldSize {
    public var tw: Int;
    public var th: Int;

    public function new(tw: Int, th: Int) {
        this.tw = tw;
        this.th = th;
    }
}

class Score {
    public var dead: Int = 0;
    public var saved: Int = 0;
    public var total: Int;
    public var remaining(get, never): Int; public inline function get_remaining() return total - dead - saved;
    
    public function new(total: Int) {
        this.total = total;
    }
}

class Background {
    public var tileSet: Array<h2d.Tile>;
    public var group: h2d.TileGroup;
    public var tw: Int;
    public var th: Int;

    public function new(tileSet: Array<h2d.Tile>, group: h2d.TileGroup, tw: Int, th: Int) {
        this.tileSet = tileSet;
        this.group = group;
        this.tw = tw;
        this.th = th;
    }

    public function replace(x: Int, y: Int, i: Int) {
        this.group.invalidate();
        this.group.add(x * tw, y * th, tileSet[i]);
    }
}