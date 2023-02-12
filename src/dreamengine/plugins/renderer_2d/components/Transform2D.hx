package dreamengine.plugins.renderer_2d.components;

import dreamengine.core.math.Vector2;
import dreamengine.plugins.ecs.Component;

class Transform2D extends Component {   
    public var position:Vector2 = Vector2.zero();
    public var angle: Float = 0;
    public var scale: Vector2 = Vector2.one();
    public var pivot: Vector2 = new Vector2(0.5, 0.5);

    public static function fromPosition(x:Float = 0, y:Float = 0){
        var t = new Transform2D();
        t.position = new Vector2(x, y);
        return t;
    }
    public static function prs(position:Vector2, rotation:Float, scale:Vector2){
        var t = new Transform2D();
        t.position = position;
        t.angle = rotation;
        t.scale = scale;
        return t;
    }
}