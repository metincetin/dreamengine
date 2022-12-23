package dreamengine.core.math;

class Mathf {
	public static inline function degToRad(degrees:Float):Float {
		return (degrees * 0.017453292519943295);
	}
	public static inline function radToDeg(radians:Float):Float{
		return (radians * 180 / Math.PI);
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
	public static inline function atan2(y:Float, x:Float){
		return Math.atan2(y, x);
	}

	public static function sind(deg:Float) {
		return sin(degToRad(deg));
	}
}
