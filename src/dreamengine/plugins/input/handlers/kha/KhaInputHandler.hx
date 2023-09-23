package dreamengine.plugins.input.handlers.kha;

import dreamengine.plugins.input.handlers.kha.devices.Keyboard;
import dreamengine.plugins.input.devices.BaseKeyboard;
import dreamengine.plugins.input.devices.BaseMouse;
import kha.input.Mouse;

class KhaInputHandler implements IInputHandler {
	var mice = new Array<BaseMouse>();
	var keyboards = new Array<BaseKeyboard>();

	public function new() {}

	public function begin() {}

	public function end() {}

	public function getMouse(index:Int):BaseMouse {
		if (index < mice.length)
			return mice[index];
		var m = new dreamengine.plugins.input.handlers.kha.devices.Mouse(index);
		mice.push(m);
		// smelly-sh code here
		return m;
	}

	public function getKeyboard(index:Int):BaseKeyboard {
		if (index < keyboards.length)
			return keyboards[index];
		var m = new dreamengine.plugins.input.handlers.kha.devices.Keyboard(index);
		keyboards.push(m);
		// smelly-sh code here too
		return m;
	}

	public function tick() {
	}
	public function postTick(){
		for(keyboard in keyboards){
			var k = cast(keyboard, Keyboard);
			k.clearFrameInput();
		}
		for(mouse in mice){
			mouse.update();
		}
	}
}
