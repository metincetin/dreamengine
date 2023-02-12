package dreamengine.plugins.tweening.tweens;

import dreamengine.core.math.Vector2;

class Vector2Tween extends Tween<Vector2> {
	override function getValueOfTime(t:Float):Vector2 {
		return Vector2.lerp(startValue, targetValue, t);
	}
}
