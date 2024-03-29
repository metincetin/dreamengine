package dreamengine.plugins.renderer_3d.loaders;

import dreamengine.plugins.renderer_base.Mesh;
import kha.Blob;
import kha.Assets;

class ObjLoader {
	public static function load(asset:kha.Blob){
		return loadString(asset.readUtf8String());
	}
	public static function loadString(objData:String) {
		var vertices:Array<Float> = [];
		var uvs:Array<Float> = [];
		var normals:Array<Float> = [];

		var vertexIndices:Array<Int> = [];
		var uvIndices:Array<Int> = [];
		var normalIndices:Array<Int> = [];

		var tempVertices:Array<Array<Float>> = [];
		var tempUVs:Array<Array<Float>> = [];
		var tempNormals:Array<Array<Float>> = [];

		var lines:Array<String> = objData.split("\n");

		for (i in 0...lines.length) {
			var words:Array<String> = lines[i].split(" ");

			if (words[0] == "v") {
				var vector:Array<Float> = [];
				vector.push(Std.parseFloat(words[1]));
				vector.push(Std.parseFloat(words[2]));
				vector.push(Std.parseFloat(words[3]));
				tempVertices.push(vector);
			} else if (words[0] == "vt") {
				var vector:Array<Float> = [];
				vector.push(Std.parseFloat(words[1]));
				vector.push(Std.parseFloat(words[2]));
				tempUVs.push(vector);
			} else if (words[0] == "vn") {
				var vector:Array<Float> = [];
				vector.push(Std.parseFloat(words[1]));
				vector.push(Std.parseFloat(words[2]));
				vector.push(Std.parseFloat(words[3]));
				tempNormals.push(vector);
			} else if (words[0] == "f") {
				var sec1:Array<String> = words[1].split("/");
				var sec2:Array<String> = words[2].split("/");
				var sec3:Array<String> = words[3].split("/");

				vertexIndices.push(Std.int(Std.parseFloat(sec1[0])));
				vertexIndices.push(Std.int(Std.parseFloat(sec2[0])));
				vertexIndices.push(Std.int(Std.parseFloat(sec3[0])));

				uvIndices.push(Std.int(Std.parseFloat(sec1[1])));
				uvIndices.push(Std.int(Std.parseFloat(sec2[1])));
				uvIndices.push(Std.int(Std.parseFloat(sec3[1])));

				normalIndices.push(Std.int(Std.parseFloat(sec1[2])));
				normalIndices.push(Std.int(Std.parseFloat(sec2[2])));
				normalIndices.push(Std.int(Std.parseFloat(sec3[2])));
			}
		}

		for (i in 0...vertexIndices.length) {
			var vertex:Array<Float> = tempVertices[vertexIndices[i] - 1];
			var uv:Array<Float> = tempUVs[uvIndices[i] - 1];
			var normal:Array<Float> = tempNormals[normalIndices[i] - 1];

			vertices.push(vertex[0]);
			vertices.push(vertex[1]);
			vertices.push(vertex[2]);
			uvs.push(uv[0]);
			uvs.push(uv[1]);
			normals.push(normal[0]);
			normals.push(normal[1]);
			normals.push(normal[2]);
		}

		var indices = new Array<Int>();
		var indexedVertices = new Array<Float>();
		var indexedUVs = new Array<Float>();
		var indexedNormals = new Array<Float>();

		// For each input vertex
		for (i in 0...Std.int(vertices.length / 3)) {
			// Try to find a similar vertex in out_XXXX
			var index = getSimilarVertexIndex(vertices[i * 3], vertices[i * 3 + 1], vertices[i * 3 + 2], uvs[i * 2], uvs[i * 2 + 1], normals[i * 3],
				normals[i * 3 + 1], normals[i * 3 + 2], indexedVertices, indexedUVs, indexedNormals);

			if (index != -1) { // A similar vertex is already in the VBO, use it instead !
				indices.push(index);
			} else { // If not, it needs to be added in the output data.
				indexedVertices.push(vertices[i * 3]);
				indexedVertices.push(vertices[i * 3 + 1]);
				indexedVertices.push(vertices[i * 3 + 2]);
				indexedUVs.push(uvs[i * 2]);
				indexedUVs.push(uvs[i * 2 + 1]);
				indexedNormals.push(normals[i * 3]);
				indexedNormals.push(normals[i * 3 + 1]);
				indexedNormals.push(normals[i * 3 + 2]);
				indices.push(Std.int(indexedVertices.length / 3) - 1);
			}
		}

		var mesh = new Mesh();
		mesh.vertices = indexedVertices;
		mesh.uvs = indexedUVs;
		mesh.normals = indexedNormals;
		mesh.indices = indices;

		mesh.generate();
		return mesh;
	}

	// Returns true if v1 can be considered equal to v2
	static function isNear(v1:Float, v2:Float):Bool {
		return Math.abs(v1 - v2) < 0.01;
	}

	// Searches through all already-exported vertices for a similar one.
	// Similar = same position + same UVs + same normal
	static function getSimilarVertexIndex(vertexX:Float, vertexY:Float, vertexZ:Float, uvX:Float, uvY:Float, normalX:Float, normalY:Float, normalZ:Float, indexedVertices:Array<Float>, indexedUVs:Array<Float>, indexedNormals:Array<Float>):Int {
		// Lame linear search
		for (i in 0...Std.int(indexedVertices.length / 3)) {
			if (isNear(vertexX, indexedVertices[i * 3])
				&& isNear(vertexY, indexedVertices[i * 3 + 1])
				&& isNear(vertexZ, indexedVertices[i * 3 + 2])
				&& isNear(uvX, indexedUVs[i * 2])
				&& isNear(uvY, indexedUVs[i * 2 + 1])
				&& isNear(normalX, indexedNormals[i * 3])
				&& isNear(normalY, indexedNormals[i * 3 + 1])
				&& isNear(normalZ, indexedNormals[i * 3 + 2])) {
				return i;
			}
		}
		return -1;
	}
}
