package dreamengine.core.math;

@:struct
@:structInit
class Vector3 {
	public var x:Float;
	public var y:Float;
	public var z:Float;

	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function toString() {
		return '($x,$y,$z)';
	}

	// returns a 0,0 vector
	public static function zero():Vector3 {
		return new Vector3();
	}

	// returns a 1,1 vector
	public static function one():Vector3 {
		return new Vector3(1, 1, 1);
	}

	// returns 0.5, 0.5 vector
	public static function half():Vector3 {
		return new Vector3(0.5, 0.5, 0.5);
	}

	// returns the length of the vector
	public function getLength():Float {
		return Math.sqrt((x * x) + (y * y) + (z * z));
	}

	// normalizes this vector to unit length
	public function normalize() {
		var length = getLength();
		x /= length;
		y /= length;
		z /= length;
	}

	public static function subtract(a:Vector3, b:Vector3) {
		var nx = a.x - b.x;
		var ny = a.y - b.y;
		var nz = a.z - b.z;
		return new Vector3(nx, ny, nz);
	}

	public static function multiply(a:Vector3, b:Float) {
		return new Vector3(a.x * b, a.y * b, a.z * b);
	}

	public static function multiplyV(a:Vector3, b:Vector3) {
		return new Vector3(a.x * b.x, a.y * b.y, a.z * b.z);
	}

	public function multiplied(v:Vector3) {
		this.x *= v.x;
		this.y *= v.y;
		this.z *= v.y;
	}

	public function copy() {
		return new Vector3(x, y, z);
	}

	public function add(v:Vector3) {
		x += v.x;
		y += v.y;
		z += v.z;
	}

	public function scale(scalar:Float) {
		this.x *= scalar;
		this.y *= scalar;
		this.z *= scalar;
	}

	public static function lerp(a:Vector3, b:Vector3, t:Float) {
		var n = new Vector3();
		n.x = Mathf.lerp(a.x, b.x, t);
		n.y = Mathf.lerp(a.y, b.y, t);
		n.z = Mathf.lerp(a.z, b.z, t);
		return n;
	}

	public static function scaled(vector:Vector3, scalar:Float) {
		var n = vector.copy();
		n.scale(scalar);
		return n;
	}

	public static function reflected(vector:Vector3, normal:Vector3) {
		normal.normalize();
		var dot = dot(vector, normal);
		var n = multiply(normal, dot * 2);
		return subtract(vector, n);
	}

	public static function forward() {
		return new Vector3(0, 0, 1);
	}

	public static function up() {
		return new Vector3(0, 1, 0);
	}

	public static function right() {
		return new Vector3(1, 0, 0);
	}

	public static function left() {
		return new Vector3(-1, 0, 0);
	}

	public static function down() {
		return new Vector3(0, -1, 0);
	}

	public static function back() {
		return new Vector3(0, 0, -1);
	}

	public static inline function dot(a:Vector3, b:Vector3):Float {
		return a.x * b.x + a.y * b.y + a.z * b.z;
	}

	public static inline function cross(a:Vector3, b:Vector3):Vector3 {
		var _x = a.y * b.z - a.z * b.y;
		var _y = a.z * b.x - a.x * b.z;
		var _z = a.x * b.y - a.y * b.x;
		return new Vector3(_x, _y, _z);
	}

	public function normalized() {
		var n = copy();
		n.normalize();
		return n;
	}

	public function rotate(q:Quaternion) {}

	public function reflect(normal:Vector3) {
		var n = normal.normalized();
		var dot = dot(this, normal);
		var n = multiply(normal, dot * 2);
		var r = subtract(this, n);
		x = r.x;
		y = r.y;
		z = r.z;
	}

	public function asVector2():Vector2 {
		return new Vector2(x, y);
	}
}

class Vector2 {
	public var x:Float;
	public var y:Float;

	public function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}

	public function toString() {
		return '($x,$y)';
	}

	// returns a 0,0 vector
	public static function zero():Vector2 {
		return new Vector2();
	}

	// returns a 1,1 vector
	public static function one():Vector2 {
		return new Vector2(1, 1);
	}

	// returns 0.5, 0.5 vector
	public static function half():Vector2 {
		return new Vector2(0.5, 0.5);
	}

	// returns the length of the vector
	public function getLength():Float {
		return Math.sqrt((x * x) + (y * y));
	}

	// normalizes this vector to unit length
	public function normalize() {
		var length = getLength();
		x /= length;
		y /= length;
	}

	public function negated() {
		var n = copy();
		n.x = -n.x;
		n.y = -n.y;
		return n;
	}

	public function normalized() {
		var n = copy();
		n.normalize();
		return n;
	}

	public static inline function dot(a:Vector2, b:Vector2):Float {
		return a.x * b.x + a.y * b.y;
	}

	public static function subtract(a:Vector2, b:Vector2) {
		var nx = a.x - b.x;
		var ny = a.y - b.y;
		return new Vector2(nx, ny);
	}

	public static function multiply(a:Vector2, b:Float) {
		return new Vector2(a.x * b, a.y * b);
	}

	public static function multiplyV(a:Vector2, b:Vector2) {
		return new Vector2(a.x * b.x, a.y * b.y);
	}

	public static function reflected(vector:Vector2, normal:Vector2) {
		var n = normal.normalized();
		var dot = dot(vector, normal);
		var n = multiply(normal, dot * 2);
		return subtract(vector, n);
	}

	public function copy() {
		return new Vector2(x, y);
	}

	public function add(v:Vector2) {
		x += v.x;
		y += v.y;
	}

	public function scale(scalar:Float) {
		this.x *= scalar;
		this.y *= scalar;
	}

	public function scaled(scalar:Float) {
		var r = copy();
		r.scale(scalar);
		return r;
	}

	public function set(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function reflect(normal:Vector2) {
		var n = normal.normalized();
		var dot = dot(this, normal);
		var n = multiply(normal, dot * 2);
		return subtract(this, n);
	}

	public static function lerp(a:Vector2, b:Vector2, t:Float) {
		var n = new Vector2();
		n.x = Mathf.lerp(a.x, b.x, t);
		n.y = Mathf.lerp(a.y, b.y, t);
		return n;
	}

	public function asVector3() {
		var n = new Vector3(x, y);
		return n;
	}
}

@:struct
class Vector2i {
	public var x:Int;
	public var y:Int;

	public function new(x:Int = 0, y:Int = 0) {
		this.x = x;
		this.y = y;
	}

	public static function zero():Vector2i {
		return new Vector2i();
	}

	public function toString() {
		return '($x,$y)';
	}

	public inline function asVector2() {
		return new Vector2(cast x, cast y);
	}

	public function copy() {
		return new Vector2(x, y);
	}
}
