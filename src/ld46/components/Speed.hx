package ld46.components;

import h3d.Vector;
import economy.Component;

class Speed implements Component {
    public var v: h3d.Vector;

    public var x(get, set): Float;
    public var y(get, set): Float;

    public var speed: Float;

    public function new(?speed: Float = 1) {
        this.speed = speed;
        this.v = new Vector(0, 0);
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