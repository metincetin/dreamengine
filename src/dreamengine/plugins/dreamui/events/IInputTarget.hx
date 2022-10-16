package dreamengine.plugins.dreamui.events;

import dreamengine.plugins.input.events.KeyboardKeyEvent;
import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;

interface IInputTarget {
	function allowInput():Bool;
	function onInputReceived(key:KeyboardKeyEvent):Void;
}
