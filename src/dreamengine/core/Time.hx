package dreamengine.core;

import kha.Scheduler;

class Time{
    static var current:Float = 0.0;
    static var deltaTime:Float = 0.0;
    static var frameDelta:Float;

    public static function getFrameDelta():Float{
        return frameDelta;
    }

    public static function getDeltaTime():Float{
        return deltaTime;
    }
    public static function getTime():Float{
        return current;
    }

    public static function update(){
        deltaTime = Scheduler.time() - current;
        current = Scheduler.time();
    }

    @:allow(dreamengine.core.Engine)
    private static function setRendererDelta(tdiff:Float) {
        frameDelta = tdiff;
    }
}