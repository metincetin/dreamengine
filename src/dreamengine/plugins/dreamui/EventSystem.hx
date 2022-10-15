package dreamengine.plugins.dreamui;

import dreamengine.plugins.dreamui.events.IClickable;
import dreamengine.plugins.input.IInputHandler;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.math.Vector.Vector2i;

class EventSystem {
	var focused:IFocusable;
	var pointerPosition:Vector2i = new Vector2i();
	var hovered:Widget;
	var uiPlugin:DreamUIPlugin;
	var inputHandler:IInputHandler;

	var currentPointerTarget:IPointerTarget;

	public function new(uiPlugin:DreamUIPlugin, inputHandler:IInputHandler) {
		this.uiPlugin = uiPlugin;
		this.inputHandler = inputHandler;

		this.inputHandler.getMouse(0).addKeyPressedListener(0, onPressed);
		this.inputHandler.getMouse(0).addKeyReleasedListener(0, onReleased);
	}

	function onPressed() {
		if (currentPointerTarget != null && Std.isOfType(currentPointerTarget, IClickable)) {
			var clickable:IClickable = cast currentPointerTarget;
			clickable.onPressed();
		}
	}

	function onReleased() {
		if (currentPointerTarget != null && Std.isOfType(currentPointerTarget, IClickable)) {
			var clickable:IClickable = cast currentPointerTarget;
			clickable.onReleased();
		}
	}

	public function update() {
		pointerPosition = inputHandler.getMouse(0).getPointerPosition();

		// look up the widget that is on top
		var target = uiPlugin.getMainWidget();

		var pointerTarget = getPointerTargetInChildren(target);
		if (pointerTarget != null) {
			if (currentPointerTarget != pointerTarget) {
				if (currentPointerTarget != null) {
					currentPointerTarget.onPointerExited();
				}
				currentPointerTarget = pointerTarget;
				pointerTarget.onPointerEntered();
			}
		} else {
			if (currentPointerTarget != null)
				currentPointerTarget.onPointerExited();
			currentPointerTarget = null;
		}
	}

	function getPointerTargetInChildren(ofWidget:Widget):IPointerTarget {
		if (ofWidget.getChildCount() == 0)
			return null;
		var ret:IPointerTarget = null;
		for (c in ofWidget.getChildren()) {
			if (c.getRect().isPointInside(pointerPosition.asVector2())) {
				if (Std.isOfType(c, IPointerTarget)) {
					var ofC = getPointerTargetInChildren(c);
					if (ofC == null) {
						return cast c;
					}
				} else {
					return getPointerTargetInChildren(c);
				}
			}
		}
		return null;
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
