package dreamengine.plugins.input;

import dreamengine.plugins.input.devices.BaseKeyboard;
import dreamengine.plugins.input.devices.BaseMouse;

interface IInputHandler {
	public function begin():Void;
	public function end():Void;
	public function getMouse(index:Int):BaseMouse;
	public function getKeyboard(index:Int):BaseKeyboard;
	public function tick():Void;
	public function postTick():Void;
}
