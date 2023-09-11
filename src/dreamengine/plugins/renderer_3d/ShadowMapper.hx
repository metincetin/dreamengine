package dreamengine.plugins.renderer_3d;

import dreamengine.plugins.renderer_base.IRenderView;
import dreamengine.core.Engine;
import kha.graphics4.PipelineState;
import dreamengine.plugins.ecs.System.RenderContext;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.IRenderContextProvider;

class ShadowMapper implements IRenderContextProvider{

    var engine:Engine;
    var pipelineState:PipelineState;
	var renderContext:RenderContext;


    public function new(engine:Engine){
        this.engine = engine;
        this.renderContext = new RenderContext(engine, null, null);
    }

    public function getRenderContext(view:IRenderView):RenderContext {
        renderContext.setView(view);
        return renderContext;
    }

    public function getRenderingBackend():RenderingBackend {
        return G4;
    }
}