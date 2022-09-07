package dreamengine.core.math;

class Mathf {
	public static inline function degToRad(degrees:Float):Float {
		return (degrees * 0.017453);
	}

	public static inline function sign(value:Float) {
		return value >= 0 ? return 1 : -1;
	}
}
