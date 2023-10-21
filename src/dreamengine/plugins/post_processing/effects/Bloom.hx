package dreamengine.plugins.post_processing.effects;

import kha.graphics4.PipelineState;
import kha.graphics4.Graphics2;
import kha.graphics4.Graphics2.ImageShaderPainter;
import kha.graphics2.ImageScaleQuality;
import kha.graphics5_.TextureFilter;
import kha.graphics5_.MipMapFilter;
import kha.graphics5_.TextureAddressing;
import js.html.audio.DelayNode;
import kha.System;
import kha.Scaler;
import kha.math.FastVector2;
import dreamengine.core.math.Vector2;
import kha.graphics4.Graphics;
import kha.graphics5_.TextureFormat;
import dreamengine.plugins.post_processing.effects.Blur.KawaseBlurPass;
import kha.Image;
import kha.graphics4.FragmentShader;
import dreamengine.plugins.post_processing.effects.Blur.VerticalBlurPass;
import dreamengine.plugins.post_processing.effects.Blur.HorizontalBlurPass;
import kha.Shaders;

class Bloom extends PostProcessEffect {
	var radius:Float = 1;

	var downsample = 4;
	var rts:Array<Image>;
	var tempRts:Array<Image>;

	var filterPass:BloomFilterPass;
	var blurPasses:Array<PostProcessEffectPass> = [];
	var combinePass:PostProcessEffectPass;

	var downsamplePass:PostProcessEffectPass;
	var upsamplePass:PostProcessEffectPass;

	public function new(radius:Float = 1) {
		super();
		this.radius = radius;
	}

	override function createPasses():Array<PostProcessEffectPass> {
		filterPass = new BloomFilterPass();

		for (i in 0...12) {
			blurPasses.push(new KawaseBlurPass(2.5));
		}

		downsamplePass = new SimplePostProcessPass(Shaders.bloom_downsample_frag);
		upsamplePass = new SimplePostProcessPass(Shaders.bloom_upsample_frag);

		/*
			for(i in 0...20){
				passes.push(new KawaseBlurPass(Math.pow(i * 0.1,2)));
		}*/
		combinePass = new SimplePostProcessPass(Shaders.bloom_combine_frag);
		return [];
	}

	override function execute(source:Image, destination:Image, screen:Image) {
		var rot = System.screenRotation;

		// TODO fix blur

		if (rts == null) {
			rts = [];
			tempRts = [];
			for (i in 0...downsample) {
				var p = (i + 1);
				p = p * p;
				rts.push(Image.createRenderTarget(cast screen.width / p, cast screen.height / p, RGBA64));

				tempRts.push(Image.createRenderTarget(cast screen.width / p, cast screen.height / p,RGBA64));
			}
		}

		rts[0].g2.begin();
		rts[0].g4.setPipeline(filterPass.getPipeline());
		rts[0].g2.pipeline = filterPass.getPipeline();
		filterPass.passValues(rts[0].g4);

		Scaler.scale(source, rts[0], rot);

		rts[0].g2.end();

		for (i in 1...downsample) {
			var rt = rts[i];

			rt.g2.begin();
			var pipeline = downsamplePass.getPipeline();

			rt.g4.setPipeline(pipeline);
			rt.g2.pipeline = pipeline;
			var tex = rts[i-1];

			rt.g2.imageScaleQuality = High;
			Scaler.scale(rts[i - 1], rt, rot);
			rt.g2.end();
		}



		var i = downsample - 2;
		while (i >= 0) {
			var rt = tempRts[i];

			rt.g2.begin();
			var pipeline = upsamplePass.getPipeline();
			rt.g4.setPipeline(pipeline);
			rt.g2.pipeline = pipeline;

			var t1 = rts[i + 1];
			var t2 = rts[i];

			rt.g2.imageScaleQuality = High;
			rt.g4.setTexture(pipeline.getTextureUnit("tex2"),t2);
			Scaler.scale(t1, rt,rot);


			rt.g2.end();

			i--;
		}

		


		source.g2.begin();

		var pip = combinePass.getPipeline();

		source.g2.pipeline = pip;
		source.g4.setPipeline(pip);

		var i = 0;

		var tex = tempRts[i];


		source.g2.imageScaleQuality = High;

		source.g4.setTexture(pip.getTextureUnit("sceneTexture"), screen);

		Scaler.scale(tex, source,rot);
		source.g2.drawScaledImage(screen, 0,0,100,100);

		//source.g2.drawScaledImage(rts[i+1], 0,0, 200,200);
		source.g2.drawScaledImage(rts[3], 200,0, 200,200);

		source.g2.end();
	}
}

class GaussianBlurPass extends PostProcessEffectPass {
	var direction:Vector2;

	public function new(direction:Vector2) {
		super();
		this.direction = direction;
	}

	override function getShader():FragmentShader {
		return Shaders.blur_gaussian_frag;
	}

	override function passValues(graphics:Graphics) {
		graphics.setVector2(pipeline.getConstantLocation("direction"), new FastVector2(direction.x, direction.y));
	}
}

class BloomFilterPass extends PostProcessEffectPass {
	override function getShader():FragmentShader {
		return kha.Shaders.intensity_filter_frag;
	}
	/*override function createRenderTarget(source:Image):Image {
		return Image.createRenderTarget(cast source.width / 4, cast source.height / 4, source.format);
	}*/
}

class DownsamplePass extends PostProcessEffectPass {
	var downsample = 1;

	public function new(downsample = 1) {
		super();
		this.downsample = downsample;
	}

	override function createRenderTarget(source:Image):Image {
		renderTarget = Image.createRenderTarget(cast source.width / downsample, cast source.height / downsample, source.format);
		return renderTarget;
	}
}
