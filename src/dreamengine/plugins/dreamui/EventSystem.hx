package dreamengine.plugins.dreamui;

import haxe.rtti.Rtti;
import dreamengine.plugins.input.events.KeyboardKeyEvent;
import dreamengine.plugins.dreamui.events.IInputTarget;
import dreamengine.plugins.dreamui.events.IClickable;
import dreamengine.plugins.input.IInputHandler;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.core.math.Vector.Vector2i;

class EventSystem {
	var focused:IFocusable;
	var pointerPosition:Vector2i = new Vector2i();
	var hovered:Element;
	var uiPlugin:DreamUIPlugin;
	var inputHandler:IInputHandler;

	var currentPointerTarget:IPointerTarget;

	public function new(uiPlugin:DreamUIPlugin, inputHandler:IInputHandler) {
		this.uiPlugin = uiPlugin;
		this.inputHandler = inputHandler;

		this.inputHandler.getMouse(0).addKeyPressedListener(0, onPressed);
		this.inputHandler.getMouse(0).addKeyReleasedListener(0, onReleased);

		this.inputHandler.getKeyboard(0).addInputListener(onInput);
	}

	function onInput(event:KeyboardKeyEvent) {
		if (focused != null && Std.isOfType(focused, IInputTarget)) {
			var inputTarget:IInputTarget = cast focused;
			if (inputTarget.allowInput()) {
				inputTarget.onInputReceived(event);
			}
		}
	}

	function onPressed() {
		if (currentPointerTarget != null && Std.isOfType(currentPointerTarget, IClickable)) {
			var clickable:IClickable = cast currentPointerTarget;
			clickable.onPressed();

			if (Std.isOfType(currentPointerTarget, IFocusable)) {
				setFocused(cast currentPointerTarget);
			}
		} else {
			setFocused(null);
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

		// look up the element that is on top
		var target = uiPlugin.getMainElement();
		if (target == null)
			return;

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

	function getPointerTargetInChildren(ofElement:Element):IPointerTarget {
		if (ofElement.getChildCount() == 0)
			return null;
		var ret:IPointerTarget = null;
		var i = ofElement.getChildCount() - 1;
		while (i >= 0) {
			var c = ofElement.getChild(i);
			if (c.getRenderedRect().isPointInside(pointerPosition.asVector2())) {
				if (Std.isOfType(c, IPointerTarget)) {
					var ofC = getPointerTargetInChildren(c);
					if (ofC == null) {
						return cast c;
					}
				} else {
					return getPointerTargetInChildren(c);
				}
			}

			i--;
		}
		return null;
	}

	public function getFocused() {
		return focused;
	}

	public function setFocused(focusable:IFocusable) {
		if (focusable == null) {
			if (focused != null) {
				focused.onFocusLost();
			}
			focused = null;
			return;
		}
		if (focusable != focused && focusable.canBeFocused()) {
			if (focused != null) {
				focused.onFocusLost();
			}
			this.focused = focusable;
			this.focused.onFocused();
		}
	}
}
