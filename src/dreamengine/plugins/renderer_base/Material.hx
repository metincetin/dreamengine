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

typedef ColorParam = {
	name:String,
	value:FastVector4,
	?location:ConstantLocation
}

typedef FloatParam = {
	name:String,
	value:Float,
	?location:ConstantLocation
}

typedef TextureParam = {
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

	var colorParams = new Array<ColorParam>();
	var floatParams = new Array<FloatParam>();
	var textureParams = new Array<TextureParam>();



	public function new(vShader:VertexShader, fShader:FragmentShader) {
		this.fragmentShader = fShader;
		this.vertexShader = vShader;
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

	public function setColorParam(name:String, value:FastVector4) {
		for(c in colorParams){
			if (c.name == name){
				c.value = value;
				return;
			}
		}

		colorParams.push({name:name, value:value});
	}

	public function updateLocations(pipelineState:PipelineState){
		for(c in colorParams){
			c.location = pipelineState.getConstantLocation(c.name);
		}

		for(c in floatParams){
			c.location = pipelineState.getConstantLocation(c.name);
		}

		for(c in textureParams){
			c.location = pipelineState.getTextureUnit(c.name);
		}
	}

	public function applyParams(g4:Graphics) {
		for(c in colorParams){
			g4.setVector4(c.location, c.value);
		}

		for(c in floatParams){
			g4.setFloat(c.location, c.value);
		}

		for(c in textureParams){
			g4.setTexture(c.location, c.value);
		}
	}

	public function setFloatParam(name:String, value:Float) {
		for(c in floatParams){
			if (c.name == name){
				c.value = value;
				return;
			}
		}
		floatParams.push({name:name, value:value});
	}
	public function setTextureParam(name:String, value:Image){
		for(c in textureParams){
			if (c.name == name){
				c.value = value;
				return;
			}
		}
		textureParams.push({name:name, value:value});
	}
}
