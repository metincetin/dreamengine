package dreamengine.plugins.dreamui.elements;

import dreamengine.plugins.dreamui.containers.HorizontalBoxContainer;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.events.PointerEventData;
import dreamengine.plugins.dreamui.events.IClickable;
import kha.graphics2.Graphics;

class ToggleBox extends Element implements IClickable {
	var value:Bool;

	var label:Label;
	var image:Image;
	var layoutContainer:Element;

	var text:String;

	public function new(){
		super();
		layoutContainer = new HorizontalBoxContainer();
		addChild(layoutContainer);

		image = new Image();
		label = new Label(text);


		layoutContainer.addChild(image);
		layoutContainer.addChild(label);
	}

	public function setText(text:String){
		this.text = text;
		label.setText(text);
	}

	public function setValue(value:Bool){
		this.value = value;
		if (value)
			image.addStyleClass("activated");
		else
			image.removeStyleClass("activated");
	}

	public function getValue(){ return value; }

	override function getPreferredSize():Vector2 {
		return layoutContainer.getPreferredSize();
	}

	public function canBeTargeted():Bool {
		return true;
	}

	public function onPressed(data:PointerEventData) {
		value = !value;
	}

	public function onPointerEntered() {}

	public function onReleased(data:PointerEventData) {}

	public function onPointerExited() {}
	override function onRender(g2:Graphics, opacity:Float) {
		super.onRender(g2, opacity);
	}
}
