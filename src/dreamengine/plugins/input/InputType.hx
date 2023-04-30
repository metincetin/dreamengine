package dreamengine.plugins.input;

@:enum
abstract InputType(Int) {
	var Button = 0;
	var Float = 1;
	var Vector = 2;

	@:from
	static function fromString(value:String) {
		switch (value.toLowerCase()) {
			case "button":
				return Button;
			case "float":
				return Float;
			case "vector":
				return Vector;
		}
		return Button;
	}
}

@:enum abstract InputValue(Int) {
	var Digital = 0;
	var Analog = 1;
}
