package dreamengine.plugins.input;

class InputDefinition {
	public var name: String = "";
	public var inputType:InputType = Button;
	public var bindings = new Array<InputBinding>();

	public function new() {}

	public function getValue() {
		return 0;
	}
}
