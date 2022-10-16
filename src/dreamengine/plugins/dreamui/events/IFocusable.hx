package dreamengine.plugins.dreamui.events;

interface IFocusable {
	public function canBeFocused():Bool;
	public function onFocused():Void;
	public function onFocusLost():Void;
	public function isFocused():Bool;
}
