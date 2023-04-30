package dreamengine.plugins.input.devices;

import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;
import haxe.Constraints.Function;

interface IKeyDevice {
	public function addKeyPressedListener(key:Int, f:Void->Void):Void;
	public function removeKeyPressedListener(f:Void->Void):Void;

	public function addKeyReleasedListener(key:Int, f:Void->Void):Void;
	public function removeKeyReleasedListener(f:Void->Void):Void;

	public function addPressedListener(f:(KeyboardKey)->Void): Void;
	public function removePressedListener(f:(KeyboardKey)->Void): Void;
	public function addReleasedListener(f:(KeyboardKey)->Void): Void;
	public function removeReleasedListener(f:(KeyboardKey)->Void): Void;

	public function isKeyPressed(key:Int):Bool;
}

class KeyEventInfo {}
