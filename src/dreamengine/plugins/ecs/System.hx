package dreamengine.plugins.ecs;

import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.core.Engine;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import dreamengine.plugins.renderer_base.components.Material;
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

class RenderSystem {
	public function new() {}

	public function execute(ecsContext:ECSContext, renderContext:RenderContext) {}
}

class RenderContext {
	var pipelineState:PipelineState;
	var camera:Camera;

	public function new(engine:Engine, pipelineState:PipelineState, camera:Camera) {
		this.pipelineState = pipelineState;
		this.camera = camera;
	}

	public function getPipelineState():PipelineState {
		return pipelineState;
	}

	public function getCamera() {
		return camera;
	}

	public function getRenderTarget() {
		return camera.renderTexture;
	}
}
