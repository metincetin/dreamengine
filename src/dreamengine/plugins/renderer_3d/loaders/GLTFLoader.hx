package dreamengine.plugins.renderer_3d.loaders;

import kha.Blob;
import dreamengine.plugins.renderer_3d.components.Mesh;
import haxe.ds.Vector;
import gltf.GLTF;
import gltf.schema.TGLTF;
import kha.Assets;

class GLTFLoader {
	public static function loadByName(name:String) {
		var gltfName = name + "_gltf";
		var binName = name + "_bin";
		return load(Assets.blobs.get(gltfName), Assets.blobs.get(binName));
	}

	public static function load(gltf:Blob, bin:Blob) {
		var raw:TGLTF = GLTF.parse(gltf.toString());
		var object:GLTF = GLTF.load(raw, [bin.bytes]);
		var positions:Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("POSITION");
		var normals:Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("NORMAL");
		var uvs:Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("TEXCOORD_0");
		var indices:Vector<Int> = object.meshes[0].primitives[0].getIndexValues();

		var mesh = new Mesh();
		mesh.setVertices(positions.toArray());
		mesh.setNormals(normals.toArray());
		mesh.setUVs(uvs.toArray());
		mesh.setIndices(indices.toArray());
		return mesh;
	}
}
