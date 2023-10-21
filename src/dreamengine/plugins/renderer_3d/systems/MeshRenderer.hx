package dreamengine.plugins.renderer_3d.systems;

import dreamengine.core.Engine;
import dreamengine.plugins.renderer_3d.components.MeshComponent;
import kha.math.FastVector4;
import dreamengine.plugins.ecs.ECSContext;
import kha.Assets;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
import dreamengine.plugins.renderer_base.ShaderGlobals;
import kha.math.Vector3;
import dreamengine.plugins.renderer_base.components.Transform;
import dreamengine.plugins.renderer_2d.components.Transform2D;
import kha.graphics4.PipelineState;
import kha.graphics4.CompareMode;
import kha.Shaders;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import kha.graphics4.IndexBuffer;
import kha.graphics5_.VertexStructure;
import kha.graphics5_.Usage;
import kha.graphics4.VertexBuffer;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.ecs.System;

class MeshRenderer extends System {
	var engine:Engine;

	override function onRegistered(engine:Engine) {
		this.engine = engine;
	}

	override function execute(ecsContext:ECSContext) {
		var f = ecsContext.filter([Transform, MeshComponent]);

		for(m in f){
			var renderable = m.getComponent(MeshComponent).getRenderable();
			renderable.modelMatrix = m.getComponent(Transform).localMatrix;
			engine.getRenderer().addOpaque(renderable);
		}
	}
}
