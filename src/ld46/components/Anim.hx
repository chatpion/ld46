package ld46.components;

import h2d.Object;
import economy.Component;

class Anim implements Component {
    private var anims: Map<String, h2d.Anim>;
    public var currentAnim(default, set): h2d.Anim;

    private var parent: h2d.Layers;

    public var lockX: Bool;
    public var lockY: Bool;

    public function new(anims: Map<String, h2d.Anim>, defaultAnim: String, lockX = false, lockY = false) {
        this.anims = anims;

        this.parent = cast(anims[defaultAnim].parent);

        this.lockX = lockX;
        this.lockY = lockY;

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