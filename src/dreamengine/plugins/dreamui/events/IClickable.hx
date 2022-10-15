package dreamengine.plugins.dreamui.events;

interface IClickable extends IPointerTarget {
	public function onPressed():Void;
	public function onReleased():Void;
}
