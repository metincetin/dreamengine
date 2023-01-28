package dreamengine.plugins.dreamui.styling;

class ParsedStyle {
	var values = new Map<String, String>();

	function new() {}

	public static function forElement(element:Element) {
		var style = element.getStyle();
		var ret = new ParsedStyle();
		for (selectorString in style.getSelectors()) {
			var selector = new Selector(selectorString);
			if (element.matchesQuerySelector(selector)) {
				var map = style.getValueMapOfSelector(selectorString);
				for (key => value in map) {
					ret.values.set(key, value);
				}
			}
		}
		return ret;
	}

	public function getStringValue(key:String, defaultValue:String = "") {
		if (values.exists(key)) {
			return values[key];
		}
		return defaultValue;
	}

	public function getIntValue(key:String, defaultValue = 0) {
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
		if (values.exists(key)) {
			var v = Std.parseFloat(values[key]);
			if (v == null) {
				return defaultValue;
			}
			return v;
		}
		return defaultValue;
	}

	public function getColorValue(key:String, defaultValue = kha.Color.White) {
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
