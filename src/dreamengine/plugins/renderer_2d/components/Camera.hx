package dreamengine.plugins.renderer_2d.components;

import dreamengine.core.math.Vector.Vector2;
import dreamengine.device.Screen;
import kha.math.FastMatrix2;
import kha.math.FastMatrix4;
import kha.math.Matrix3;
import dreamengine.core.Time;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
import dreamengine.plugins.ecs.Component;

class Camera extends Component{
    var zoom:Vector2 = Vector2.one();
    var offset:Vector2 = Vector2.zero();
    var angle:Float;
    var pivot: Vector2;

    public function new(pivot: Vector2){
        super();
        this.pivot = pivot;
    }
    public function getZoom(){
        return zoom;
    }
    public function setZoom(value:Vector2){
        zoom = value;
    }
    public function getOffset(){
        return offset;
    }
    public function setOffset(value:Vector2){
        this.offset = value;
    }
    public function getAngle(){
        return angle;
    }
    public function setAngle(value:Float){
        angle = value;
    }

    inline function getTotalOffset(){
        var res = Screen.getResolution();
        var pivotOffset = Vector2.multiplyV(res.asVector2(), pivot);
        return new Vector2(offset.x + pivotOffset.x, offset.y + pivotOffset.y);
    }

	public function getTransformation():FastMatrix3 {
        return FastMatrix3.identity();
	}

	public function revert(g:Graphics) {
        //g.popTransformation();
        //g.pushScale(-zoom, -zoom);
        //g.scale(1.005,0.005);
        g.popTransformation();
        g.popTransformation();
        g.popTransformation();
    }

	public function apply(g:Graphics) {

        g.pushScale(zoom.x, zoom.y);
        g.pushRotation(angle,0,0);
        var off = getTotalOffset();
        g.pushTranslation(off.x, off.y);
    
    }
}