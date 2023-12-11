package dreamengine.plugins.dreamui.elements;
import dreamengine.core.math.Vector2;
import kha.graphics2.Graphics;
import dreamengine.plugins.dreamui.*;
import dreamengine.plugins.dreamui.events.*;

class ListViewItemWrapper extends Element implements IPointerTarget implements IClickable{
    public var pressed:Void->Void;
    
    public function new (element:Element){
        super();
        addChild(element);
    }

    override function getPreferredSize():Vector2 {
        return getElement().getPreferredSize();
    }
    public function getElement(){
        return getChild(0);
    }

    public function canBeTargeted():Bool {
        return true;
    }

    public function onPointerEntered() {
        if (getChild(0) is IPointerTarget){
            var c:IClickable = cast getChild(0);
            c.onPointerEntered();
        }
    }

    public function onPointerExited() {
        if (getChild(0) is IPointerTarget){
            var c:IClickable = cast getChild(0);
            c.onPointerExited();
        }
    }

    public function onPressed(data:PointerEventData) {
        if (pressed != null) pressed();
        if (getChild(0) is IClickable){
            var c:IClickable = cast getChild(0);
            c.onPressed(data);
        }
    }

    public function onReleased(data:PointerEventData) {
		parsedStyle.setState("hovered");
        if (getChild(0) is IClickable){
            var c:IClickable = cast getChild(0);
            c.onReleased(data);
        }
    }

    override function layout() {
        var e = getElement();
        e.rect.setPosition(rect.getPosition());
        e.rect.setSize(rect.getSize());
    }
}
    