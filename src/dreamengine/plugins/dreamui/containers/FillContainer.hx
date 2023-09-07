package dreamengine.plugins.dreamui.containers;

import dreamengine.device.Screen;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.*;

class FillContainer extends Element {
	public override function createLayoutParametersForChild():LayoutParameters {
		return null;
	}
	
	override function getChildLayoutParameterType():Class<LayoutParameters> {
		return null;
	}


	override function layout() {
        var size = getRect().getSize();
		for (c in children){
			if (c.visibility == Collapsed) continue;
			c.rect.setSize(size);
			c.rect.setPosition(Vector2.zero());
		}
	}
}
