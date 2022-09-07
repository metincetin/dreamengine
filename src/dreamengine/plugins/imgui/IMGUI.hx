package dreamengine.plugins.imgui;

import dreamengine.core.math.Rect;
import kha.graphics2.Graphics;
import kha.Color;

class IMGUI {
	public static function text(rect:Rect, text:String) {
		RenderStack.add(new TextRenderer(rect, text));
	}

	public static function box(rect:Rect, color:Color = Color.White) {
		RenderStack.add(new BoxRenderer(rect, color));
	}

	public static function button(rect:Rect, text:String):Bool {
		RenderStack.add(new ButtonRenderer(rect, text));
		return false;
	}
}

class IMGUIRenderer {
	public var rect:Rect;

	public function new(rect:Rect) {
		this.rect = rect;
	}

	public function render(graphics:Graphics) {}
}

class ButtonRenderer extends IMGUIRenderer {
	var text:String;
	var textRenderer:TextRenderer;
	var boxRenderer:BoxRenderer;

	public function new(rect:Rect, text:String) {
		super(rect);
		this.text = text;
		boxRenderer = new BoxRenderer(rect, Color.Black);
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
		if (graphics.font == null)
			return;
		graphics.drawString(text, rect.position.x, rect.position.y);
	}
}

class BoxRenderer extends IMGUIRenderer {
	public var color:Color;

	public function new(rect:Rect, color:Color) {
		super(rect);
		this.color = color;
	}

	override function render(graphics:Graphics) {
		graphics.color = color;
		graphics.fillRect(rect.position.x, rect.position.y, rect.size.x, rect.size.y);
		graphics.color = Color.White;
	}
}
