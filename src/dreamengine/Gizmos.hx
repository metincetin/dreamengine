package dreamengine;

import kha.math.FastMatrix3;
import dreamengine.device.Screen;
import dreamengine.plugins.renderer_base.ActiveCamera;
import dreamengine.core.math.Vector2;
import kha.Framebuffer;

class Gizmos{
	public static var transformation:FastMatrix3;


    static var commands = new Array<Framebuffer->Void>();
    
    public static function drawRay(from:Vector2, direction:Vector2){
        var to = from.copy();
        to.x += direction.x;
        to.y += direction.y;

        drawLine(from, to);
    }

    public static function drawLine(from:Vector2, to:Vector2){
        commands.push(function(fb){
            fb.g2.begin(false);
            fb.g2.color = kha.Color.Red;
            var tr = ActiveCamera.getTransform(0);
            var p = tr.getPosition();
            var res = Screen.getResolution();
            p.x += res.x * 0.5;
            p.y += res.y * 0.5;
            fb.g2.drawLine(p.x + from.x, p.y + from.y, p.x + to.x, p.y + to.y);
            fb.g2.color = White;
            fb.g2.end();
        });
    }

    public static function render(framebuffer:Framebuffer){
        for(command in commands){
            command(framebuffer);
        }
        commands = [];
        transformation = FastMatrix3.identity();
        //framebuffer.g2.transformation = transformation;
    }


}