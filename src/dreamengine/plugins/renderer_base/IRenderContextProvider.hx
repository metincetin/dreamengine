package dreamengine.plugins.renderer_base;

import kha.Image;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.Framebuffer;
import dreamengine.plugins.renderer_base.*;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.ecs.Component;

enum RenderingBackend {
	G1;
	G2;
	G4;
}

interface IRenderContextProvider {
	public function getRenderContext(view:IRenderView):RenderContext;
	public function getRenderingBackend():RenderingBackend;
}
