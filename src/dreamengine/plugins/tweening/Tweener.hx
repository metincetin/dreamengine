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
			if (tween.getTime() == 0 && tween.onStarted != null) {
				tween.onStarted();
			}
			tween.update(delta);
			if (tween.isCompleted()) {
				if (tween.onCompleted != null)
					tween.onCompleted();
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
