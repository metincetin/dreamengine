package dreamengine.plugins.input;

import dreamengine.plugins.input.InputType.InputValue;

class InputBinding{
    public var name:String = "";
    public var inputType:InputType;
    public var inputValue: InputValue;
    public var value:Dynamic;
    public var device:InputDevice;

    public var positive:String;
    public var negative:String;

    public function new(){
    
    }
}