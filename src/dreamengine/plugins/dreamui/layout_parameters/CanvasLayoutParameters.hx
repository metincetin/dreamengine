package dreamengine.plugins.dreamui.layout_parameters;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class CanvasLayoutParameters extends LayoutParameters{
    public var anchorsMin:Vector2 = Vector2.zero();
	public var anchorsMax:Vector2 = Vector2.zero();

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
}