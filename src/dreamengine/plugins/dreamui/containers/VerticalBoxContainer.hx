package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.elements.Label.Alignment;
import dreamengine.plugins.dreamui.layout_parameters.VerticalBoxLayoutParameters;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.HorizontalBoxLayoutParameters;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class VerticalBoxContainer extends Element {
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

		for (i in 0...getChildCount()) {
			var c = getChild(i);
			if (c.visibility == Collapsed) continue;

			var size = c.getPreferredSize();

			var pivotOffset = size * c.pivot;
			var xPos = 0.0;

			switch (c.getLayoutParametersAs(VerticalBoxLayoutParameters).horizontalAlignment) {
				case Left:
					xPos = rectPos.x + padding.left - pivotOffset.x;
				case Center:
					xPos = rectPos.x + selfSize.x * 0.5 - pivotOffset.x - (padding.left - padding.right);
				case Right:
					xPos = rectPos.x + selfSize.x - padding.right - pivotOffset.x;
				case Stretch:
					xPos = rectPos.x + padding.left;
					size.x = selfSize.x - (padding.left + padding.right);
			}

			if (i == 0) {
				offset += padding.top;
			} else {
				offset += spacing;
			}

			c.rect.setSize(size);
			c.rect.setPosition(new Vector2(xPos, rectPos.y + offset));
			offset += size.y;
			if (i == getChildCount() - 1) {
				offset += padding.bottom;
			}
		}

		prefSize.y = offset;
		switch (childStart) {
			case Begin:
			case Middle:
				for (c in children) {
					var midPoint = selfSize.y * 0.333333;
					var p = c.rect.getPosition();
					var xPos = p.x;
					c.rect.setPosition(new Vector2(xPos, p.y + midPoint));
				}
			case End:
				for (c in children) {
					var p = c.rect.getPosition();
					var xPos = p.x;
					c.rect.setPosition(new Vector2(xPos, p.y + rectPos.y + selfSize.y - offset));
				}
		}
	}

	override function getPreferredSize():Vector2 {
		return prefSize;
	}

	override function createLayoutParametersForChild():LayoutParameters {
		return new VerticalBoxLayoutParameters();
	}

	override function getChildLayoutParameterType():Class<LayoutParameters> {
		return VerticalBoxLayoutParameters;
	}

	override function onRender(g2:Graphics, opacity:Float) {}
}
