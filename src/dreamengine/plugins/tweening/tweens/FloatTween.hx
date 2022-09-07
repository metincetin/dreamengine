package dreamengine.plugins.tweening.tweens;


class FloatTween extends Tween<Float>{
    public override function getValue():Float{
        var rate = getRate();

        // todo apply easing function here
        var value = targetValue * rate;

        return value;
    }
}