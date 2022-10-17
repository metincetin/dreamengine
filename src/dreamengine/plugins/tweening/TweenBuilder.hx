package dreamengine.plugins.tweening;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.tweening.tweens.Vector2Tween;
import dreamengine.plugins.tweening.Tween.BaseTween;
import dreamengine.plugins.tweening.tweens.FloatTween;

@:generic
class TweenBuilderInstance<T:Tween<V>, V> {
	var tween:T;

	public function new(tween:T) {
		this.tween = tween;
	}

	public function startValue(v:V) {
		tween.startValue = v;
		return this;
	}

	public function duration(v:Float) {
		tween.duration = v;
		return this;
	}

	public function targetValue(v:V) {
		tween.targetValue = v;
		return this;
	}

	public function onCompleted(f:Void->Void) {
		tween.onCompleted = f;
		return this;
	}

	public function onStarted(f:Void->Void) {
		tween.onStarted = f;
		return this;
	}

	public function setter(v:V->Void) {
		tween.valueSetter = v;
		return this;
	}

	public function getter(v:Void->V) {
		tween.valueGetter = v;
		return this;
	}

	public function ease(v:Float->Float) {
		if (ease == null)
			tween.ease = EasingFunctions.linear;
		else
			tween.ease = v;
		return this;
	}

	public function build() {
		return tween;
	}

	public function play() {
		TweenBuilder.getTweener().add(build());
	}
}

class TweenBuilder {
	static var tweener:Tweener;

	public static function init(t:Tweener) {
		tweener = t;
	}

	public static function getTweener() {
		return tweener;
	}

	public static function float() {
		return new TweenBuilderInstance<FloatTween, Float>(new FloatTween());
	}

	public static function vector2() {
		return new TweenBuilderInstance<Vector2Tween, Vector2>(new Vector2Tween());
	}
}
