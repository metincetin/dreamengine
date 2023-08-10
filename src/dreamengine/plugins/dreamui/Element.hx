package dreamengine.plugins.dreamui;

import dreamengine.core.Time;
import dreamengine.core.math.Mathf;
import dreamengine.plugins.dreamui.styling.*;
import dreamengine.plugins.dreamui.styling.Selector;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;
import dreamengine.core.math.Rect;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector2;

@:rtti
@:keep
@:keepSub
class Element {
	public var name = "";

	public var parent:Element;

	var children:Array<Element> = new Array<Element>();

	var isDirty = false;

	var layoutParameters = new LayoutParameters();

	var localScale = Vector2.one();

	var enabled:Bool = true;

	var renderOpacity:Float = 1;

	var rect:Rect = new Rect();

	var pivot = Vector2.half();

	var styleClasess = new Array<String>();

	var style:Style;

	var parsedStyle = ParsedStyle.empty();

	public function getParsedStyle() {
		return parsedStyle;
	}

	public function getEnabled() {
		return enabled;
	}

	public function setEnabled(value:Bool) {
		enabled = value;
		for (c in children) {
			c.setEnabled(value);
		}
	}

	public function getStyle() {
		return style;
	}

	public function setStyle(style:Style) {
		this.style = style;
		parseStyle();

		for (c in getChildren()) {
			c.setStyle(style);
		}
	}

	public function setRenderOpacity(renderOpacity:Float) {
		this.renderOpacity = renderOpacity;
	}

	public function getRenderOpacity() {
		return this.renderOpacity;
	}

	public function getLocalScale() {
		return localScale;
	}

	public function getLayoutParameters() {
		return layoutParameters;
	}

	public function getLayoutParametersAs<T:LayoutParameters>(type:Class<T>):T {
		return cast layoutParameters;
	}

	function getChildLayoutParameterType():Class<LayoutParameters> {
		return LayoutParameters;
	}

	function createLayoutParametersForChild():LayoutParameters {
		return new LayoutParameters();
	}

	public function getChild(index:Int) {
		return children[index];
	}

	public function getChildren() {
		return children;
	}

	public function setLocalScale(scale:Vector2) {
		localScale = scale;
		isDirty = true;
	}

	public function getScale() {
		if (parent == null) {
			return localScale;
		}
		return localScale * parent.getScale();
	}

	public function getParent() {
		return parent;
	}

	public function new() {}

	public function getIsDirty() {
		return isDirty;
	}

	public final function render(g2:Graphics, opacity:Float) {
		if (isDirty) {
			layout();
			isDirty = false;
			if (parent != null) {
				parent.isDirty = true;
			}
		}
		if (!getEnabled())
			return;
		
		g2.opacity *= renderOpacity;
		onRender(g2, opacity);
		for (c in children) {
			c.render(g2, renderOpacity);
		}
		g2.opacity = 1;
	}

	function onRender(g2:Graphics, opacity:Float) {}

	/// returns a default size
	function getPreferredSize() {
		return Vector2.zero();
	}

	public function addChild(c:Element) {
		if (children.contains(c))
			return;
		if (c == this){
			throw "Can't add self as child.";
		}
		if (c.parent != null) {
			c.parent.removeChild(c);
		}

		children.push(c);
		c.parent = this;

		if (!Std.isOfType(c.getLayoutParameters(), getChildLayoutParameterType())) {
			c.layoutParameters = createLayoutParametersForChild();
		}

		isDirty = true;

		c.setStyle(getStyle());
	}

	function removeChild(c:Element) {
		if (c.parent == this) {
			children.remove(c);
			c.parent = null;
		}
	}

	public function setDirty() {
		setDirtyAllChildren();
	}

	function setDirtyAllChildren() {
		isDirty = true;
		for (c in children) {
			c.setDirtyAllChildren();
		}
	}

	public function getRect() {
		return rect;
	}

	public function getPivot() {
		return pivot.copy();
	}

	public function setPivot(value:Vector2) {
		this.pivot = value;
	}

	function layout() {}

	public inline function getChildCount() {
		return children.length;
	}

	public function matchesQuerySelector(selector:Selector) {
		if (selector.type != null) {
			var className = std.Type.getClassName(std.Type.getClass(this));
			var packageHierarchy = className.split(".");
			if (packageHierarchy.length > 0) {
				className = packageHierarchy[packageHierarchy.length - 1];
			}
			if (selector.type != className) {
				return false;
			}
		}

		for (cl in selector.classes) {
			if (!styleClasess.contains(cl))
				return false;
		}
		if (selector.id != null) {
			if (selector.id != this.name) {
				return false;
			}
		}

		return true;
	}

	public function addStyleClass(value:String, quiet:Bool = false) {
		if (!hasStyleClass(value)) {
			styleClasess.push(value);
			if (!quiet) {
				parseStyle();
			}
		}
	}

	public function removeStyleClass(value:String, quiet:Bool = false) {
		styleClasess.remove(value);
		if (!quiet) {
			parseStyle();
		}
	}

	public function hasStyleClass(value:String) {
		return styleClasess.contains(value);
	}

	public function parseStyle() {
		if (style != null) {
			this.parsedStyle.setForElement(this);
			if (this.layoutParameters != null){
				this.layoutParameters.setValuesFromStyle(parsedStyle);
			}

			this.renderOpacity = this.parsedStyle.getFloatValue("opacity", 1);
			isDirty = true;
		}
	}

	function queryInternal(query:Selector, ofType:Class<Element>):Element {
		for (c in getChildren()) {
			if (c.matchesQuerySelector(query) && Std.isOfType(c, ofType)) {
				return c;
			} else {
				var v = c.queryInternal(query, ofType);
				if (v != null) {
					return v;
				}
			}
		}
		return null;
	}

	function queryAllInternal(query:Selector, ofType:Class<Element>):Array<Element> {
		var ret = new Array<Element>();
		for (c in getChildren()) {
			if (c.matchesQuerySelector(query) && Std.isOfType(c, ofType)) {
				ret.push(c);
			}

			var v = c.queryAllInternal(query, ofType);
			if (v != null) {
				for (i in v) {
					ret.push(i);
				}
			}
		}
		return ret;
	}

	public function query<T:Element>(query:Selector, type:Class<T>):T {
		return cast queryInternal(query, cast type);
	}

	public function queryAll<T:Class<Element>>(query:Selector, type:Class<T>):Array<T> {
		return cast queryAllInternal(query, cast type);
	}
}
