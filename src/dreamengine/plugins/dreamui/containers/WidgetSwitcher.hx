package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.slots.FullSlot;
import dreamengine.plugins.dreamui.slots.BaseSlot;

class WidgetSwitcher extends Widget {
	var currentWidget = 0;

	public function setCurrentWidget(value:Int) {
		currentWidget = value;
		activateChild();
	}

	public function nextWidget(shouldReturn:Bool) {
		if (shouldReturn) {
			setCurrentWidget((currentWidget + 1) % getChildCount());
		} else if (currentWidget + 1 < getChildCount()) {
			setCurrentWidget(currentWidget + 1);
		}
	}

	function activateChild() {
		if (getChildCount() == 0)
			return;
		for (i in 0...getChildCount()) {
			getChild(i).setEnabled(i == currentWidget);
		}
	}

	override function addChild(c:Widget) {
		super.addChild(c);
		if (getChildCount() == 1) {
			setCurrentWidget(0);
		} else {
			if (getChildCount() - 1 != currentWidget) {
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
