package dreamengine.plugins.dreamui.styling;

import haxe.DynamicAccess;
import haxe.Json;

class Style {
	var json:Dynamic;

	public static function fromJson(value:String) {
		var style = new Style();
		style.json = Json.parse(value);
		return style;
	}

	function new() {}

	public function getSelectors() {
		var dynAccess:haxe.DynamicAccess<Dynamic> = json;
		return dynAccess.keys();
	}

	public function getValueMapOfSelector(selector:String) {
		var dynAccess:haxe.DynamicAccess<Dynamic> = json;
        var values: DynamicAccess<Dynamic> = dynAccess.get(selector);
        if (values != null){
            var ret = new Map<String, Dynamic>();
            for (key => value in values) {
                ret.set(key, value);
            }
            return ret;
        }
        return null;
	}
}
