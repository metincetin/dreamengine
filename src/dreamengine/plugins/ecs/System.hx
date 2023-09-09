package dreamengine.plugins.ecs;

import dreamengine.plugins.renderer_base.IRenderContextProvider;
import dreamengine.plugins.renderer_base.IRenderView;
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
	var targetRenderContextProviders:Array<Class<IRenderContextProvider>> = [];

	public function execute(ecsContext:ECSContext, renderContext:RenderContext) {}
}

class RenderContext {
	var pipelineState:PipelineState;
	var view:IRenderView;

	public function new(engine:Engine, pipelineState:PipelineState, view:IRenderView) {
		this.pipelineState = pipelineState;
		this.view = view;
	}

	public function getPipelineState():PipelineState {
		return pipelineState;
	}

	public function getRenderView() {
		return view;
	}

	public function getRenderTarget() {
		return view.getRenderTarget();
	}
}
