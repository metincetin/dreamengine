package dreamengine.core.math;

import dreamengine.core.math.Vector.Vector3;

class Quaternion {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public static function fromEuler(x:Float, y:Float, z:Float) {
		var roll:Float = Mathf.degToRad(x);
		var pitch:Float = Mathf.degToRad(y);
		var yaw:Float = Mathf.degToRad(z);

		var cy:Float = Math.cos(yaw * 0.5);
		var sy:Float = Math.sin(yaw * 0.5);
		var cp:Float = Math.cos(pitch * 0.5);
		var sp:Float = Math.sin(pitch * 0.5);
		var cr:Float = Math.cos(roll * 0.5);
		var sr:Float = Math.sin(roll * 0.5);

		var qw:Float = cy * cp * cr + sy * sp * sr;
		var qx:Float = cy * cp * sr - sy * sp * cr;
		var qy:Float = sy * cp * sr + cy * sp * cr;
		var qz:Float = sy * cp * cr - cy * sp * sr;

		return new Quaternion(qx, qy, qz, qw);
	}

	public function conjugated() {
		return new Quaternion(-x, -y, -z, -w);
	}

	public function toEuler() {
		var qx:Float = this.x;
		var qy:Float = this.y;
		var qz:Float = this.z;
		var qw:Float = this.w;

		var ysqr:Float = qy * qy;

		var t0:Float = -2.0 * (ysqr + qz * qz) + 1.0;
		var t1:Float = 2.0 * (qx * qy + qw * qz);
		var t2:Float = -2.0 * (qx * qz - qw * qy);
		var t3:Float = 2.0 * (qy * qz + qw * qx);
		var t4:Float = -2.0 * (qx * qx + ysqr) + 1.0;

		t2 = t2 > 1.0 ? 1.0 : t2;
		t2 = t2 < -1.0 ? -1.0 : t2;

		var roll:Float = Math.atan2(t3, t4);
		var pitch:Float = Math.asin(t2);
		var yaw:Float = Math.atan2(t1, t0);

		return new Vector3(Mathf.radToDeg(roll), Mathf.radToDeg(pitch), Mathf.radToDeg(yaw));
	}

	public function inverse() {
		var inv = new Quaternion();
		var cw = w;
		var cx = -x;
		var cy = -y;
		var cz = -z;
	}

	public function multiply(b:Quaternion) {
		this.w= this.w * b.w - this.x * b.x - this.y * b.y - this.z * b.z;
		this.x= this.w * b.x + this.x * b.w + this.y * b.z - this.z * b.y;
		this.y= this.w * b.y - this.x * b.z + this.y * b.w + this.z * b.x;
		this.z= this.w * b.z + this.x * b.y - this.y * b.x + this.z * b.w;
	}
	public function multiplied(b:Quaternion){
		var n = new Quaternion();
		n.x = x;
		n.y = y;
		n.z = z;
		n.w = w;
		n.multiply(b);
		return n;
	}
	public function multiplyV(euler:Vector3){
		var q = Quaternion.fromEuler(euler.x, euler.y, euler.z);
		multiply(q);
	}
	public function multipliedV(euler:Vector3){
		var q = copy();
		q.multiplyV(euler);
		return q;
	}

	function copy(){
		return new Quaternion(x, y, z, w);
	}

	public function magnitude():Float {
		return Math.sqrt(w * w + x * x + y * y + z * z);
	}

	public static function identity() {
		return new Quaternion(1, 0, 0, 0);
	}
}
