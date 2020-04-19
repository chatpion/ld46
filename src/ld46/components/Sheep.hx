package ld46.components;

import economy.Component;
import economy.Entity;

class Sheep implements Component {
    public var herd: List<Entity>;

    public function new() {
        this.herd = new List();
    }
}