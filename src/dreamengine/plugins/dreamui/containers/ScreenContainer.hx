package dreamengine.plugins.dreamui.containers;

import dreamengine.device.Screen;
import dreamengine.core.math.Vector2;

class ScreenContainer extends Element {
	override function layout() {
        var screenResolution = Screen.getResolution();
        
		for (c in children){
			c.rect.setSize(screenResolution.asVector2());
			c.rect.setPosition(Vector2.zero());
		}
	}
}
