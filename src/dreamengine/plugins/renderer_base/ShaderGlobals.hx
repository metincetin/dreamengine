package dreamengine.plugins.renderer_base;

import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import dreamengine.core.math.Vector.Vector3;

class ShaderGlobals {
	static var float3Entries:Map<String, Vector3> = new Map<String, Vector3>();
	static var floatEntries:Map<String, Float> = new Map<String, Float>();

	public static function setFloat3(id:String, value:Vector3) {
		float3Entries.set(id, value);
	}

	public static function setFloat(id:String, value:Float) {
		floatEntries.set(id, value);
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
	}
}
