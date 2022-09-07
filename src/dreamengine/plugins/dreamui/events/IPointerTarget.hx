package dreamengine.plugins.dreamui.events;

interface IPointerTarget {
	public function canBeTargeted():Bool;
	public function onPointerEntered():Void;
	public function onPointerExited():Void;
}
