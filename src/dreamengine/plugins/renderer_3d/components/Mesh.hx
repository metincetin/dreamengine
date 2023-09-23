package dreamengine.plugins.renderer_3d.components;

import kha.graphics4.IndexBuffer;
import kha.graphics5_.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;
import dreamengine.plugins.ecs.Component;

class Mesh extends Component {
	var vertices:Array<Float>;
	var indices:Array<Int>;
	var uvs:Array<Float>;
	var normals:Array<Float>;
	var struct:VertexStructure;

	public var data:Array<Float>;

	public function new() {
		super();
	}

	public function createBuffer(){

	}

	public function getVertices() {
		return vertices;
	}

	public function setVertices(v:Array<Float>) {
		this.vertices = v;
	}

	public function getUVs() {
		return uvs;
	}

	public function setUVs(v:Array<Float>) {
		this.uvs = v;
	}

	public function getNormals() {
		return normals;
	}

	public function setNormals(v:Array<Float>) {
		this.normals = v;
	}

	public function getIndices() {
		return indices;
	}

	public function setIndices(v:Array<Int>) {
		this.indices = v;
	}
}
