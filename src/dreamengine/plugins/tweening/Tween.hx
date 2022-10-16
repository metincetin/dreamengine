package dreamengine.plugins.tweening;

class Tween<T> extends BaseTween {
	public var value:T;
	public var startValue:T;
	public var targetValue:T;

	public function new() {}

	public var valueGetter:Void->T;
	public var valueSetter:T->Void;

	extern public function getValueOfTime(t:Float):T;

	override function applyValues(time:Float) {
		valueSetter(getValueOfTime(time));
	}
}

class BaseTween {
	var time:Float = 0;

	public var duration:Float = 1.0;

	function getRate():Float {
		return time / duration;
	}

	function getTime():Float {
		return time;
	}

	public function update(delta:Float) {
		time += delta / duration;
		if (time > 1) {
			time = 1;
		}

		applyValues(time);
	}

	function applyValues(time:Float) {}

	public function isCompleted() {
		return time >= duration;
	}
}
