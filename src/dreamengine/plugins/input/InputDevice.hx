package dreamengine.plugins.input;

import kha.input.Keyboard;

@:enum
abstract InputDevice(Int) from Int{
    public var Keyboard = 0;
    public var Pointer = 1;
    public var Gamepad = 2;

    @:from
    public static function getDevice(dev:String){
        switch(dev.toLowerCase()){
            case "keyboard":return Keyboard;
            case "pointer": return Pointer;
            case "gamepad": return Gamepad;  
        }
        return 0;
    }
}