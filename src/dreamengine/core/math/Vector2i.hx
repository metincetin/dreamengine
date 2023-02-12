package dreamengine.core.math;

abstract Vector2i(Array<Int>) {
	public var x(get, set):Int;
	public var y(get, set):Int;

	public function new(x:Int = 0, y:Int= 0) {
		this = [x, y];
	}

	public function toString() {
		return '($x,$y)';
	}

	function get_x() {
		return this[0];
	}

	function set_x(value:Int) {
		this[0] = value;
		return value;
	}

	function get_y() {
		return this[1];
	}
	
	function set_y(value:Int) {
		this[1] = value;
		return value;
	}

	@:op(A * B)
	public function multiplied(rhs:Vector2) {
		return new Vector2(this[0] * rhs.x, this[1] * rhs.y);
	}

	@:op(A * B)
	public function scaled(rhs:Int) {
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


	public function negated() {
		var n = copy();
		n.x = -n.x;
		n.y = -n.y;
		return n;
	}


	@:op(A - B)
	public function subtracted(b:Vector2) {
		var nx = this[0] - b.x;
		var ny = this[1] - b.y;
		return new Vector2(nx, ny);
	}

	public function copy() {
		return new Vector2(x, y);
	}

	@:op(A + B)
	public function added(v:Vector2) {
		var nv = copy();
		nv.x += v.x;
		nv.y += v.y;
		return nv;
	}

	public function scale(scalar:Int) {
		this[0] *= scalar;
		this[1] *= scalar;
	}

	public function set(x:Int, y:Int) {
		this[0] = x;
		this[1] = y;
	}

    @:to
	public function asVector3() {
		var n = new Vector3(x, y);
		return n;
	}
    @:to
    public function asVector2(){
        return new Vector2(x, y);
    }
}


