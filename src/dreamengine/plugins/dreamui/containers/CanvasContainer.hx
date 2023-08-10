package dreamengine.plugins.dreamui.containers;

import dreamengine.core.math.Mathf;
import dreamengine.device.Screen;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.*;

class CanvasContainer extends Element {
	public override function createLayoutParametersForChild():LayoutParameters {
		return new CanvasLayoutParameters();
	}

	override function getChildLayoutParameterType():Class<LayoutParameters> {
		return CanvasLayoutParameters;
	}

	override function layout() {
		for (c in children) {
			c.rect.setSize(getSizeFor(c));
			c.rect.setPosition(getPositionFor(c));
		}
	}

	function getPositionFor(element:Element):Vector2 {
		var parentPos:Vector2 = rect.getPosition();
		var parentSize:Vector2 = rect.getSize();

		var parameters = element.getLayoutParametersAs(CanvasLayoutParameters);

		/*if (parent != null) {
				parentPos = parent.getRect().getPosition();
				parentSize = parent.getRect().getPosition();
			} else {
				parentPos = Vector2.zero();
				parentSize = Screen.getResolution().asVector2();
		}*/

		var pivotOffset = Vector2.zero();
		var pivot = element.getPivot();

		var selfSize = element.getRect().getSize();

		pivotOffset.x = selfSize.x * pivot.x * (1 - (parameters.anchorsMax.x - parameters.anchorsMin.x));
		pivotOffset.y = selfSize.y * pivot.y * (1 - (parameters.anchorsMax.y - parameters.anchorsMin.y));

		var pos = Vector2.zero();

		pos.x = parentPos.x + parentSize.x * parameters.anchorsMin.x + parameters.offset.x - pivotOffset.x;
		pos.y = parentPos.y + parentSize.y * parameters.anchorsMin.y + parameters.offset.y - pivotOffset.y;

		return pos;
	}

	public function getSizeFor(element:Element) {
		var parentPos:Vector2 = rect.getPosition();
		var parentSize:Vector2 = rect.getSize();

		var parameters = element.getLayoutParametersAs(CanvasLayoutParameters);
		var prefSize = element.getPreferredSize();

		/*if (parent != null) {
				parentPos = parent.getRect().getPosition();
				parentSize = parent.getRect().getSize();
			} else {
				parentPos = Vector2.zero();
				parentSize = Screen.getResolution().asVector2();
		}*/

		var size = Vector2.zero();

		size.x = Math.max(parentSize.x * (parameters.anchorsMax.x - parameters.anchorsMin.x) + parameters.sizeOffset.x, prefSize.x);
		size.y = Math.max(parentSize.y * (parameters.anchorsMax.y - parameters.anchorsMin.y) + parameters.sizeOffset.y, prefSize.y);

		return size;
	}
}
