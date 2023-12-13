package dreamengine.plugins.renderer_base;

import kha.graphics5_.TextureFormat;
import kha.graphics5_.Usage;
import kha.Image;

class DefaultTextures {
	static var white:Image;
	static var black:Image;
	static var normal:Image;

	public static function getWhite() {
		if (white == null) {
			createWhite();
		}
		return white;
	}

	public static function getBlack() {
		if (black == null) {
			createBlack();
		}
		return black;
	}
	public static function getNormal(){
		if (normal == null){
			createNormal();
		}
		return normal;
	}

	static function createNormal() {
        var bytes = haxe.io.Bytes.alloc(16);

		bytes.set(0, 128);
		bytes.set(1, 128);
		bytes.set(2, 255);
		bytes.set(3, 255);

		bytes.set(4, 128);
		bytes.set(5, 128);
		bytes.set(6, 255);
		bytes.set(7, 255);

		bytes.set(8, 255);
		bytes.set(9, 255);
		bytes.set(10, 255);
		bytes.set(11, 255);

		bytes.set(12, 255);
		bytes.set(13, 255);
		bytes.set(14, 255);
		bytes.set(15, 255);

		normal = Image.fromBytes(bytes, 2, 2, TextureFormat.RGBA32, Usage.StaticUsage, false);
	}

	static function createBlack() {
        var bytes = haxe.io.Bytes.alloc(16);
        bytes.fill(0, 16, 0x00);
		black = Image.fromBytes(bytes, 2, 2, TextureFormat.RGBA32, Usage.StaticUsage, false);
	}

	static function createWhite() {
        var bytes = haxe.io.Bytes.alloc(16);
        bytes.fill(0, 16, 0xff);
		white = Image.fromBytes(bytes, 2, 2, TextureFormat.RGBA32, Usage.StaticUsage, false);
	}
}
