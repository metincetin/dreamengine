package dreamengine.plugins.renderer_3d;

import dreamengine.core.math.Vector3;
import dreamengine.plugins.renderer_3d.components.Mesh;

class ProceduralMesh {
	public static function uvSphere(radius:Float):Mesh {
		var mesh = new Mesh();
		var points = new Array<Float>();
		var normals = new Array<Float>();
		var uvs = new Array<Float>();
		var indices = new Array<Int>();

		var segments = 16;
		var tau = Math.PI + Math.PI;

		var thisRow = 0;
		var prevRow = 0;
		var point = 0;

		for (j in 0...segments) {
			var v = j / (segments);
			var w = Math.sin(Math.PI * v);
			var y = Math.cos(Math.PI * v);

			for (i in 0...segments) {
				var u = i / segments;

				var x = Math.sin(u * tau);
				var z = Math.sin(u * tau);

				points.push(x * radius * w);
				points.push(y);
				points.push(z * radius * w);

				var normal = new Vector3(x * w, radius * y, z * w);
				normal.normalize();
				normals.push(normal.x);
				normals.push(normal.y);
				normals.push(normal.z);

				uvs.push(u);
				uvs.push(u);

				point++;

				if (i > 0 && j > 0) {
					indices.push(prevRow + i - 1);
					indices.push(prevRow + i);
					indices.push(thisRow + i - 1);

					indices.push(prevRow + i);
					indices.push(thisRow + i);
					indices.push(thisRow + i - 1);
				}
				prevRow = thisRow;
				thisRow = point;
			}
		}

		mesh.setIndices(indices);
		mesh.setVertices(points);
		trace(indices.length);
		trace(points.length);
		return mesh;
	}
}
