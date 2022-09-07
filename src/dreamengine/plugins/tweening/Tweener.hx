package dreamengine.plugins.tweening;

import dreamengine.plugins.tweening.Tween.BaseTween;

class Tweener {
    public function new(){}
    
    var tweens = new Array<BaseTween>();

    public function add(tween:BaseTween){
        tweens.push(tween);
    }
    
    public function remove(tween:BaseTween){
        tweens.remove(tween);
    }
    
    public function tick(delta:Float){
        for(tween in tweens){
            tween.update(delta);
        }
    }
}