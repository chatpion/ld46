package ld46.components;

import economy.Component;
import economy.Entity;

class SheepLike implements Component {
    private var noticeMeTimer: Float = 0.8;

    public function new() {
    }

    public function update(delta: Float) {
        noticeMeTimer -= delta;
    }

    public function isAvailable(): Bool {
        return noticeMeTimer < 0;
    }
}