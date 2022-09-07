package dreamengine.core.math;

import dreamengine.core.math.Vector.Vector3;

class Quaternion {
	var x:Float;
	var y:Float;
	var z:Float;
	var w:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public static function fromEuler(x:Float, y:Float, z:Float) {
		var cy = Math.cos(x * 0.5);
		var sy = Math.sin(x * 0.5);
		var cp = Math.cos(y * 0.5);
		var sp = Math.sin(y * 0.5);
		var cr = Math.cos(z * 0.5);
		var sr = Math.sin(z * 0.5);

		var q = new Quaternion();
		q.w = cr * cp * cy + sr * sp * sy;
		q.x = sr * cp * cy - cr * sp * sy;
		q.y = cr * sp * cy + sr * cp * sy;
		q.z = cr * cp * sy - sr * sp * cy;
		return q;
	}

	// https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
	public function toEuler() {
		var x:Float = 0;
		var y:Float = 0;
		var z:Float = 0;
		var sinrCosp = 2 * (w * x + y * z);
		var cosrCosp = 1 - 2 * (x * x + y * y);
		x = Math.atan2(sinrCosp, cosrCosp);
		// pitch (y-axis rotation)
		var sinp = 2 * (w * y - z * x);
		if (Math.abs(sinp) >= 1)
			y = (Math.PI / 2 * Mathf.sign(sinp)); // use 90 degrees if out of range
		else
			y = Math.asin(sinp);

		// yaw (z-axis rotation)
		var sinyCosp = 2 * (w * z + x * y);
		var cosyCosp = 1 - 2 * (y * y + z * z);
		z = Math.atan2(sinyCosp, cosyCosp);

		var ret = new Vector3(x, y, z);
	}

	public function inverse() {
		var inv = new Quaternion();
		var cw = w;
		var cx = -x;
		var cy = -y;
		var cz = -z;
	}

	public function multiply(b:Quaternion) {}

	public function magnitude():Float {
		return Math.sqrt(w * w + x * x + y * y + z * z);
	}

	public static function identity() {
		return new Quaternion(1, 0, 0, 0);
	}
}
