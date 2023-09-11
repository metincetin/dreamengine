package dreamengine.debugging;

import haxe.Json;
import kha.Scheduler;

typedef ProfilerSample = {
    key:String,
    startTime:Float,
    endTime:Float,
    lastDuration:Float
}

class Profiler{
    static var samples = new Array<ProfilerSample>();

    static function getSample(key:String){
        for (i in samples){
            if (i.key == key)
                return i;
        }

        return null;
    }

    public static function begin(key:String){
        var sample = getSample(key);
        if (sample == null){
            sample = {key:key, startTime: 0, endTime: 0, lastDuration: 0}; 
            samples.push(sample);
        }

        sample.startTime = Scheduler.realTime();
    }
    public static function end(key:String){
        var sample = getSample(key);
        if (sample != null){
            sample.endTime = Scheduler.realTime();
            sample.lastDuration = sample.endTime - sample.startTime;
        }
    }
    public static function getTime(key:String){
        var sample = getSample(key);
        if (sample == null) return -1.0;

        return sample.endTime - sample.startTime;
    }

    public static function getJSON(){
        return Json.stringify(samples);
    }
}