package dreamengine.plugins.dreamui.utils;

import dreamengine.core.math.Rect;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.dreamui.elements.Label.Alignment;

class TextRenderingUtils {
	public static function getAlignedPosition(rect:Rect, prefSize:Vector2, alignment:Alignment) {
        var position = rect.position;
        var offset = Vector2.zero();
        var size = rect.size;
		switch (alignment) {
			case TopLeft:
				offset.x = 0;
				offset.y = 0;
			case TopCenter:
				offset.x = size.x * 0.5 - prefSize.x * 0.5;
				offset.y = 0;
			case TopRight:
				offset.x = size.x - prefSize.x;
				offset.y = 0;
			case MiddleLeft:
				offset.x = 0;
				offset.y = size.y * 0.5 - prefSize.y * 0.5;
			case MiddleCenter:
				offset.x = size.x * 0.5 - prefSize.x * 0.5;
				offset.y = size.y * 0.5 - prefSize.y * 0.5;
			case MiddleRight:
				offset.x = size.x - prefSize.x;
				offset.y = size.y * 0.5 - prefSize.y * 0.5;
			case BottomLeft:
				offset.x = 0;
				offset.y = size.y - prefSize.y;
			case BottomCenter:
				offset.x = size.x * 0.5 - prefSize.x * 0.5;
				offset.y = size.y - prefSize.y;
			case BottomRight:
				offset.x = size.x - prefSize.x;
				offset.y = size.y - prefSize.y;
		}
        return new Vector2(position.x + offset.x, position.y + offset.y);
	}
}
