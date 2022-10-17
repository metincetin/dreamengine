package dreamengine.plugins.tweening;

import dreamengine.core.Time;
import dreamengine.plugins.ecs.ECS;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class TweenPlugin implements IPlugin {
	var tweener:Tweener;
	var engine:Engine;

	public function new() {}

	function getTweener() {
		return tweener;
	}

	public function initialize(engine:Engine) {
		this.engine = engine;
		tweener = new Tweener();
		QuickTween.init(getTweener());
		TweenBuilder.init(getTweener());
		engine.registerLoopEvent(onTick);
	}

	public function finalize() {
		engine.unregisterLoopEvent(onTick);
	}

	function onTick() {
		tweener.tick(Time.getDeltaTime());
	}

	public function getName():String {
		return "tween";
	}

	public function getDependentPlugins():Array<Class<IPlugin>> {
		return [];
	}

	public function handleDependency(ofType:Class<IPlugin>) {
		return null;
	}
}
