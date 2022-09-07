package dreamengine.core;

import kha.Scheduler;

class Time{
    static var current:Float = 0.0;
    static var deltaTime:Float = 0.0;

    public static function getDeltaTime():Float{
        return deltaTime;
    }
    public static function getCurrentTime():Float{
        return current;
    }

    public static function update(){
        deltaTime = Scheduler.time() - current;
        current = Scheduler.time();
    }
}