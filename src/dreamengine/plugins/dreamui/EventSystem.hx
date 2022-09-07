package dreamengine.plugins.dreamui;

import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.core.math.Vector.Vector2;

class EventSystem {
	var focused:IFocusable;
	var pointerPosition:Vector2;
	var hovered:Widget;

	public function setPointerPosition(position:Vector2) {
		pointerPosition = position;
	}

	public function update() {
		// look up the widget that is on top
	}

	public function getFocused() {
		return focused;
	}

	public function setFocused(focusable:IFocusable) {
		if (focusable != focused && focusable.canBeFocused()) {
			if (focused != null) {
				focused.onFocusLost();
			}
			this.focused = focusable;
			this.focused.onFocused();
		}
	}
}
