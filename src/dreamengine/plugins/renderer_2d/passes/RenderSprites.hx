package dreamengine.plugins.renderer_2d.passes;

import kha.SystemImpl;
import kha.Shaders;
import kha.graphics4.VertexStructure;
import kha.graphics5_.BlendingFactor;
import kha.graphics4.PipelineState;
import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class RenderSprites extends RenderPass {
    var pipeline:PipelineState;
	var projectionMatrixLocation:kha.graphics4.ConstantLocation;
	var textureLocation:kha.graphics4.TextureUnit;
	var mvpLocation:kha.graphics4.ConstantLocation;


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
        pipeline.vertexShader = Shaders.sprite_vert;
        pipeline.fragmentShader = Shaders.sprite_frag;

        vertexLayout.add("vertexPosition", Float3);
        vertexLayout.add("uv", Float2);
        vertexLayout.add("vertexColor", Float3);

        pipeline.inputLayout = [vertexLayout];

        pipeline.compile();


        mvpLocation = pipeline.getConstantLocation("MVP");
        textureLocation = pipeline.getTextureUnit("u_Texture");
    }

	override function execute(renderer:Renderer) {
		for (cam in renderer.cameras) {
            var g4 = cam.getRenderTarget().g4;
            g4.begin();
            g4.setPipeline(pipeline);

            var vp = cam.getViewProjectionMatrix();
            for(rend in renderer.transparents){


                var mvp = vp.multmat(rend.modelMatrix);
                g4.setMatrix(mvpLocation, mvp);

                var tex = rend.material.getTextureUniform("u_Texture");

                g4.setTexture(textureLocation, tex);
                //rend.material.applyUniforms(g4);

                g4.setIndexBuffer(rend.mesh.getIndexBuffer());
                g4.setVertexBuffer(rend.mesh.getVertexBuffer());
                g4.drawIndexedVertices();
            }

            g4.end();
        }
	}
}
