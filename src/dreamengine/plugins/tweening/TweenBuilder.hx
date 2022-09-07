package dreamengine.plugins.tweening;

class TweenBuilder<T>{
    var tween:Tween<T>;

    public function new(){
        tween = new Tween<T>();
    }

    public function startValue(v:T){
        tween.value = v;
        return this;
    }
    public function targetValue(v:T){
        tween.targetValue = v;
        return this;
    }
    public function ease(){
        return this;
    }

    public function complete(){
        return tween;
    }
}