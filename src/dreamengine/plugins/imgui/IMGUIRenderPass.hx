package dreamengine.plugins.imgui;

import kha.Shaders;
import kha.graphics5_.*;
import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class IMGUIRenderPass extends RenderPass{
    @:allow(dreamengine.plugins.imgui.IMGUIPlugin)
    @:allow(dreamengine.plugins.imgui.RenderStack)
    static var waitingRenderer = false;
	var pipeline:PipelineState;


    public function new(){
        super();


        pipeline = new PipelineState();
        pipeline.depthWrite = false;
        pipeline.depthMode = Always;

		pipeline.blendSource = BlendingFactor.BlendOne;
		pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
		pipeline.alphaBlendSource = BlendingFactor.BlendOne;
		pipeline.alphaBlendDestination = BlendingFactor.InverseSourceAlpha;

        pipeline.cullMode = None;

        var vertexLayout = new VertexStructure();
        pipeline.vertexShader = Shaders.painter_image_vert;
        pipeline.fragmentShader = Shaders.painter_image_frag;

        vertexLayout.add("vertexPosition", Float3);
        vertexLayout.add("vertexUV", Float2);
        vertexLayout.add("vertexColor", Float3);

        pipeline.inputLayout = [vertexLayout];

        pipeline.compile();
    }

    override function execute(renderer:Renderer) {
        waitingRenderer = false;
        for (c in renderer.cameras){
            var g2 = c.getRenderTarget().g2;

            g2.begin(false);

            g2.pipeline = pipeline;
            c.getRenderTarget().g4.setPipeline(pipeline);

            g2.color = IMGUI.color;
            g2.fontSize = IMGUI.fontSize;

            for(r in RenderStack.renderers){
                r.render(g2);
            }

            g2.end();
        }

    }
}