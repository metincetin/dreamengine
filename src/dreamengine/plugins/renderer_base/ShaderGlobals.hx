package dreamengine.plugins.renderer_base;

import kha.graphics4.TextureUnit;
import kha.math.FastMatrix4;
import kha.Image;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import dreamengine.core.math.Vector3;

class ShaderGlobals {
	static var float3Entries:Map<String, Vector3> = new Map<String, Vector3>();
	static var floatEntries:Map<String, Float> = new Map<String, Float>();
	static var textureEntries:Map<String, Image> = new Map<String, Image>();
	static var matrixEntries:Map<String, FastMatrix4> = new Map<String, FastMatrix4>();

	public static function setFloat3(id:String, value:Vector3) {
		float3Entries.set(id, value);
	}

	public static function setFloat(id:String, value:Float) {
		floatEntries.set(id, value);
	}

	public static function setTexture(key:String, value:Image) {
		textureEntries.set(key, value);
	}

	public static function apply(pipelineState:PipelineState, g:Graphics) {
		for (entryKey in float3Entries.keys()) {
			var entry = float3Entries[entryKey];
			if (entry == null)
				continue;
			
			g.setFloat3(pipelineState.getConstantLocation(entryKey), entry.x, entry.y, entry.z);
		}
		for (entryKey in floatEntries.keys()) {
			var entry = floatEntries[entryKey];
			if (entry == null)
				continue;
			g.setFloat(pipelineState.getConstantLocation(entryKey), entry);
		}
		for(entryKey in textureEntries.keys()){
			var entry = textureEntries[entryKey];
			if (entry == null) continue;
			g.setTexture(pipelineState.getTextureUnit(entryKey), entry);
		}
		for(entryKey in matrixEntries.keys()){
			var entry = matrixEntries[entryKey];
			if (entry == null) continue;
			g.setMatrix(pipelineState.getConstantLocation(entryKey), entry);
		}
	}


	public static function getTexture(s:String) {
		return textureEntries[s];
	}

	public static function setMatrix(s: String, value:FastMatrix4) {
		matrixEntries.set(s,value);
	}
}
