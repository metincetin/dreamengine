package dreamengine.plugins.renderer_base;

import kha.Scaler.TargetRectangle;
import dreamengine.core.math.Vector2;
import kha.graphics5_.IndexBuffer;
import dreamengine.core.math.Vector3;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;

class Mesh {
	public var vertices:Array<Float>;
	public var indices:Array<Int>;
	public var uvs:Array<Float>;
	public var normals:Array<Float>;
	public var tangents:Array<Float>;
	public var bitangents:Array<Float>;

	var indexBuffer:IndexBuffer;
	var vertexBuffer:VertexBuffer;

	public function new() {}

	public function getIndexBuffer() {
		return indexBuffer;
	}

	public function getVertexBuffer() {
		return vertexBuffer;
	}

	public function generateTangents() {
		tangents = [];
		bitangents = [];

		{
			var i = 0;
			while (i < vertices.length / 3){
				var v0:Int = i;
				var v1:Int = i + 1;
				var v2:Int = i + 2;

				var i0 = v0;//indices[v0];
				var i1 = v1;//indices[v1];
				var i2 = v2;//indices[v2];

				var pos0:Vector3 = new Vector3(vertices[i0], vertices[i0 + 1], vertices[i0 + 2]);
				var pos1:Vector3 = new Vector3(vertices[i1], vertices[i1 + 1], vertices[i1 + 2]);
				var pos2:Vector3 = new Vector3(vertices[i2], vertices[i2 + 1], vertices[i2 + 2]);


				var uvi0 = Std.int(v0 * 2 / 3);
				var uvi1 = Std.int(v1 * 2 / 3);
				var uvi2 = Std.int(v2 * 2 / 3);

				var uv0: Vector2 = new Vector2(uvs[uvi0], uvs[uvi0 + 1]);
				var uv1: Vector2 = new Vector2(uvs[uvi1], uvs[uvi1 + 1]);
				var uv2: Vector2 = new Vector2(uvs[uvi2], uvs[uvi2 + 1]);


				var deltaPos1:Vector3 = pos1 - pos0;
				var deltaPos2:Vector3 = pos2 - pos0;

				var deltaUV1:Vector2 = uv1 - uv0;
				var deltaUV2:Vector2 = uv2 - uv0;

				var r:Float = 1.0 / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

				var tangent:Vector3 = new Vector3();
				tangent.x = r * (deltaUV2.y * deltaPos1.x - deltaUV1.y * deltaPos2.x);
				tangent.y = r * (deltaUV2.y * deltaPos1.y - deltaUV1.y * deltaPos2.y);
				tangent.z = r * (deltaUV2.y * deltaPos1.z - deltaUV1.y * deltaPos2.z);

				var bitangent = new Vector3();
				bitangent.x = r * (-deltaUV2.x * deltaPos1.x + deltaUV1.x * deltaPos2.x);
				bitangent.y = r * (-deltaUV2.x * deltaPos1.y + deltaUV1.x * deltaPos2.y);
				bitangent.z = r * (-deltaUV2.x * deltaPos1.z + deltaUV1.x * deltaPos2.z);



				tangents.push(tangent.x);
				tangents.push(tangent.y);
				tangents.push(tangent.z);

				bitangents.push(bitangent.x);
				bitangents.push(bitangent.y);
				bitangents.push(bitangent.z);

				i+= 3;
			}

			return;
		}

		for (i in 0...Std.int(vertices.length / 3)) {
			var v0:Int = i * 3;
			var v1:Int = (i + 1)* 3;
			var v2:Int = (i + 2)* 3;

			var pos0:Vector3 = new Vector3(vertices[v0], vertices[v0 + 1], vertices[v0 + 2]);
			var pos1:Vector3 = new Vector3(vertices[v1], vertices[v1 + 1], vertices[v1 + 2]);
			var pos2:Vector3 = new Vector3(vertices[v2], vertices[v2 + 1], vertices[v2 + 2]);

            var uv0: Vector2 = new Vector2(uvs[i * 2], uvs[i * 2 + 1]);
            var uv1: Vector2 = new Vector2(uvs[(i + 1) * 2], uvs[(i + 1) * 2 + 1]);
            var uv2: Vector2 = new Vector2(uvs[(i + 2) * 2], uvs[(i + 2) * 2 + 1]);
      

			var deltaPos1:Vector3 = pos1 - pos0;
			var deltaPos2:Vector3 = pos2 - pos0;

			var deltaUV1:Vector2 = uv1 - uv0;
			var deltaUV2:Vector2 = uv2 - uv0;

			var r:Float = 1.0 / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

			var tangent:Vector3 = new Vector3();
			tangent.x = r * (deltaUV2.y * deltaPos1.x - deltaUV1.y * deltaPos2.x);
			tangent.y = r * (deltaUV2.y * deltaPos1.y - deltaUV1.y * deltaPos2.y);
			tangent.z = r * (deltaUV2.y * deltaPos1.z - deltaUV1.y * deltaPos2.z);

			var bitangent = new Vector3();
			bitangent.x = r * (-deltaUV2.x * deltaPos1.x + deltaUV1.x * deltaPos2.x);
			bitangent.y = r * (-deltaUV2.x * deltaPos1.y + deltaUV1.x * deltaPos2.y);
			bitangent.z = r * (-deltaUV2.x * deltaPos1.z + deltaUV1.x * deltaPos2.z);


			tangents.push(tangent.x);
			tangents.push(tangent.y);
			tangents.push(tangent.z);

			bitangents.push(bitangent.x);
			bitangents.push(bitangent.y);
			bitangents.push(bitangent.z);
		}
	}

	function calculateBitangent(normal:Vector3, tangent:Vector3) {
		return normal.cross(tangent);
	}

	public function calculateTangent(v1:Vector3, v2:Vector3, v3:Vector3, uv1:Vector2, uv2:Vector2, uv3:Vector2, normal:Vector3) {
		var deltaPos1 = v2 - v1;
		var deltaPos2 = v3 - v1;

		var deltaUV1 = uv2 - uv1;
		var deltaUV2 = uv3 - uv1;

		// Solving the system of linear equations
		var r = (deltaUV1.x * deltaUV2.y - deltaUV1.y * deltaUV2.x);
		if (r == 0) {
			return Vector3.zero();
		}
		var rInv = 1.0 / r;

		var tangent = new Vector3();

		tangent.x = (deltaPos1.x * deltaUV2.y - deltaPos2.x * deltaUV1.y) * rInv;
		tangent.y = (deltaPos1.y * deltaUV2.y - deltaPos2.y * deltaUV1.y) * rInv;
		tangent.z = (deltaPos1.z * deltaUV2.y - deltaPos2.z * deltaUV1.y) * rInv;

		// Gram-Schmidt orthogonalization against the normal
		tangent = (tangent - tangent.dot(normal) * normal);
		tangent.normalize();

		return tangent;
	}

	public function generate() {
		var positions = vertices;
		var uvs = uvs;
		var normals = normals;

		generateTangents();

		var struct = new VertexStructure();
		struct.add("vertexPosition", Float3);
		struct.add("uv", Float2);
		struct.add("vertexNormal", Float3);
		struct.add("vertexTangent", Float3);
		struct.add("vertexBitangent", Float3);

		var structLength = Std.int(struct.byteSize() / 4);

		var vertsNum = Std.int(positions.length / 3);

		vertexBuffer = new VertexBuffer(vertsNum, struct, StaticUsage);

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
			vbData.set((i * structLength) + 8, tangents[(i * 3) + 0]);
			vbData.set((i * structLength) + 9, tangents[(i * 3) + 1]);
			vbData.set((i * structLength) + 10, tangents[(i * 3) + 2]);
			vbData.set((i * structLength) + 11, bitangents[(i * 3) + 0]);
			vbData.set((i * structLength) + 12, bitangents[(i * 3) + 1]);
			vbData.set((i * structLength) + 13, bitangents[(i * 3) + 2]);
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
