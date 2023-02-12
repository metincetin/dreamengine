package dreamengine.plugins.input.devices;

import kha.input.KeyCode;
import dreamengine.plugins.input.events.KeyboardKeyEvent;
import haxe.Constraints.Function;

class BaseKeyboard implements IKeyDevice {
	var index:Int;

	var keyPressed:Map<Int, Array<Void->Void>> = new Map<Int, Array<Void->Void>>();
	var keyReleased:Map<Int, Array<Void->Void>> = new Map<Int, Array<Void->Void>>();
	var inputReceived:Array<KeyboardKeyEvent->Void> = new Array<KeyboardKeyEvent->Void>();

	public function new(index:Int) {
		this.index = index;
	}

	public function addInputListener(f:KeyboardKeyEvent->Void) {
		inputReceived.push(f);
	}

	public function removeInputListener(f:KeyboardKeyEvent->Void) {
		inputReceived.remove(f);
	}

	public function addKeyPressedListener(key:Int, f:Void->Void) {
		if (!keyPressed.exists(key)) {
			keyPressed.set(key, new Array());
		}
		keyPressed.get(key).push(f);
	}

	public function removeKeyPressedListener(f:Void->Void) {
		var t = -1;
		for (v in keyPressed.keyValueIterator()) {
			if (v.value.contains(f)) {
				t = v.key;
				break;
			}
		}
		if (t != -1) {
			keyPressed.get(t).remove(f);
		}
	}

	public function addKeyReleasedListener(key:Int, f:Void->Void) {
		if (!keyReleased.exists(key)) {
			keyReleased.set(key, new Array());
		}
		keyReleased.get(key).push(f);
	}

	public function removeKeyReleasedListener(f:Void->Void) {
		var t = -1;
		for (v in keyReleased.keyValueIterator()) {
			if (v.value.contains(f)) {
				t = v.key;
				break;
			}
		}
		if (t != -1) {
			keyPressed.get(t).remove(f);
		}
	}

	public function isKeyPressed(key:Int):Bool {
		return false;
	}

	public function isKeyJustPressed(key:Int):Bool {
		return false;
	}

	public function isKeyJustReleased(key:Int):Bool {
		return false;
	}
}

@:enum abstract KeyboardKey(Int) to Int {
	var F = 70;
	var G = 71;
	var I = 73;
	var O = 79;
	var D = 68;
	var R = 82;
	var N = 78;
	var H = 72;
	var P = 80;
	var Q = 81;
	var W = 87;
	var U = 85;
	var E = 69;
	var A = 65;
	var T = 84;
	var K = 75;
	var M = 77;
	var L = 76;
	var Y = 89;
	var X = 88;
	var J = 74;
	var V = 86;
	var C = 67;
	var Z = 90;
	var S = 83;
	var B = 66;
	var F1 = 112;
	var F2 = 113;
	var F3 = 114;
	var F4 = 115;
	var F5 = 116;
	var F6 = 117;
	var F7 = 118;
	var F8 = 119;
	var F9 = 120;
	var F10 = 121;
	var F11 = 122;
	var F12 = 123;
	var ESC = 27;
	var Asteriks = 0;
	var Tab = 9;
	var CapsLock = 20;
	var NumLock = 144;
	var LShift = 16;
	var LCTRL = 17;
	var Windows = 0;
	var Alt = 18;
	var AltGR = 225;
	var RCTRL = 17;
	var RShift = 16;
	var Return = 13;
	var Backspace = 8;
	var ArrowLeft = 37;
	var ArrowUp = 38;
	var ArrowDown = 40;
	var ArrowRight = 39;
	var Del = 46;
	var End = 35;
	var PgUp = 33;
	var PgDn = 34;
	var Home = 36;
	var Ins = 45;
	var ScrollLock = 145;
	var Pause = 19;
	var Digit1 = 49;
	var Digit2 = 50;
	var Digit3 = 51;
	var Digit4 = 52;
	var Digit5 = 53;
	var Digit6 = 54;
	var Digit7 = 55;
	var Digit8 = 56;
	var Digit9 = 57;
	var Digit0 = 48;
	var Slash = 191;
	var NumPad1 = 0;
	var NumPad2 = 0;
	var NumPad3 = 0;
	var NumPad4 = 0;
	var NumPad5 = 0;
	var NumPad6 = 0;
	var NumPad7 = 0;
	var NumPad8 = 0;
	var NumPad9 = 0;
	var NumPad0 = 0;
	var NumpadAdd = 107;
	var NumpadSubtract = 109;
	var Space = 32;
}
