package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.slots.CanvasSlot;
import dreamengine.plugins.dreamui.slots.BaseSlot;

class CanvasContainer extends Element {
	public override function createSlotForChild():BaseSlot {
		return new CanvasSlot(this);
	}

	public override function getChildSlotType():Class<BaseSlot> {
		return CanvasSlot;
	}
}
