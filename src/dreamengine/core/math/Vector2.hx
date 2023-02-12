package dreamengine.core.math;

abstract Vector2(Array<Float>) {
	public var x(get, set):Float;
	public var y(get, set):Float;

	public function new(x:Float = 0, y:Float = 0) {
		this = [x, y];
	}

	public function toString() {
		return '($x,$y)';
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

	@:op(A * B) @:commutative
	public function multiplied(rhs:Vector2) {
		return new Vector2(this[0] * rhs.x, this[1] * rhs.y);
	}

	@:op(A * B) @:commutative
	public function scaled(rhs:Float) {
		return new Vector2(this[0] * rhs, this[1] * rhs);
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
		if (length == 0) {
			x = 1;
			y = 0;
			return;
		}
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

	public inline function dot(b:Vector2):Float {
		return this[0] * b.x + this[1] * b.y;
	}

	@:op(A - B) @:commutative
	public function subtracted(v:Vector2) {
		var nv = copy();
		nv.x -= v.x;
		nv.y -= v.y;
		return nv;
	}
	

	public function copy() {
		return new Vector2(x, y);
	}

	@:op(A + B) @:commutative
	public function added(v:Vector2) {
		var nv = copy();
		nv.x += v.x;
		nv.y += v.y;
		return nv;
	}

	public function scale(scalar:Float) {
		this[0] *= scalar;
		this[1] *= scalar;
	}

	public function set(x:Float, y:Float) {
		this[0] = x;
		this[1] = y;
	}

	public function reflected(normal:Vector2) {
		var n = normal.normalized();
		var dot = dot(normal);
		n *= dot * 2;
		return this - n;
	}


	public function lerp(b:Vector2, t:Float) {
		var n = new Vector2();
		n.x = Mathf.lerp(this[0], b.x, t);
		n.y = Mathf.lerp(this[1], b.y, t);
		return n;
	}

	public function asVector3() {
		var n = new Vector3(x, y);
		return n;
	}
}
