package dreamengine.plugins.tweening;

import dreamengine.plugins.tweening.Tween.BaseTween;

class Tweener {
	public function new() {}

	var tweens = new Array<BaseTween>();
	var pendingKill:Array<BaseTween> = new Array<BaseTween>();

	public function add(tween:BaseTween) {
		tweens.push(tween);
	}

	public function remove(tween:BaseTween) {
		tweens.remove(tween);
	}

	public function tick(delta:Float) {
		for (tween in tweens) {
			tween.update(delta);
			if (tween.isCompleted()) {
				pendingKill.push(tween);
			}
		}

		for (p in pendingKill) {
			tweens.remove(p);
		}

		while (pendingKill.length > 0) {
			pendingKill.pop();
		}
	}
}
