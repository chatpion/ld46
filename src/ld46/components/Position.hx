package ld46.components;

import h3d.Vector;
import economy.Component;

class Position implements Component {
    public var x(get, set): Float;
    public var y(get, set): Float;

    public var v: h3d.Vector;

    public function new(?x: Float = 0, ?y: Float = 0) {
        this.v = new Vector(x, y);
    }

    public inline function get_x(): Float {
        return v.x;
    }

    public function set_x(x: Float) {
        v.x = x;
        return x;
    }
    
    public inline function get_y(): Float {
        return v.y;
    }

    public function set_y(y: Float) {
        v.y = y;
        return y;
    }

}