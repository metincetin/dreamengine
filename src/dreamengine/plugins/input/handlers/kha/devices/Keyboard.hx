package dreamengine.plugins.input.handlers.kha.devices;

import dreamengine.plugins.input.events.KeyboardKeyEvent;
import kha.input.KeyCode;
import dreamengine.plugins.input.devices.BaseKeyboard;

class Keyboard extends BaseKeyboard {
	var khaKeyboardReference:kha.input.Keyboard;

	var pressedKeys = new Array<Int>();
	var keysInFrame = new Array<Int>();
	var keysReleasedInFrame = new Array<Int>();

	public function new(index:Int) {
		super(index);

		khaKeyboardReference = kha.input.Keyboard.get(index);
		khaKeyboardReference.notify(onKhaKeyDown, onKhaKeyUp);
	}

	function onKhaKeyDown(key:KeyCode) {
		var conv = convertKeyCode(key);
		if (keyPressed.exists(conv)) {
			for (f in keyPressed.get(conv)) {
				f();
			}
		}
		if (!keysInFrame.contains(conv))
			keysInFrame.push(conv);
		if (!pressedKeys.contains(conv))
			pressedKeys.push(conv);
		for (f in inputReceived) {
			f(new KeyboardKeyEvent(cast key, false, false));
		}
	}

	function onKhaKeyUp(key:KeyCode) {
		var conv = convertKeyCode(key);
		if (keyReleased.exists(conv)) {
			for (f in keyReleased.get(conv)) {
				f();
			}
		}
		keysReleasedInFrame.remove(conv);
		pressedKeys.remove(conv);
	}

	override function isKeyPressed(key:Int):Bool {
		return pressedKeys.contains(key);
	}
	override function isKeyJustPressed(key:Int):Bool {
		return keysInFrame.contains(key); 
	}
	override function isKeyJustReleased(key:Int):Bool{
		return keysReleasedInFrame.contains(key);
	}

	public function clearFrameInput(){
		keysInFrame = [];
		keysReleasedInFrame = [];
	}

	function convertKeyCode(key:KeyCode):KeyboardKey {
		return cast key;
	}
}
