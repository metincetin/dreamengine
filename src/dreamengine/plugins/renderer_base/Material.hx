package dreamengine.plugins.renderer_base;

import kha.graphics4.TextureUnit;
import kha.graphics4.ConstantLocation;
import kha.Image;
import kha.graphics4.Graphics;
import kha.math.FastVector4;
import kha.graphics4.PipelineState;
import kha.Color;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import dreamengine.plugins.ecs.Component;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;

typedef ColorUniform = {
	name:String,
	value:FastVector4,
	?location:ConstantLocation
}

typedef FloatUniform = {
	name:String,
	value:Float,
	?location:ConstantLocation
}

typedef TextureUniform = {
	name:String,
	value:Image,
	?location:TextureUnit
}

enum UniformType{
	Vector;
	Float;
}

typedef GlobalUniform = {
	type:UniformType,
	name:String
}

class Material{
	var fragmentShader:FragmentShader;
	var vertexShader:VertexShader;

	public var cullMode: CullMode = Clockwise;
	public var depthMode:CompareMode = LessEqual;
	public var depthWrite = true;

	private static var defaultMaterial:Material;

	public static function getDefault(){ return defaultMaterial; }
	public static function setDefault(mat:Material){ return defaultMaterial = mat; }


	var uniforms:Array<String> = [];

	var colorUniforms = new Array<ColorUniform>();
	var floatUniforms = new Array<FloatUniform>();
	var textureUniforms = new Array<TextureUniform>();



	public function new(vShader:VertexShader, fShader:FragmentShader) {
		this.fragmentShader = fShader;
		this.vertexShader = vShader;
	}

	public function copy() {
		var n = new Material(vertexShader, fragmentShader);
		n.colorUniforms = colorUniforms.copy();
		n.floatUniforms = floatUniforms.copy();
		n.textureUniforms = textureUniforms.copy();
		n.uniforms = uniforms.copy();
		n.cullMode = cullMode;
		n.depthMode = depthMode;
		n.depthWrite = depthWrite;

		return n;
	}

	public function addGlobalUniform(name:String){
		if (hasGlobalUniform(name)) return;
		uniforms.push(name);
	}
	public function hasGlobalUniform(name:String){
		return uniforms.contains(name);
	}

	public function getVertexShader() {
		return vertexShader;
	}

	public function setVertexShader(value:VertexShader) {
		vertexShader = value;
	}

	public function getFragmentShader() {
		return fragmentShader;
	}

	public function setFragmentShader(value:FragmentShader) {
		fragmentShader = value;
	}

	public function setColorUniform(name:String, value:FastVector4) {
		for(c in colorUniforms){
			if (c.name == name){
				c.value = value;
				return;
			}
		}

		colorUniforms.push({name:name, value:value});
	}

	public function updateLocations(pipelineState:PipelineState){
		for(c in colorUniforms){
			c.location = pipelineState.getConstantLocation(c.name);
		}

		for(c in floatUniforms){
			c.location = pipelineState.getConstantLocation(c.name);
		}

		for(c in textureUniforms){
			c.location = pipelineState.getTextureUnit(c.name);
		}
	}

	public function applyUniforms(g4:Graphics) {
		for(c in colorUniforms){
			g4.setVector4(c.location, c.value);
		}

		for(c in floatUniforms){
			g4.setFloat(c.location, c.value);
		}

		for(c in textureUniforms){
			g4.setTexture(c.location, c.value);
		}
	}

	public function getFloatUniform(name:String, def:Float = 0.0){
		for(c in floatUniforms){
			if (c.name == name){
				return c.value;
			}
		}
		return def;
	}
	public function setFloatUniform(name:String, value:Float) {
		for(c in floatUniforms){
			if (c.name == name){
				c.value = value;
				return;
			}
		}
		floatUniforms.push({name:name, value:value});
	}
	public function setTextureUniform(name:String, value:Image){
		for(c in textureUniforms){
			if (c.name == name){
				c.value = value;
				return;
			}
		}
		textureUniforms.push({name:name, value:value});
	}

	public function getTextureUniform(name:String) {
		for(c in textureUniforms){
			if (c.name == name){
				return c.value;
			}
		}
		return null;
	}
}
