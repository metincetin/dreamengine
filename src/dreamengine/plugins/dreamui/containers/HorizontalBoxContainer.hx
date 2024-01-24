package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.elements.Label.Alignment;
import dreamengine.plugins.dreamui.layout_parameters.VerticalBoxLayoutParameters;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.HorizontalBoxLayoutParameters;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class HorizontalBoxContainer extends Element {
	var spacing = 0.0;
	var padding = Dimension.allSides(12);

	var prefSize = new Vector2();

	var childStart:BoxChildStart;

	override function parseStyle() {
		super.parseStyle();
		this.spacing = parsedStyle.getFloatValue("spacing");
		this.padding = new Dimension(parsedStyle.getFloatValue("padding-left"), parsedStyle.getFloatValue("padding-top"),
			parsedStyle.getFloatValue("padding-right"), parsedStyle.getFloatValue("padding-bottom"));

		this.childStart = parsedStyle.getStringValue("child-start", "begin");
	}

	override function layout() {
		var offset = 0.0;

		var selfSize = rect.getSize();

		var rectPos = rect.getPosition();

		var maxVerticalSize = 0.0;

		for (i in 0...getChildCount()) {
			var c = getChild(i);
			if (c.visibility == Collapsed) continue;

			var size = c.getPreferredSize();

			var pivotOffset = size * c.pivot;
			var yPos = 0.0;

			if (size.y > maxVerticalSize) maxVerticalSize= size.y;

			switch (c.getLayoutParametersAs(HorizontalBoxLayoutParameters).verticalAlignment) {
				case Top:
					yPos = rectPos.y + padding.top - pivotOffset.y;
				case Center:
					yPos = rectPos.y + selfSize.y * 0.5 - pivotOffset.y - (padding.top - padding.bottom);
				case Bottom:
					yPos = rectPos.y + selfSize.y - padding.bottom - pivotOffset.y;
				case Stretch:
					yPos = rectPos.y + padding.top;
					size.y = selfSize.y - (padding.top + padding.bottom);
			}

			if (i == 0) {
				offset += padding.left;
			} else {
				offset += spacing;
			}

			c.rect.setSize(size);
			c.rect.setPosition(new Vector2(rectPos.y + offset, yPos));
			offset += size.x;
			if (i == getChildCount() - 1) {
				offset += padding.right;
			}
		}

		prefSize.y = maxVerticalSize;
		prefSize.x = offset;
		switch (childStart) {
			case Begin:
			case Middle:
				for (c in children) {
					var midPoint = selfSize.x * 0.333333;
					var p = c.rect.getPosition();
					var yPos = p.y;
					c.rect.setPosition(new Vector2(p.x + midPoint, yPos));
				}
			case End:
				for (c in children) {
					var p = c.rect.getPosition();
					var yPos = p.y;
					c.rect.setPosition(new Vector2(p.x + rectPos.x + selfSize.x - offset, yPos));
				}
		}
	}

	override function getPreferredSize():Vector2 {
		return prefSize;
	}

	override function createLayoutParametersForChild():LayoutParameters {
		return new HorizontalBoxLayoutParameters();
	}

	override function getChildLayoutParameterType():Class<LayoutParameters> {
		return HorizontalBoxLayoutParameters;
	}

	override function onRender(g2:Graphics, opacity:Float) {
	}
}
