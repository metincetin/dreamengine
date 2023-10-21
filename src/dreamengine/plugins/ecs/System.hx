package dreamengine.plugins.ecs;

import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.core.Engine;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import kha.graphics4.PipelineState;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import dreamengine.plugins.ecs.ECSContext;

class System {
	public function new() {}

	public function execute(ctx:ECSContext) {}

	public function onRegistered(engine:Engine) {}

	public function onUnregistered(engine:Engine) {}
}