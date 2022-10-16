package dreamengine.plugins.tweening;

class QuickTween {
	static var tweener:Tweener;

	@:internal
	public static function init(t:Tweener) {
		tweener = t;
	}

	public static function tween(getter:Void->Float, setter:Float->Void, target:Float, duration:Float) {
		var builder = TweenBuilder.Float();
		builder.setter(setter);
		builder.getter(getter);
	}

	static function check() {
		if (tweener == null)
			throw "Tweener is null. TweenPlugin is probably not loaded";
	}
}
