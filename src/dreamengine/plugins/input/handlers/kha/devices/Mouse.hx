package dreamengine.plugins.input.handlers.kha.devices;

import dreamengine.core.math.Vector2i;
import dreamengine.plugins.input.devices.BaseMouse;

class Mouse extends BaseMouse {
	var khaMouseReference:kha.input.Mouse;

	var pressedKeys = new Array<Int>();

	public function new(index:Int) {
		super(index);

		// fixme, anywhere better to listen these?
		// and somwhere to unlisten?
		khaMouseReference = kha.input.Mouse.get(index);
		khaMouseReference.notify(onKhaMouseDown, onKhaMouseUp, onKhaMouseMove, onKhaMouseWheel);
	}

	function onKhaMouseDown(button:Int, x:Int, y:Int) {
		// making button enum?
		if (!pressedKeys.contains(button))
			pressedKeys.push(button);
		if (keyPressed.exists(button)){
			for (ev in keyPressed[button]) {
				ev();
			}
		}
	}

	function onKhaMouseUp(button:Int, x:Int, y:Int) {
		// making button enum?
		pressedKeys.remove(button);
		if (keyReleased.exists(button)){
			for (ev in keyReleased[button]) {
				ev();
			}
		}
	}

	function onKhaMouseWheel(delta:Int) {
		wheelDelta = delta;
	}

	override function getWheelDelta():Float {
		return wheelDelta;
	}
	override function isKeyPressed(key:Int):Bool {
		return pressedKeys.contains(key);
	}

	function onKhaMouseMove(x:Int, y:Int, newX:Int, newY:Int) {
		pointerPosition.x = x;
		pointerPosition.y = y;

		pointerDelta.x = newX;
		pointerDelta.y = newY;
		for (f in deltaChanged) {
			f(new Vector2i(newX, newY));
		}
	}
}
