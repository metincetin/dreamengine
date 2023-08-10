package dreamengine.core.math;

abstract Vector3(Array<Float>) from Array<Float>{
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var z(get, set):Float;
	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {

		this = [x, y, z];
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

	public function distanceTo(to:Vector3){
		var dx = x - to.x;
		var dy = y - to.y;
		var dz = z - to.z;
		return Math.sqrt(dx*dx + dy*dy + dz*dz);
	}


	@:op(A + B) @:commutative
	public function added(b:Vector3){
		var nx = this[0] + b.x;
		var ny = this[1] + b.y;
		var nz = this[2] + b.z;
		return new Vector3(nx, ny, nz);
	}

	@:op(A - B) @:commutative
	public function subtracted(b:Vector3) {
		var nx = this[0] - b.x;
		var ny = this[1] - b.y;
		var nz = this[2] - b.z;
		return new Vector3(nx, ny, nz);
	}



	@:op(A * B) @:commutative
	public function miltiplied(v:Vector3){
		return new Vector3(this[0] * v.x, this[1] * v.y, this[2] * v.z);
	}

	public function multiply(v:Vector3) {
		this[0] *= v.x;
		this[1] *= v.y;
		this[2] *= v.y;
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
		this[0] *= scalar;
		this[1] *= scalar;
		this[2] *= scalar;
	}
	@:op(A*B) @:commutative
	public function scaled(scalar:Float){
		var n = copy();
		n.scale(scalar);
		return n;
	}

	public function lerp(b:Vector3, t:Float) {
		var n = new Vector3();
		n.x = Mathf.lerp(x, b.x, t);
		n.y = Mathf.lerp(y, b.y, t);
		n.z = Mathf.lerp(z, b.z, t);
		return n;
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

	public inline function dot(b:Vector3):Float {
		return this[0] * b.x + this[1] * b.y + this[2] * b.z;
	}

	public inline function cross( b:Vector3):Vector3 {
		var _x = y * b.z - z * b.y;
		var _y = z * b.x - x * b.z;
		var _z = x * b.y - y * b.x;
		return new Vector3(_x, _y, _z);
	}

	public function normalized() {
		var n = copy();
		n.normalize();
		return n;
	}

	public function rotate(q:Quaternion) {}

	public function reflected(normal:Vector3) {
		var n = normal.normalized();
		var dot = dot(normal);
		var n = normal * dot * 2;
		var r = this - n;
		x = r.x;
		y = r.y;
		z = r.z;
	}

	public function asVector2():Vector2 {
		return new Vector2(x, y);
	}

	@:from
	static function fromIntArray(array:Array<Int>){
		var n = new Vector3(cast array[0], cast array[1], cast array[2]);
		return n;
	}

}