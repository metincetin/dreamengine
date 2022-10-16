package dreamengine.plugins.tweening;

import test_3d.Test3DGamePlugin;
import haxe.Constraints.Constructible;
import dreamengine.plugins.tweening.tweens.FloatTween;

@:generic
class TweenBuilderInstance<T, V> {
	var tween:Tween<T>;

	public function new() {
		tween = new Tween<T>();
	}

	public function startValue(v:T) {
		tween.value = v;
		return this;
	}

	public function targetValue(v:T) {
		tween.targetValue = v;
		return this;
	}

	public function setter(v:T->Void) {
		tween.valueSetter = v;
	}

	public function getter(v:Void->T) {
		tween.valueGetter = v;
	}

	public function ease() {
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

	public static function Float() {
		return new TweenBuilderInstance<Float,>();
		}}
