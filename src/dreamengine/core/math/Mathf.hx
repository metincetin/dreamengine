package dreamengine.core.math;

import kha.Color;

class Mathf {
	public static inline function degToRad(degrees:Float):Float {
		return (degrees * 0.017453292519943295);
	}

	public static inline function radToDeg(radians:Float):Float {
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

	public static inline function atan2(y:Float, x:Float) {
		return Math.atan2(y, x);
	}

	public static function sind(deg:Float) {
		return sin(degToRad(deg));
	}

	public static function lerpColor(a:Color, b:Color, t:Float) {
		var c = Color.White;

		c.R = Mathf.lerp(a.R, b.R, t);
		c.G = Mathf.lerp(a.G, b.G, t);
		c.B = Mathf.lerp(a.B, b.B, t);
		c.A = Mathf.lerp(a.A, b.A, t);
		return c;
	}
}
