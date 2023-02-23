package dreamengine.plugins.dreamui.layout_parameters;

import dreamengine.plugins.dreamui.styling.ParsedStyle;

@:enum abstract HorizontalAlignment(Int) from Int {
	var Left = 0;
	var Center = 1;
	var Right = 2;
	var Stretch = 3;

	inline function new(i:Int) {
		this = i;
	}

	@:from
	static public function from(i:Int){
		return new HorizontalAlignment(i);
	}
	@:from
	static public function fromString(i:String){
		return switch(i){
            case "left":
                Left;
            case "center":
                Center;
            case "right":
                Right;
            case "stretch":
                Stretch;
            case _:
                Left;
		}
	}

}


class VerticalBoxLayoutParameters extends LayoutParameters{
    public var horizontalAlignment:HorizontalAlignment = Stretch;

    override function setValuesFromStyle(parsedStyle:ParsedStyle) {
        this.horizontalAlignment = parsedStyle.getStringValue("layout.horizontal-alignment", "stretch"); 
    }
}