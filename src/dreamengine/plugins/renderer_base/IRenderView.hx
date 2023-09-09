package dreamengine.plugins.renderer_base;

import kha.Image;
import kha.math.FastMatrix4;

interface IRenderView {
	public function getViewMatrix():FastMatrix4;

	public function getProjectionMatrix():FastMatrix4;

	public function getViewProjectionMatrix():FastMatrix4;
	public function shouldRenderToFramebuffer():Bool;

	public function getRenderTarget():Image;

	public function getTargetRenderContextProviders():Array<Class<IRenderContextProvider>>;
}
