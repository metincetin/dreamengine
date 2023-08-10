package dreamengine.plugins.renderer_2d.components;

import dreamengine.core.math.Vector2;
import dreamengine.plugins.ecs.Component;

class Line2D extends Component {
	public var points:Array<Vector2> = [];

    public static function withPoints(points:Array<Vector2>){
        var x = new Line2D();
        x.points = points;
        return x;
    }

	public function addLine(position:Vector2) {
		points.push(position);
	}

	public function addLineAt(index:Int, position:Vector2) {
		points.insert(index, position);
	}

	public function removeLineAt(index:Int) {
		points.splice(index, 1);
	}

	public function pop() {
		points.pop();
	}

	public function clear() {
		points.resize(0);
	}

	public function length() {
		return points.length;
	}

	public function getPosition(i:Int) {
		return points[i];
	}
}
