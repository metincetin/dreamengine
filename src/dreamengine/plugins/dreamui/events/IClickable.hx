package dreamengine.plugins.dreamui.events;

interface IClickable extends IPointerTarget {
	public function onPressed(data:PointerEventData):Void;
	public function onReleased(data:PointerEventData):Void;
}
