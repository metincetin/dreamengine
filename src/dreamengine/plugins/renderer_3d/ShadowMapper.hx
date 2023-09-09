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

    public function new(engine:Engine){
        this.engine = engine;
        this.pipelineState = new PipelineState();
    }

    public function getRenderContext(view:IRenderView):RenderContext {
        return new RenderContext(this.engine, this.pipelineState, view);
    }

    public function getRenderingBackend():RenderingBackend {
        return G4;
    }
}