package dreamengine.plugins.renderer_3d.passes;

import dreamengine.core.math.Vector3;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import dreamengine.plugins.renderer_base.Mesh;
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

class RenderOpaques extends RenderPass {

	var lastMaterial:Material = null;
	var lastStruct:VertexStructure;
	var lastMesh:Mesh;
	var structLength = 0;
	var pipelineState:PipelineState;

	var cameraPositionLocation:ConstantLocation;

	function createPipelineState(material:Material) {
		var pipelineState = new PipelineState();
		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		structLength = Std.int(struct.byteSize() / 4);

		pipelineState.inputLayout = [struct];

		if (material == null) {
			material = Material.getDefault();
		}

		pipelineState.vertexShader = material.getVertexShader();
		pipelineState.fragmentShader = material.getFragmentShader();
		pipelineState.cullMode = material.cullMode;

		lastStruct = struct;
		pipelineState.depthWrite = material.depthWrite;
		pipelineState.depthMode = material.depthMode;
		pipelineState.compile();

		this.pipelineState = pipelineState;

		cameraPositionLocation = pipelineState.getConstantLocation("_CameraPosition");
	}


	function applyEnvironment(graphics:Graphics){
		var settings = EnvironmentSettings.active;
		if (settings == null) return;

		switch (settings.ambientLightType){
			case Color:
				var col = settings.ambientLightColor;
				var int = settings.ambientLightIntensity;
				col.R *= int;
				col.G *= int;
				col.B *= int;
				col.A *= int;

				graphics.setVector4(pipelineState.getConstantLocation("_AmbientColor"), new FastVector4(col.R, col.G, col.B, col.A));
			case Sky:
		}

		if (settings.distanceFog.enabled){
			graphics.setBool(pipelineState.getConstantLocation("_DistanceFog"), true);
			graphics.setFloat(pipelineState.getConstantLocation("_DistanceFogDensity"), settings.distanceFog.density);
			graphics.setFloat4(pipelineState.getConstantLocation("_DistanceFogColor"), settings.distanceFog.color.R, settings.distanceFog.color.G, settings.distanceFog.color.B, settings.distanceFog.color.A);
		}

		if (settings.heightFog.enabled){
			graphics.setBool(pipelineState.getConstantLocation("_HeightFog"), true);
			graphics.setFloat(pipelineState.getConstantLocation("_HeightFogStart"), settings.heightFog.start);
			graphics.setFloat(pipelineState.getConstantLocation("_HeightFogEnd"), settings.heightFog.end);
			graphics.setFloat4(pipelineState.getConstantLocation("_HeightFogColor"), settings.heightFog.color.R, settings.heightFog.color.G, settings.heightFog.color.B, settings.heightFog.opacity);
		}
	}

	override function execute(renderer:Renderer) {
		for (cam in renderer.cameras) {
			var g4 = cam.getRenderTarget().g4;
			g4.begin();
			g4.clear(null, 8);

			for (i in 0...renderer.opaques.length){
				var rend = renderer.opaques[i];
				var mat = rend.material;

				if (mat == null) {
					mat = Material.getDefault();
				}

				if (pipelineState == null || lastMaterial != mat) {
					createPipelineState(mat);

				}

				g4.setPipeline(pipelineState);

				var mesh = rend.mesh;


				if (mesh != lastMesh){
					g4.setVertexBuffer(mesh.getVertexBuffer());
					g4.setIndexBuffer(mesh.getIndexBuffer());
				}


				var mvp = cam.getViewProjectionMatrix().multmat(rend.modelMatrix);

				g4.setMatrix(pipelineState.getConstantLocation("Model"), rend.modelMatrix);
				g4.setMatrix(pipelineState.getConstantLocation("MVP"), mvp);

				applyEnvironment(g4);


				if (lastMaterial != mat || i == 0){
					ShaderGlobals.applyMaterial(pipelineState, g4, mat);
					mat.applyParams(g4, pipelineState);
				}

				g4.drawIndexedVertices();

				lastMaterial = mat;
				lastMesh = mesh;
			}
			g4.end();
		}
		lastMaterial = null;
		lastMesh = null;
	}

	function render(renderable:Renderable, g4:kha.graphics4.Graphics) {}
}