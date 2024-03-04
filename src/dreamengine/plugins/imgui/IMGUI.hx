package dreamengine.plugins.imgui;

import kha.Image;
import kha.Assets;
import dreamengine.core.math.Rect;
import kha.graphics2.Graphics;
import kha.Color;

class IMGUI {
	public static var color:Color = White;
	public static var fontSize:Int = 12;

	public static function text(rect:Rect, text:String) {
		RenderStack.add(new TextRenderer(rect, text));
	}

	public static function box(rect:Rect, color:Color = Color.White) {
		RenderStack.add(new BoxRenderer(rect));
	}

	public static function button(rect:Rect, text:String):Bool {
		RenderStack.add(new ButtonRenderer(rect, text));
		return false;
	}

	public static function image(rect:Rect, image:Image) {
		RenderStack.add(new ImageRenderer(rect, image));
	}
}

class IMGUIRenderer {
	public var rect:Rect;

	public function new(rect:Rect) {
		this.rect = rect;
	}

	public function render(graphics:Graphics) {}
}

class ImageRenderer extends IMGUIRenderer{
	var image:Image;

	public function new(rect:Rect, image:Image){
		super(rect);
		this.image = image;
	}

	override function render(graphics:Graphics) {
		var pos = rect.getPosition();
		var size = rect.getSize();
		if (image == null){
			graphics.color = Pink;
			graphics.fillRect(pos.x, pos.y, size.x, size.y);
			graphics.color = White;
		}
		else
			graphics.drawScaledImage(image, pos.x, pos.y, size.x, size.y);
	}
}

class ButtonRenderer extends IMGUIRenderer {
	var text:String;
	var textRenderer:TextRenderer;
	var boxRenderer:BoxRenderer;

	public function new(rect:Rect, text:String) {
		super(rect);
		this.text = text;
		boxRenderer = new BoxRenderer(rect);
		textRenderer = new TextRenderer(rect, text);
	}

	override function render(graphics:Graphics) {
		boxRenderer.render(graphics);
		textRenderer.render(graphics);
	}
}

class TextRenderer extends IMGUIRenderer {
	public var text:String;

	public function new(rect:Rect, text:String) {
		super(rect);
		this.text = text;
	}

	override function render(graphics:Graphics) {
		graphics.font = Assets.fonts.OpenSans_Regular;
		var position = rect.getPosition();
		graphics.drawString(text, position.x, position.y);
	}
}

class BoxRenderer extends IMGUIRenderer {
	public function new(rect:Rect) {
		super(rect);
	}

	override function render(graphics:Graphics) {
		graphics.color = IMGUI.color;
		var position = rect.getPosition();
		var size = rect.getSize();
		graphics.fillRect(position.x, position.y, size.x, size.y);
		graphics.color = Color.White;
	}
}
