package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.slots.FullSlot;
import dreamengine.plugins.dreamui.slots.BaseSlot;

class ElementSwitcher extends Element {
	var currentElement = 0;

	public function setCurrentElement(value:Int) {
		currentElement = value;
		activateChild();
	}

	public function nextElement(shouldReturn:Bool) {
		if (shouldReturn) {
			setCurrentElement((currentElement + 1) % getChildCount());
		} else if (currentElement + 1 < getChildCount()) {
			setCurrentElement(currentElement + 1);
		}
	}

	function activateChild() {
		if (getChildCount() == 0)
			return;
		for (i in 0...getChildCount()) {
			getChild(i).setEnabled(i == currentElement);
		}
	}

	override function addChild(c:Element) {
		super.addChild(c);
		if (getChildCount() == 1) {
			setCurrentElement(0);
		} else {
			if (getChildCount() - 1 != currentElement) {
				c.setEnabled(false);
			}
		}
	}

	override function getChildSlotType():Class<BaseSlot> {
		return FullSlot;
	}

	override function createSlotForChild():BaseSlot {
		return new FullSlot(this);
	}
}
