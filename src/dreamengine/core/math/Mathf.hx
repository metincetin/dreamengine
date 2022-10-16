package dreamengine.core.math;

class Mathf {
	public static inline function degToRad(degrees:Float):Float {
		return (degrees * 0.017453);
	}

	public static inline function sign(value:Float) {
		return value >= 0 ? return 1 : -1;
	}

	public static function clamp(value:Float, min:Float, max:Float) {
		return Math.max(Math.min(value, max), min);
	}

	public static inline function lerp(a:Float, b:Float, t:Float) {
		return a + (b - a) * t;
	}

	public static inline function sin(rad:Float) {
		return Math.sin(rad);
	}

	public static function sind(deg:Float) {
		return sin(degToRad(deg));
	}
}
