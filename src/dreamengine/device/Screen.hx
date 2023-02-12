package dreamengine.device;
import kha.*;
import dreamengine.core.math.Vector2i;

class Screen{
    public static function getResolution(){
        var win = getWindow();
        return new Vector2i(win.width, win.height);
    }
    public static function setResolution(width:Int, height:Int){
        var win = getWindow();
        win.resize(width, height);
    }

    static function getWindow(index = 0):kha.Window{
        return kha.Window.get(index);
    }
    public static function setWindowFeatures(windowFeatures:Int){
        getWindow().changeWindowFeatures(windowFeatures);
    }
    public static function getWindowMode(windowFeatures:Int){
        return getWindow().mode;
    }
    public static function setWindowMode(mode:WindowMode){
        getWindow().mode = mode;
    }

}