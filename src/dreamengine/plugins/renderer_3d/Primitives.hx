package dreamengine.plugins.renderer_3d;

import dreamengine.core.math.Vector2;
import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_3d.components.Mesh;

class Primitives {
	public static var cubeVertices = [
		-0.5, -0.5, -0.5,
		-0.5, -0.5,  0.5,
		-0.5,  0.5,  0.5,
		 0.5,  0.5, -0.5,
		-0.5, -0.5, -0.5,
		-0.5,  0.5, -0.5,
		 0.5, -0.5,  0.5,
		-0.5, -0.5, -0.5,
		 0.5, -0.5, -0.5,
		 0.5,  0.5, -0.5,
		 0.5, -0.5, -0.5,
		-0.5, -0.5, -0.5,
		-0.5, -0.5, -0.5,
		-0.5,  0.5,  0.5,
		-0.5,  0.5, -0.5,
		 0.5, -0.5,  0.5,
		-0.5, -0.5,  0.5,
		-0.5, -0.5, -0.5,
		-0.5,  0.5,  0.5,
		-0.5, -0.5,  0.5,
		 0.5, -0.5,  0.5,
		 0.5,  0.5,  0.5,
		 0.5, -0.5, -0.5,
		 0.5,  0.5, -0.5,
		 0.5, -0.5, -0.5,
		 0.5,  0.5,  0.5,
		 0.5, -0.5,  0.5,
		 0.5,  0.5,  0.5,
		 0.5,  0.5, -0.5,
		-0.5,  0.5, -0.5,
		 0.5,  0.5,  0.5,
		-0.5,  0.5, -0.5,
		-0.5,  0.5,  0.5,
		 0.5,  0.5,  0.5,
		-0.5,  0.5,  0.5,
		 0.5, -0.5,  0.5
	];

	public static var cubeNormals = [
		-1.0, -1.0, -1.0,
		-1.0, -1.0,  1.0,
		-1.0,  1.0,  1.0,
		 1.0,  1.0, -1.0,
		-1.0, -1.0, -1.0,
		-1.0,  1.0, -1.0,
		 1.0, -1.0,  1.0,
		-1.0, -1.0, -1.0,
		 1.0, -1.0, -1.0,
		 1.0,  1.0, -1.0,
		 1.0, -1.0, -1.0,
		-1.0, -1.0, -1.0,
		-1.0, -1.0, -1.0,
		-1.0,  1.0,  1.0,
		-1.0,  1.0, -1.0,
		 1.0, -1.0,  1.0,
		-1.0, -1.0,  1.0,
		-1.0, -1.0, -1.0,
		-1.0,  1.0,  1.0,
		-1.0, -1.0,  1.0,
		 1.0, -1.0,  1.0,
		 1.0,  1.0,  1.0,
		 1.0, -1.0, -1.0,
		 1.0,  1.0, -1.0,
		 1.0, -1.0, -1.0,
		 1.0,  1.0,  1.0,
		 1.0, -1.0,  1.0,
		 1.0,  1.0,  1.0,
		 1.0,  1.0, -1.0,
		-1.0,  1.0, -1.0,
		 1.0,  1.0,  1.0,
		-1.0,  1.0, -1.0,
		-1.0,  1.0,  1.0,
		 1.0,  1.0,  1.0,
		-1.0,  1.0,  1.0,
		 1.0, -1.0,  1.0
	];

	public static var cubeUVs = [
		-1.0, 1.0, 1.0, -1.0, -1.0, -1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, -1.0, 1.0, 1.0,
		1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, 1.0, 1.0
	];

	static var planeVertices:Array<Float> = [
		-1, 0, -1,
		 1, 0, -1,
		-1, 0,  1,
		 1, 0,  1
	];

	static var planeNormals:Array<Float> = [
		0, 1, 0,
		0, 1, 0,
		0, 1, 0,
		0, 1, 0,
	];

	static var planeUVs:Array<Float> = [
		0, 0,
		1, 0,
		0, 1,
		1, 1
	];

	public static function cube() {
		var ret = new Mesh();
		ret.setVertices(cubeVertices);
		ret.setIndices([
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35
		]);
		ret.setNormals(cubeNormals);
		ret.setUVs(cubeUVs);
		return ret;
	}

	public static function plane() {
		var ret = new Mesh();
		ret.setVertices(planeVertices);
		ret.setIndices([0, 1, 2, 2, 3, 1]);
		ret.setNormals(planeNormals);
		ret.setUVs(planeUVs);
		return ret;
	}

	public static function sphere(radius:Float = 0.5, latitudeBands:Int = 16, longitudeBands:Int = 16):Mesh {
		var vertices:Array<Float> = [];
		var normals:Array<Float> = [];
		var uvs:Array<Float> = [];
		var indices:Array<Int> = [];

		for (lat in 0...latitudeBands + 1) {
			var theta:Float = lat * Math.PI / latitudeBands;
			var sinTheta:Float = Math.sin(theta);
			var cosTheta:Float = Math.cos(theta);

			for (long in 0...longitudeBands + 1) {
				var phi:Float = long * 2 * Math.PI / longitudeBands;
				var sinPhi:Float = Math.sin(phi);
				var cosPhi:Float = Math.cos(phi);

				var x:Float = cosPhi * sinTheta;
				var y:Float = cosTheta;
				var z:Float = sinPhi * sinTheta;
				var u:Float = 1 - (long / longitudeBands);
				var v:Float = lat / latitudeBands;

				normals.push(x);
				normals.push(y);
				normals.push(-z);
				uvs.push(u);
				uvs.push(v);
				vertices.push(radius * x);
				vertices.push(radius * y);
				vertices.push(radius * z);
			}
		}

		for (lat in 0...latitudeBands) {
			for (long in 0...longitudeBands) {
				var first:Int = (lat * (longitudeBands + 1)) + long;
				var second:Int = first + longitudeBands + 1;

				indices.push(first);
				indices.push(second);
				indices.push(first + 1);

				indices.push(second);
				indices.push(second + 1);
				indices.push(first + 1);
			}
		}

		var mesh = new Mesh();
		mesh.setNormals(normals);
		mesh.setIndices(indices);
		mesh.setUVs(uvs);
		mesh.setVertices(vertices);

		return mesh;
	}
}
