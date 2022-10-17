package dreamengine.plugins.tweening.tweens;

import dreamengine.core.math.Mathf;

class FloatTween extends Tween<Float> {
	override function getValueOfTime(t:Float):Float {
		return Mathf.lerp(startValue, targetValue, t);
	}
}
