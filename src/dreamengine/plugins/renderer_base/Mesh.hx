package dreamengine.plugins.renderer_base;

import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;

class Mesh {
	public var vertices:Array<Float>;
	public var indices:Array<Int>;
	public var uvs:Array<Float>;
	public var normals:Array<Float>;

	var indexBuffer:IndexBuffer;
	var vertexBuffer:VertexBuffer;

	public function new() {
	}

	public function getIndexBuffer(){
		return indexBuffer;
	}

	public function getVertexBuffer(){
		return vertexBuffer;
	}

	public function generate() {
		var positions = vertices;
		var uvs = uvs;
		var normals = normals;

		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		var structLength = Std.int(struct.byteSize() / 4);

		var vertsNum = Std.int(positions.length / 3);
		// Create vertex buffer
		vertexBuffer = new VertexBuffer(vertsNum,
			struct,
			StaticUsage
		);

		// Copy vertices and colors to vertex buffer
		var vbData = vertexBuffer.lock();

		for (i in 0...vertsNum) {
			vbData.set((i * structLength) + 0, positions[(i * 3) + 0]);
			vbData.set((i * structLength) + 1, positions[(i * 3) + 1]);
			vbData.set((i * structLength) + 2, positions[(i * 3) + 2]);
			vbData.set((i * structLength) + 3, uvs[(i * 2) + 0]);
			vbData.set((i * structLength) + 4, uvs[(i * 2) + 1]);
			vbData.set((i * structLength) + 5, normals[(i * 3) + 0]);
			vbData.set((i * structLength) + 6, normals[(i * 3) + 1]);
			vbData.set((i * structLength) + 7, normals[(i * 3) + 2]);
		}

		vertexBuffer.unlock();

		indexBuffer = new kha.graphics4.IndexBuffer(indices.length, StaticUsage);

		var iData = indexBuffer.lock();

		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}

		indexBuffer.unlock();
	}
}
