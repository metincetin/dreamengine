package dreamengine.plugins.renderer_3d.components;

import dreamengine.plugins.renderer_base.IRenderContextProvider;
import dreamengine.device.Screen;
import kha.math.FastMatrix2;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import dreamengine.plugins.renderer_base.ActiveCamera.ActiveView;
import dreamengine.plugins.ecs.Entity;
import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_base.IRenderView;
import kha.graphics5_.TextureFormat;
import kha.Framebuffer;
import kha.Image;
import kha.Color;

class DirectionalLight extends Light implements IRenderView{
	public var shadowMap:Image;
	public var viewMatrix:FastMatrix4;
	public var projectionMatrix:FastMatrix4;
	public var viewProjectionMatrix:FastMatrix4;

	public function new(color:Color = Color.White, intensity:Float = 1) {
		super(color, intensity);
	}
	override function onAdded(entity:Entity) {
		ActiveView.registerView(this);
		shadowMap = Image.createRenderTarget(2048, 2048, TextureFormat.DEPTH16);
		projectionMatrix = FastMatrix4.orthogonalProjection(-5, 5, -5, 5, 1, 10);
	}
	override function onRemoved(entity:Entity) {
		ActiveView.unregisterView(this);
	}

	public function getViewMatrix():FastMatrix4 {
		return viewMatrix;
	}

	public function getProjectionMatrix():FastMatrix4 {
		return projectionMatrix;
	}

	public function getViewProjectionMatrix():FastMatrix4 {
		return viewProjectionMatrix;
	}

	public function getRenderTarget():Image {
		return shadowMap;
	}

	public function shouldRenderToFramebuffer():Bool {
		return true;
	}

	public function shouldDrawToContext(contextProvider:IRenderContextProvider):Bool {
		return contextProvider is ShadowMapper;
	}
}
