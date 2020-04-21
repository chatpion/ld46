package ld46.components;

import economy.Component;

class Eaten implements Component {
    public var progression: Float;
    public function new(p: Float) {
        this.progression = p;
    }
}