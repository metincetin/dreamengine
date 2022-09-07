package dreamengine.plugins.dreamui.slots;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.device.Screen;

class ScreenSlot extends BaseSlot {
	public function new(p:Widget) {
		super(p);
	}

	public override function getSize():Vector2 {
		return Screen.getResolution().asVector2();
	}
}
