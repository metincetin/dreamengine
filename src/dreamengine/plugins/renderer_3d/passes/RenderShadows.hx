package dreamengine.plugins.renderer_3d.passes;

import dreamengine.plugins.renderer_3d.components.Light;
import kha.Image;
import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_base.components.Camera;
import kha.math.FastMatrix4;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import kha.Shaders;
import dreamengine.core.RenderPass;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import kha.math.FastVector4;
import kha.graphics4.VertexStructure;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import dreamengine.core.Renderable;
import dreamengine.plugins.renderer_base.Material;
import kha.graphics4.PipelineState;
import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class RenderShadows extends RenderPass {

	var lastStruct:VertexStructure;
	var structLength = 0;
	var pipelineState:PipelineState;

	var shadowMap:Image;

	public function new(){
		super();
		shadowMap = Image.createRenderTarget(2048, 2048, DEPTH16);
		ShaderGlobals.setTexture("_ShadowMap", shadowMap);
	}

	function createPipelineState() {
		var pipelineState = new PipelineState();
		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		structLength = Std.int(struct.byteSize() / 4);

		pipelineState.inputLayout = [struct];

		pipelineState.vertexShader = kha.Shaders.shadowmap_vert;
		pipelineState.fragmentShader = Shaders.shadowmap_frag;
		pipelineState.cullMode = Clockwise;

		pipelineState.depthWrite = true;
		pipelineState.depthMode = LessEqual;
		pipelineState.compile();

		lastStruct = struct;
		this.pipelineState = pipelineState;
	}

	function calculateTightLightFrustum(){
		
	}

	override function execute(renderer:Renderer) {
		createPipelineState();
		for (cam in renderer.cameras) {
			for (light in renderer.lights) {
                if (light.type != Directional) continue;

				var g4 = shadowMap.g4;
				g4.begin();
				g4.clear(Black, 1, 0);

				g4.setPipeline(pipelineState);

				for (rend in renderer.opaques) {
					var mesh = rend.mesh;

					var vertexBuffer = mesh.getVertexBuffer();
					var indexBuffer = mesh.getIndexBuffer();


					g4.setVertexBuffer(vertexBuffer);
					g4.setIndexBuffer(indexBuffer);

                    switch(light.type){
                        case Directional:
							var camView = cam.getViewMatrix();
							var camPos = new Vector3(camView._30, camView._31, camView._32);
							var camFw = new Vector3(camView._20, camView._21, camView._22);

							var camProj = cam.getProjectionMatrix();

							var camVP = cam.getViewProjectionMatrix();

							var view = FastMatrix4.lookAt(camPos, camPos + light.direction, Vector3.up());
							//var view = FastMatrix4.lookAt(Vector3.zero(), light.direction, Vector3.up());

							light.projection = FastMatrix4.orthogonalProjection(-35,35,-35,35, 0.1, 50);

							var viewProjection = light.projection.multmat(view);

                            var mvp = viewProjection.multmat(rend.modelMatrix);
                            g4.setMatrix(pipelineState.getConstantLocation("_LightSpaceMatrix"), mvp);
							light.viewProjection = viewProjection;

						case _:
                    }

					g4.setMatrix(pipelineState.getConstantLocation("Model"), rend.modelMatrix);

					g4.drawIndexedVertices();
				}
                g4.end();
				cam.getRenderTarget().g2.begin(false);
				cam.getRenderTarget().g2.drawRect(0,400,200,200);
				cam.getRenderTarget().g2.font = kha.Assets.fonts.OpenSans_Regular;
				cam.getRenderTarget().g2.drawScaledImage(shadowMap, 0,400,200,200);
				cam.getRenderTarget().g2.drawString("Shadowmap", 0,400);
				cam.getRenderTarget().g2.end();

				ShaderGlobals.setTexture("_ShadowMap", shadowMap);
			}
		}
	}
}
