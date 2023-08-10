package dreamengine.plugins.dreamui.layout_parameters;

import dreamengine.plugins.dreamui.styling.ParsedStyle;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class CanvasLayoutParameters extends LayoutParameters{
    public var anchorsMin:Vector2 = Vector2.half();
	public var anchorsMax:Vector2 = Vector2.half();

	public var offset:Vector2 = Vector2.zero();
	public var sizeOffset:Vector2 = Vector2.zero();

    public function toFullRect() {
		anchorsMin = Vector2.zero();
		anchorsMax = Vector2.one();
	}

    public static function fullRect() {
		var ret = new CanvasLayoutParameters();
		ret.toFullRect();
		return ret;
	}
	override function setValuesFromStyle(parsedStyle:ParsedStyle) {
		super.setValuesFromStyle(parsedStyle);
		anchorsMax.x = parsedStyle.getFloatValue("layout.anchorsMax.x", 0.5);
		anchorsMax.y = parsedStyle.getFloatValue("layout.anchorsMax.y", 0.5);
		anchorsMin.x = parsedStyle.getFloatValue("layout.anchorsMin.x", 0.5);
		anchorsMin.y = parsedStyle.getFloatValue("layout.anchorsMin.y", 0.5);

		offset.x = parsedStyle.getFloatValue("layout.offset.x", 0);
		offset.y = parsedStyle.getFloatValue("layout.offset.y", 0);

		sizeOffset.x = parsedStyle.getFloatValue("layout.sizeOffset.x", 0);
		sizeOffset.y = parsedStyle.getFloatValue("layout.sizeOffset.y", 0);
	}
}