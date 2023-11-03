package dreamengine.core.math;

import kha.math.FastMatrix4;
import dreamengine.core.math.Vector3;

abstract Quaternion(Array<Float>) from Array<Float> {
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var z(get, set):Float;
	public var w(get, set):Float;

	public function new(x:Float = 1, y:Float = 0, z:Float = 0, w:Float = 0) {
		this = [x, y, z, w];
	}

	function get_x() {
		return this[0];
	}

	function set_x(value:Float) {
		this[0] = value;
		return value;
	}

	function get_y() {
		return this[1];
	}

	function set_y(value:Float) {
		this[1] = value;
		return value;
	}
	
	function get_z(){ 
		return this[2];
	}

	function set_z(value:Float) {
		this[2] = value;
		return value;
	}

	function get_w(){ 
		return this[3];
	}

	function set_w(value:Float) {
		this[3] = value;
		return value;
	}

	public static function fromAxisAngle(axis:Vector3, degrees:Float) {
		var rad = Mathf.degToRad(degrees);

		var q = new Quaternion();
		q.w = Math.cos(rad * 0.5);
		q.x = q.y = q.z = Math.sin(rad * 0.5);
		q.x *= axis.x;
		q.y *= axis.y;
		q.z *= axis.z;

		return q;
	}

	public static function fromEuler(euler:Vector3) {
		var a = fromAxisAngle(Vector3.up(), euler.y);
		var b = fromAxisAngle(Vector3.right(), euler.x);
		var c = fromAxisAngle(Vector3.forward(), euler.z);

		return c.rotated(b.rotated(a));
	}

	public function conjugated() {
		return new Quaternion(-x, -y, -z, -w);
	}

	public function toMatrix() {
		var s:Float = 2.0;

		var xs:Float = x * s;
		var ys:Float = y * s;
		var zs:Float = z * s;
		var wx:Float = w * xs;
		var wy:Float = w * ys;
		var wz:Float = w * zs;
		var xx:Float = x * xs;
		var xy:Float = x * ys;
		var xz:Float = x * zs;
		var yy:Float = y * ys;
		var yz:Float = y * zs;
		var zz:Float = z * zs;

		return new FastMatrix4(1 - (yy + zz), xy - wz, xz + wy, 0, xy + wz, 1 - (xx + zz), yz - wx, 0, xz - wy, yz + wx, 1 - (xx + yy), 0, 0, 0, 0, 1);
	}

	public function toEuler() {
		var qx:Float = this[0];
		var qy:Float = this[1];
		var qz:Float = this[2];
		var qw:Float = this[3];

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
		this[3] = this[3] * b.w - this[0] * b.x - this[1] * b.y - this[2] * b.z;
		this[0] = this[3] * b.x + this[0] * b.w + this[1] * b.z - this[2] * b.y;
		this[1] = this[3] * b.y - this[0] * b.z + this[1] * b.w + this[2] * b.x;
		this[2] = this[3] * b.z + this[0] * b.y - this[1] * b.x + this[2] * b.w;
	}

	public function normalized() {
		var v = copy();
		v.normalize();
		return v;
	}

	@:op(A * B)
	public function multiplied(b:Quaternion) {
		var n = new Quaternion();
		n.x = x;
		n.y = y;
		n.z = z;
		n.w = w;
		n.multiply(b);
		return n;
	}

	public function multiplyV(euler:Vector3) {
		var q = Quaternion.fromEuler(euler);
		multiply(q);
	}

	public function multipliedV(euler:Vector3) {
		var q = copy();
		q.multiplyV(euler);
		return q;
	}

	function copy() {
		return new Quaternion(x, y, z, w);
	}

	public function magnitude():Float {
		return Math.sqrt(w * w + x * x + y * y + z * z);
	}

	public static function identity() {
		return new Quaternion(1, 0, 0, 0);
	}

	public function rotated(by:Quaternion) {
		var r = copy();

		var ret = new Quaternion();
		ret.w = w * by.w - x * by.x - y * by.y - z * by.z;
		ret.x = w * by.x + x * by.w + y * by.z - z * by.y;
		ret.y = w * by.y + y * by.w + z * by.x - x * by.z;
		ret.z = w * by.z + z * by.w + x * by.y - y * by.x;
		ret.normalize();
		return ret;
	}

	public function getLength() {
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}

	function normalize() {
		var length = getLength();
		var m = 1 / length;
		x *= m;
		y *= m;
		z *= m;
		w *= m;
	}
}
