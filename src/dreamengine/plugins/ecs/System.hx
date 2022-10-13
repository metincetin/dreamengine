package dreamengine.plugins.ecs;

import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.core.Engine;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import dreamengine.plugins.renderer_base.components.Material;
import kha.graphics4.PipelineState;
import kha.Framebuffer;
import kha.graphics2.Graphics;

class System {
	public function new() {}

	public function execute(ctx:SystemContext) {}

	public function onRegistered(engine:Engine) {}

	public function onUnregistered(engine:Engine) {}

	public function getTargetComponents():Array<Class<Component>> {
		return [];
	}
}

class RenderSystem {
	public function new() {}

	public function execute(ctx:RenderContext) {}

	public function getTargetComponents():Array<Class<Component>> {
		return [];
	}
}

class RenderContext extends SystemContext {
	var pipelineState:PipelineState;
	var frameBuffer:Framebuffer;
	var camera:Camera;

	public function new(components:Array<Component>, engine:Engine, framebuffer:Framebuffer, pipelineState:PipelineState, camera:Camera) {
		super(components, engine);
		this.frameBuffer = framebuffer;
		this.pipelineState = pipelineState;
		this.camera = camera;
	}

	public function getFramebuffer():Framebuffer {
		return frameBuffer;
	}

	public function getPipelineState():PipelineState {
		return pipelineState;
	}

	public function getCamera() {
		return camera;
	}
}

class SystemContext {
	var components = new Array<Component>();
	var engine:Engine;

	public function new(components:Array<Component>, engine:Engine) {
		this.components = components;
		this.engine = engine;
	}

	@:generic
	public function getComponent<T>(type:Class<T>):T {
		for (c in components) {
			if (Std.isOfType(c, type))
				return cast c;
		}
		return null;
	}

	public function getEngine() {
		return engine;
	}
}
