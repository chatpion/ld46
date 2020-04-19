package ld46.components;

import h2d.Object;
import economy.Component;

class Anim implements Component {
    private var anims: Map<String, h2d.Anim>;
    public var currentAnim(default, set): h2d.Anim; 
    public var dx: Int;
    public var dy: Int;

    private var parent: h2d.Layers;

    public function new(anims: Map<String, h2d.Anim>, defaultAnim: String, dx: Int, dy: Int) {
        this.anims = anims;
        this.dx = dx;
        this.dy = dy;

        this.parent = cast(anims[defaultAnim].parent);

        for (_ => a in anims)
            a.remove();
        this.setCurrentAnim(defaultAnim);
    }

    public function setCurrentAnim(s: String) {
        this.currentAnim = anims[s];
    }

    public function set_currentAnim(a: h2d.Anim): h2d.Anim {
        this.currentAnim.remove();
        parent.add(a, 1);
        return this.currentAnim = a;
    } 
}