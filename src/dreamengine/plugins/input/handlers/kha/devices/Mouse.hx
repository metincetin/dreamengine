package dreamengine.plugins.input.handlers.kha.devices;

import dreamengine.core.math.Vector2i;
import dreamengine.plugins.input.devices.BaseMouse;

class Mouse extends BaseMouse {
	var khaMouseReference:kha.input.Mouse;

	public function new(index:Int) {
		super(index);

		// fixme, anywhere better to listen these?
		// and somwhere to unlisten?
		khaMouseReference = kha.input.Mouse.get(index);
		khaMouseReference.notify(onKhaMouseDown, onKhaMouseUp, onKhaMouseMove, onKhaMouseWheel);
	}

	function onKhaMouseDown(button:Int, x:Int, y:Int) {
		// making button enum?
		for (ev in keyPressed[button]) {
			ev();
		}
	}

	function onKhaMouseUp(button:Int, x:Int, y:Int) {
		// making button enum?
		for (ev in keyReleased[button]) {
			ev();
		}
	}

	function onKhaMouseWheel(delta:Int) {}

	function onKhaMouseMove(x:Int, y:Int, newX:Int, newY:Int) {
		pointerPosition.x = x;
		pointerPosition.y = y;
		// fixme: delta is not reset after mouse is stopped. This is expected behaviour, this function is not called as mouse stops
		pointerDelta.x = newX;
		pointerDelta.y = newY;
		for (f in deltaChanged) {
			f(new Vector2i(newX, newY));
		}
	}
}
