package dreamengine.plugins.dreamui;

import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;
import kha.input.Keyboard;
import haxe.display.Server.ConfigurePrintParams;
import dreamengine.plugins.dreamui.events.IDraggable;
import haxe.rtti.Rtti;
import dreamengine.plugins.input.events.KeyboardKeyEvent;
import dreamengine.plugins.dreamui.events.IInputTarget;
import dreamengine.plugins.dreamui.events.IClickable;
import dreamengine.plugins.input.IInputHandler;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.plugins.dreamui.events.IFocusable;
import dreamengine.core.math.Vector2i;

class EventSystem {
	var focused:IFocusable;
	var pointerPosition:Vector2i = new Vector2i();

	var hovered:Element;
	var uiPlugin:DreamUIPlugin;
	var inputHandler:IInputHandler;

	var pressed:Bool;

	var currentPointerTarget:IPointerTarget;
	
	var dragStartPosition:Vector2i;

	var dragTarget:IDraggable;

	public function new(uiPlugin:DreamUIPlugin, inputHandler:IInputHandler) {
		this.uiPlugin = uiPlugin;
		this.inputHandler = inputHandler;

		this.inputHandler.getMouse(0).addKeyPressedListener(0, onPressed);
		this.inputHandler.getMouse(0).addKeyReleasedListener(0, onReleased);

		this.inputHandler.getKeyboard(0).addInputListener(onInput);
		this.inputHandler.getKeyboard(0).addPressedListener(onKeyPressed);
	}


	function onKeyPressed(key:Int){
		if (key == KeyboardKey.Backspace && focused != null && focused is IInputTarget){
			var inputTarget:IInputTarget = cast focused;

			inputTarget.onBackspaceRequested();
		}
	}

	function onInput(char:String) {
		if (focused != null && Std.isOfType(focused, IInputTarget)) {
			var inputTarget:IInputTarget = cast focused;
			if (inputTarget.allowInput()) {
				inputTarget.onInputReceived(char);
			}
		}
	}

	function onPressed() {
		if (currentPointerTarget != null && Std.isOfType(currentPointerTarget, IClickable)) {
			var clickable:IClickable = cast currentPointerTarget;
			clickable.onPressed({position: pointerPosition, start: pointerPosition});

			if (Std.isOfType(currentPointerTarget, IFocusable)) {
				setFocused(cast currentPointerTarget);
			}
			if (currentPointerTarget is IDraggable){
				dragStartPosition = pointerPosition;
				dragTarget = cast currentPointerTarget;
			}
		} else {
			setFocused(null);
		}

		pressed = true;
	}

	function onReleased() {
		if (currentPointerTarget != null && Std.isOfType(currentPointerTarget, IClickable)) {
			var clickable:IClickable = cast currentPointerTarget;
			clickable.onReleased({position: pointerPosition, start:pointerPosition});
		}
		dragTarget = null;
		pressed = false;
	}

	public function update() {
		pointerPosition = inputHandler.getMouse(0).getPointerPosition();

		// look up the element that is on top
		var target = uiPlugin.getScreenElement();
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

		if (dragTarget != null){
			dragTarget.onDrag({position: pointerPosition, start: dragStartPosition});
		}
	}

	function getPointerTargetInChildren(ofElement:Element):IPointerTarget {
		if (ofElement.getChildCount() == 0)
			return null;
		var ret:IPointerTarget = null;
		var i = ofElement.getChildCount() - 1;
		while (i >= 0) {
			var c = ofElement.getChild(i);
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
