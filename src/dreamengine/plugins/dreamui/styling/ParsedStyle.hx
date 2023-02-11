package dreamengine.plugins.dreamui.styling;

import haxe.DynamicAccess;

class ParsedStyle {
	var values = new Map<String, Dynamic>();

	var state = "";

	function new() {}

	public function resetState() {
		this.state = "";
	}

	public function setState(value:String) {
		this.state = value;
	}

	public function setForElement(element:Element) {
		var style = element.getStyle();
		for (selectorString in style.getSelectors()) {
			var selector = new Selector(selectorString);
			if (element.matchesQuerySelector(selector)) {
				var map = style.getValueMapOfSelector(selectorString);
				for (key => value in map) {
					values.set(key, value);
				}
			}
		}
	}

	function hasValueOfState(state:String, key:String){
		return getDynamicAccessOfState(state).exists(key);
	}
	function hasState(state:String) {
		if (!values.exists("states")) {
			return false;
		}

		return getStatesDynamicAccess().exists(state);
	}

	function getStatesDynamicAccess():DynamicAccess<Dynamic> {
		return values["states"];
	}
	function getDynamicAccessOfState(state:String):DynamicAccess<Dynamic>{
		return getStatesDynamicAccess()[state];
	}

	public function getStringValue(key:String, defaultValue:String = "") {
		if (state.length > 0 && hasState(state) && hasValueOfState(state, key)) {
			return Std.string(getDynamicAccessOfState(state)[key]);
		}

		if (values.exists(key)) {
			return Std.string(values[key]);
		}
		return defaultValue;
	}

	public function getIntValue(key:String, defaultValue = 0) {
		if (state.length > 0 && hasState(state) && hasValueOfState(state, key)) {
			var v = getDynamicAccessOfState(state)[key];
			if (v != null) {
				return v;
			}
		}
		if (values.exists(key)) {
			if (values[key] is Int) {
				return cast values[key];
			}
			var v = Std.parseInt(values[key]);
			if (v == null) {
				return defaultValue;
			}
			return v;
		}
		return defaultValue;
	}

	public function getFloatValue(key:String, defaultValue = 0.0) {
		if (state.length > 0 && hasState(state) && hasValueOfState(state, key)) {
			var v = Std.parseFloat(getDynamicAccessOfState(state)[key]);

			if (!Math.isNaN(v)) {
				return v;
			}
		}
		if (values.exists(key)) {
			var v = Std.parseFloat(values[key]);
			if (Math.isNaN(v)) {
				return defaultValue;
			}
			return v;
		}
		return defaultValue;
	}

	public function getColorValue(key:String, defaultValue = kha.Color.White) {
		if (state.length > 0 && hasState(state) && hasValueOfState(state, key)) {
			try {
				var c = kha.Color.fromString(getDynamicAccessOfState(state)[key]);
				return c;
			} catch (e) {
				return defaultValue;
			}
		}

		if (values.exists(key)) {
			try {
				var c = kha.Color.fromString(values[key]);
				return c;
			} catch (e) {
				return defaultValue;
			}
		}
		return defaultValue;
	}

	public static function empty() {
		return new ParsedStyle();
	}
}
