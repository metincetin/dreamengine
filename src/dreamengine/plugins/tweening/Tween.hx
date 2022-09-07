package dreamengine.plugins.tweening;

class Tween<T> extends BaseTween{
    
    public var value:T;
    public var targetValue:T;

    
    public function new(){

    }

    public function getValue():T{
        throw "Get Value not implemented";
    }

}

class BaseTween{
    var time:Float=0;
    public var duration: Float = 1.0;
    function getRate():Float{
        return time / duration;
    }
    function getTime():Float{
        return time;
    }
    public function update(delta:Float){
        time += delta / duration;
        if (time > 1)
        {
            time = 1;
        }

        applyValues(time);
    }

    function applyValues(time:Float){}
}