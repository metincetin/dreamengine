package dreamengine.plugins.tweening;

class QuickTween {
	static var tweener:Tweener;

	@:internal
	public static function init(t:Tweener) {
		tweener = t;
	}

	public static function tween(getter:Void->Float, setter:Float->Void, from:Float, target:Float, duration:Float, ease:Float->Float,
			onCompleted:Void->Void = null) {
		var builder = TweenBuilder.float();
		builder.setter(setter);
		builder.getter(getter);
		builder.ease(ease);
		builder.onCompleted(onCompleted);
		builder.startValue(from);
		builder.targetValue(target);
		builder.play();
	}

	static function check() {
		if (tweener == null)
			throw "Tweener is null. TweenPlugin is probably not loaded";
	}
}
