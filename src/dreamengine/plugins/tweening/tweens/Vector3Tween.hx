package dreamengine.plugins.tweening.tweens;

import dreamengine.core.math.Vector3;

class Vector3Tween extends Tween<Vector3> {
	override function applyValues(time:Float) {
		Vector3.lerp(startValue, targetValue, time);
	}
}
