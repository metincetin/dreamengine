package dreamengine.core.math;

import dreamengine.core.math.Vector.Vector2;

class Rect{
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

	public static function zero() {
		return new Rect();
	}

	public function getMax() {
		var max = new Vector2();
		max.x = position.x + size.x;
		max.y = position.y + size.y;
		return max;
	}

	public function getMin() {
		var min = new Vector2();
		min.x = position.x - size.x;
		min.y = position.y - size.y;
		return min;
	}

	public function isPointInside(point:Vector2) {
		return point.x >= position.x && point.y >= position.y && point.x <= position.x + size.x && point.y <= position.y + size.y;
	}

	public function overlaps(rect:Rect) {
		return !(this.position.x + this.size.x < rect.position.x
			|| this.position.y + this.size.y < rect.position.y
			|| this.position.x > rect.position.x + rect.size.x
			|| this.position.y > rect.position.y + rect.size.y);
	}
}
