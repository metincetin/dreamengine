package dreamengine.plugins.input.events;

import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;

class KeyboardKeyEvent {
	public var key:KeyboardKey;
	public var shift:Bool;
	public var ctrl:Bool;

	public function new(key:KeyboardKey, shift:Bool, ctrl:Bool) {
		this.key = key;
		this.shift = shift;
		this.ctrl = ctrl;
	}

	public function toString() {
		var t = String.fromCharCode(cast key);
		if (shift) {
			t = t.toUpperCase();
		} else {
			t = t.toLowerCase();
		}
		return t;
	}

	public function isBackspace() {
		return key == Backspace;
	}
}
