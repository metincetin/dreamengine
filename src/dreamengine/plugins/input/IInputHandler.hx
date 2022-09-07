package dreamengine.plugins.input;

import dreamengine.plugins.input.devices.BaseMouse;

interface IInputHandler {
	public function begin():Void;
	public function end():Void;
	public function getMouse(index:Int):BaseMouse;
	public function tick():Void;
}
