package dreamengine.plugins.dreamui.styling;

import js.html.idb.Cursor;
import dreamengine.core.math.Mathf;
import kha.Color;
import dreamengine.core.Time;
import haxe.DynamicAccess;

class ParsedStyle {
	var values = new Map<String, Dynamic>();

	var previousParsedStyle:ParsedStyle;

	var state = "";

	var time:Float;

	function new() {}

	public function resetState() {
		this.previousParsedStyle = copy();
		this.time = Time.getTime();
		this.state = "";
	}

	function copy() {
		var n = new ParsedStyle();
		n.time = time;
		n.values = values;
		n.state = state;
		return n;
	}

	public function setState(value:String) {
		this.previousParsedStyle = copy();
		this.time = Time.getTime();
		this.state = value;
	}

	function isEmpty() {
		return !values.keys().hasNext();
	}

	function getTransitionDurationNormalized() {
		return Math.min(1, (Time.getTime() - time) / 0.2);
	}

	public function setForElement(element:Element) {
		var style = element.getStyle();
		this.previousParsedStyle = element.getParsedStyle().copy();
		time = Time.getTime();
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

	function hasValueOfState(state:String, key:String) {
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

	function getDynamicAccessOfState(state:String):DynamicAccess<Dynamic> {
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

	public function getIntValue(key:String, defaultValue = 0): Int {
		if (state.length > 0 && hasState(state) && hasValueOfState(state, key)) {
			var v = getDynamicAccessOfState(state)[key];
			if (v != null) {
				return doIntTransition(v, key);
			}
		}
		if (values.exists(key)) {
			if (values[key] is Int) {
				return doIntTransition(cast values[key], key);
			}
			var v = Std.parseInt(values[key]);
			if (v == null) {
				return doIntTransition(defaultValue, key);
			}
			return v;
		}
		return doIntTransition(defaultValue, key);
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

	function doIntTransition(curVal:Int, ofKey:String): Int{
		if (previousParsedStyle != null && !previousParsedStyle.isEmpty()){
			return cast Mathf.lerp(previousParsedStyle.getIntValue(ofKey, curVal), curVal, getTransitionDurationNormalized());
		}

		return curVal;
	}

	function doColorTransition(curCol:Color, ofKey:String) {
		if (previousParsedStyle != null && !previousParsedStyle.isEmpty()) {
			return Mathf.lerpColor(previousParsedStyle.getColorValue(ofKey, curCol), curCol, getTransitionDurationNormalized());
		}

		return curCol;
	}

	public function getColorValue(key:String, defaultValue = kha.Color.White) {
		if (state.length > 0 && hasState(state) && hasValueOfState(state, key)) {
			try {
				var c = kha.Color.fromString(getDynamicAccessOfState(state)[key]);
				return doColorTransition(c, key);
			} catch (e) {
				return doColorTransition(defaultValue, key);
			}
		}

		if (values.exists(key)) {
			try {
				var c = kha.Color.fromString(values[key]);
				return doColorTransition(c, key);
			} catch (e) {
				return doColorTransition(defaultValue, key);
			}
		}
		return doColorTransition(defaultValue, key);
	}

	public static function empty() {
		return new ParsedStyle();
	}
}
