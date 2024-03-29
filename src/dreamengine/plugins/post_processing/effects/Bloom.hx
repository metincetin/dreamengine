package dreamengine.plugins.post_processing.effects;

import js.html.Cache;
import dreamengine.plugins.renderer_base.components.Camera;
import haxe.macro.Compiler.DefineDescription;
import kha.graphics4.PipelineState;
import kha.graphics4.Graphics2;
import kha.graphics4.Graphics2.ImageShaderPainter;
import kha.graphics2.ImageScaleQuality;
import kha.graphics5_.TextureFilter;
import kha.graphics5_.MipMapFilter;
import kha.graphics5_.TextureAddressing;
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

	var downsample = 6;
	var rts:Array<Image>;
	var blurRts:Array<Image>;
	var upscaledRts:Array<Image>;
	var filterRt:Image;

	var filterPass:BloomFilterPass;
	var combinePass:PostProcessEffectPass;

	var downsamplePass:PostProcessEffectPass;
	var upsamplePass:PostProcessEffectPass;
	var verticalBlurPass:VerticalBlurPass;
	var horizontalBlurPass:HorizontalBlurPass;

	var kawaseBlurPasses = new Array<KawaseBlurPass>();

	public function new(radius:Float = 1) {
		super();
		this.radius = radius;
	}

	override function createPasses():Array<PostProcessEffectPass> {
		filterPass = new BloomFilterPass();

		kawaseBlurPasses = [new KawaseBlurPass(0.5)];

		downsamplePass = new SimplePostProcessPass(Shaders.bloom_downsample_frag);
		upsamplePass = new SimplePostProcessPass(Shaders.bloom_upsample_frag);

		horizontalBlurPass = new HorizontalBlurPass();
		verticalBlurPass = new VerticalBlurPass();

		combinePass = new SimplePostProcessPass(Shaders.additive_blend_frag);
		return [];
	}

	override function execute(source:Image, destination:Image, screen:Image, camera:Camera) {
		var rot = System.screenRotation;

		// TODO fix blur

		if (rts == null) {
			rts = [];
			upscaledRts = [];
			blurRts = [];
			var curWidth = screen.width;
			var curHeight = screen.height;

			for (i in 0...downsample) {
				curWidth = Std.int(curWidth / 2);
				curHeight = Std.int(curHeight / 2);
				rts.push(Image.createRenderTarget(curWidth, curHeight, RGBA64));
				blurRts.push(Image.createRenderTarget(curWidth, curHeight, RGBA64));

				upscaledRts.push(Image.createRenderTarget(curWidth, curHeight, RGBA64));
			}

			filterRt = Image.createRenderTarget(screen.width, screen.height, RGBA64);
		}

		filterRt.g2.begin();
		filterRt.g4.setPipeline(filterPass.getPipeline());
		filterRt.g2.pipeline = filterPass.getPipeline();
		filterPass.passValues(filterRt.g4, camera);

		Scaler.scale(source, filterRt, rot);

		filterRt.g2.end();

		for (i in 0...rts.length) {
			var s:Image;
			var t:Image;

			if (i == 0) {
				s = filterRt;
				t = rts[i];
			} else {
				s = rts[i - 1];
				t = rts[i];
			}

			blurRts[i].g2.begin(false);
			blurRts[i].g2.pipeline = downsamplePass.getPipeline();
			blurRts[i].g4.setPipeline(downsamplePass.getPipeline());
			downsamplePass.passValues(blurRts[i].g4, camera);
			blurRts[i].g2.imageScaleQuality = High;
			Scaler.scale(s, blurRts[i], rot);

			blurRts[i].g2.end();

			t.g2.begin(false);
			t.g2.imageScaleQuality = High;
			t.g2.pipeline = kawaseBlurPasses[0].getPipeline();
			t.g4.setPipeline(kawaseBlurPasses[0].getPipeline());
			kawaseBlurPasses[0].passValues(t.g4, camera);
			Scaler.scale(blurRts[i], t, rot);
			t.g2.end();
		}

		var i = upscaledRts.length - 1;
		while (i > 0) {
			var s:Image;
			var s2:Image;
			var t:Image;

			t = upscaledRts[i - 1];

			if (i == upscaledRts.length - 1) {
				s = rts[i];
				s2 = rts[i - 1];
			} else {
				s = upscaledRts[i];
				s2 = rts[i];
			}

			t.g2.begin(false);
			t.g2.pipeline = upsamplePass.getPipeline();
			t.g4.setPipeline(upsamplePass.getPipeline());
			upsamplePass.passValues(t.g4, camera);
			t.g2.imageScaleQuality = High;
			t.g4.setTexture(upsamplePass.getPipeline().getTextureUnit("tex2"), s2);

			Scaler.scale(s, t, rot);
			t.g2.end();
			i--;
		}

		destination.g2.begin();
		destination.g2.pipeline = combinePass.getPipeline();
		destination.g4.setPipeline(combinePass.getPipeline());
		combinePass.passValues(destination.g4, camera);

		destination.g4.setTexture(combinePass.getPipeline().getTextureUnit("sceneTexture"), screen);
		Scaler.scale(upscaledRts[0], destination, rot);
		destination.g2.end();
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

	override function passValues(graphics:Graphics, camera:Camera) {
		graphics.setVector2(pipeline.getConstantLocation("direction"), new FastVector2(direction.x, direction.y));
	}
}

class BloomFilterPass extends PostProcessEffectPass {
	override function getShader():FragmentShader {
		return kha.Shaders.intensity_filter_frag;
	}
}