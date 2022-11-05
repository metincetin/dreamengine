package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.slots.*;
import dreamengine.plugins.dreamui.*;
class LaidBox extends Element{
    override function createSlotForChild(childIndex):BaseSlot {
        return new LaidBoxSlot(this, childIndex);
    }
    override function getChildSlotType():Class<BaseSlot> {
        return LaidBoxSlot;
    }
}