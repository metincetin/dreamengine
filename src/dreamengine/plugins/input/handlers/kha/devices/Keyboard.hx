package dreamengine.plugins.input.handlers.kha.devices;

import kha.input.KeyCode;
import dreamengine.plugins.input.devices.BaseKeyboard;

class Keyboard extends BaseKeyboard{
    var khaKeyboardReference:kha.input.Keyboard;

    var pressedKeys = new Array<Int>();

    public function new(index:Int){
        super(index);

        khaKeyboardReference = kha.input.Keyboard.get(index);
        khaKeyboardReference.notify(onKhaKeyDown, onKhaKeyUp);
    }

	function onKhaKeyDown(key:KeyCode){
        var conv = convertKeyCode(key);
        if (keyPressed.exists(conv)){
            for (f in keyPressed.get(conv)){
                f();
            }
        }
        pressedKeys.push(conv);
    }

	function onKhaKeyUp(key:KeyCode){
        var conv = convertKeyCode(key);
        if (keyReleased.exists(conv)){
            for (f in keyPressed.get(conv)){
                f();
            }
        }
        pressedKeys.remove(conv);
    }

    override function isKeyPressed(key:Int):Bool {
        return pressedKeys.contains(key);
    }

    function convertKeyCode(key:KeyCode):KeyboardKey{
        return cast key;
    }
}
