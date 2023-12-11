package dreamengine.plugins.dreamui.elements;

import dreamengine.core.math.Vector2i;
import dreamengine.plugins.dreamui.events.IDraggable;
import dreamengine.plugins.dreamui.events.PointerEventData;
import dreamengine.plugins.dreamui.events.IClickable;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.events.IPointerTarget;
import dreamengine.core.math.Mathf;
import dreamengine.plugins.dreamui.Element;

class Slider extends Element implements IPointerTarget implements IClickable implements IDraggable {
	var value = 0.4;

	var minValue = 0.0;
	var maxValue = 1.0;

	var step:Float = 0;

	public function new() {
		super();
		addChild(new SliderHandle());
	}

	public function getValue() {
		return value;
	}

	public function setValue(v:Float) {
		value = Mathf.clamp(v, getMinValue(), getMaxValue());
		if (getStep() > 0) {
            value = Mathf.round(value / getStep()) * getStep();
            trace(value);
        }
		setDirty();
	}

	public function getMinValue() {
		return minValue;
	}

	public function getMaxValue() {
		return maxValue;
	}

	public function setMinValue(value:Float) {
		minValue = value;
	}

	public function setMaxValue(value:Float) {
		maxValue = value;
	}

	public function getStep() {
		return step;
	}

	public function setStep(value:Float) {
		step = value;
	}

	override function getPreferredSize():Vector2 {
		return [0, 32];
	}

	public override function layout() {
		var p = getChild(0);
		var thisPos = rect.getPosition();
		var handlePos = Vector2.zero();
		handlePos.x = Mathf.lerp(rect.getMin().x, rect.getMax().x, Mathf.inverseLerp(minValue, maxValue, value));
		handlePos.y = thisPos.y;

		p.rect.setPosition(handlePos);
	}

	override function onRender(g2:Graphics, opacity:Float) {
		var pos = rect.getPosition();
		var size = rect.getSize();
		g2.drawRect(pos.x, pos.y, size.x, size.y);
	}

	public function canBeTargeted():Bool {
		return true;
	}

	public function onPointerEntered() {}

	public function onPointerExited() {}

	function updateValueFromPointerPosition(pos:Vector2i) {
		var inv = Mathf.inverseLerp(rect.getMin().x, rect.getMax().x, pos.x);
		setValue(Mathf.lerp(minValue, maxValue, inv));
	}

	public function onPressed(data:PointerEventData) {
		updateValueFromPointerPosition(data.position);
	}

	public function onReleased(data:PointerEventData) {}

	public function onDrag(data:PointerEventData) {
		updateValueFromPointerPosition(data.position);
	}
}

class SliderHandle extends Element implements IPointerTarget {
	public function canBeTargeted():Bool {
		return true;
	}

	public function onPointerEntered() {}

	public function onPointerExited() {}

	override function onRender(g2:Graphics, opacity:Float) {
		var r = getRect();
		var p = r.getPosition();
		g2.color = Blue;
		g2.drawRect(p.x - 16, p.y, 32, 32);
		g2.color = White;
	}
}
