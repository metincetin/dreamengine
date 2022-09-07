package dreamengine.plugins.dreamui.events;

interface IFocusable {
	public function canBeFocused():Bool;
	public function onFocused():Bool;
	public function onFocusLost():Bool;
	public function isFocused():Bool;
}
