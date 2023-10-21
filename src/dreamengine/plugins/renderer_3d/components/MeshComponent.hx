package dreamengine.plugins.renderer_3d.components;

import dreamengine.core.Renderable;
import kha.graphics4.IndexBuffer;
import kha.graphics5_.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import dreamengine.plugins.ecs.Component;
import dreamengine.plugins.renderer_base.Mesh;
import dreamengine.plugins.renderer_base.Material;

class MeshComponent extends Component {
	var mesh:Mesh;
	var renderable:Renderable;

	public function new(mesh:Mesh, material:Material = null) {
		super();

		renderable = new Renderable();
		renderable.mesh = mesh;
		renderable.material = material;
	}


	public function getRenderable(){
		return renderable;
	}

	public function getVertices() {
		return mesh.vertices;
	}

	public function setVertices(v:Array<Float>) {
		this.mesh.vertices = v;
	}

	public function getUVs() {
		return mesh.uvs;
	}

	public function setUVs(v:Array<Float>) {
		this.mesh.uvs = v;
	}

	public function getNormals() {
		return mesh.normals;
	}

	public function setNormals(v:Array<Float>) {
		this.mesh.normals = v;
	}

	public function getIndices() {
		return mesh.indices;
	}

	public function setIndices(v:Array<Int>) {
		this.mesh.indices = v;
	}
}
