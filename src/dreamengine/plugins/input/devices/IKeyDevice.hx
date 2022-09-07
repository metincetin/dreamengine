package dreamengine.plugins.input.devices;

import haxe.Constraints.Function;

interface IKeyDevice{
    public function addKeyPressedListener(key:Int, f:Function):Void;
    public function removeKeyPressedListener(f:Function):Void;
    
    public function addKeyReleasedListener(key:Int, f:Function):Void;
    public function removeKeyReleasedListener(f:Function):Void;

    public function isKeyPressed(key:Int):Bool;

}

class KeyEventInfo{}