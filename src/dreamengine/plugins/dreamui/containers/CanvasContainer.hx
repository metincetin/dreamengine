package dreamengine.plugins.dreamui.containers;

import dreamengine.device.Screen;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.*;

class CanvasContainer extends Element {
	public override function createLayoutParametersForChild():LayoutParameters {
		return new CanvasLayoutParameters();
	}
	
	override function getChildLayoutParameterType():Class<LayoutParameters> {
		return CanvasLayoutParameters;
	}


	override function layout() {
		for (c in children){
			c.rect.size = getSizeFor(c);
			c.rect.position = getPositionFor(c);
		}
	}

	function getPositionFor(element:Element):Vector2 {
		var parentPos:Vector2;
		var parentSize:Vector2;

		var parameters = element.getLayoutParametersAs(CanvasLayoutParameters);

		if (parent != null) {
			parentPos = parent.getRect().position;
			parentSize = parent.getRect().size;
		} else {
			parentPos = Vector2.zero();
			parentSize = Screen.getResolution().asVector2();
		}
		var pos = Vector2.zero();
		
		pos.x = parentPos.x + parentSize.x * parameters.anchorsMin.x + parameters.offset.x;
		pos.y = parentPos.y + parentSize.y * parameters.anchorsMin.y + parameters.offset.y;
		
		
		return pos;
	}

	public function getSizeFor(element:Element) {
		var parentPos:Vector2;
		var parentSize:Vector2;

		var parameters = element.getLayoutParametersAs(CanvasLayoutParameters);

		if (parent != null) {
			parentPos = parent.getRect().position;
			parentSize = parent.getRect().size;
		} else {
			parentPos = Vector2.zero();
			parentSize = Screen.getResolution().asVector2();
		}

		var size = Vector2.zero();

		size.x = parentSize.x * (parameters.anchorsMax.x - parameters.anchorsMin.x) + parameters.sizeOffset.x;
		size.y = parentSize.y * (parameters.anchorsMax.y - parameters.anchorsMin.y) + parameters.sizeOffset.y;

		return size;
	}
}
