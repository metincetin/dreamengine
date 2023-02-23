package dreamengine.plugins.dreamui.layout_parameters;

import dreamengine.plugins.dreamui.styling.ParsedStyle;

@:enum abstract VerticalAlignment(Int) from Int {
	var Top = 0;
	var Center = 1;
	var Bottom = 2;
	var Stretch = 3;

	inline function new(i:Int) {
		this = i;
	}

	@:from
	static public function from(i:Int){
		return new VerticalAlignment(i);
	}
	@:from
	static public function fromString(i:String){
		return switch(i){
            case "top":
                Top;
            case "center":
                Center;
            case "bottom":
                Bottom;
            case "stretch":
                Stretch;
            case _:
                Top;
		}
	}

}


class HorizontalBoxLayoutParameters extends LayoutParameters{
    public var verticalAlignment:VerticalAlignment = Stretch;

    override function setValuesFromStyle(parsedStyle:ParsedStyle) {
        this.verticalAlignment = parsedStyle.getStringValue("layout.vertical-alignment", "stretch"); 
    }
}