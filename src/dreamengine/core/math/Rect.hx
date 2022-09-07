package dreamengine.core.math;

import dreamengine.core.math.Vector.Vector2;

class Rect {
	public var position:Vector2;
	public var size:Vector2;

	public function new() {
		position = new Vector2();
		size = new Vector2();
	}

	public static function create(x:Float, y:Float, width:Float, height:Float):Rect {
		var r = new Rect();
		r.position.x = x;
		r.position.y = y;
		r.size.x = width;
		r.size.y = height;
		return r;
	}

	public static function fromVectors(position:Vector2, size:Vector2):Rect {
		var r = new Rect();
		r.position = position;
		r.size = size;
		return r;
	}
}
