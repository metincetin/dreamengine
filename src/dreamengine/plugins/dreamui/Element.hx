package dreamengine.plugins.dreamui;

import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;
import dreamengine.core.math.Rect;
import dreamengine.core.math.Vector.Vector2;
import kha.graphics2.Graphics;

class Element {
	public var name = "";

	public var parent:Element;

	var children:Array<Element> = new Array<Element>();

	var isDirty = false;

	var layoutParameters = new LayoutParameters();

	var localScale:Vector2 = Vector2.one();

	var enabled:Bool = true;

	var renderOpacity:Float = 1;

	var rect:Rect = new Rect();

	public function getEnabled() {
		return enabled;
	}

	public function setEnabled(value:Bool) {
		enabled = value;
		for (c in children) {
			c.setEnabled(value);
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

	function getChildLayoutParameterType():Class<LayoutParameters>{
		return LayoutParameters;
	}

	function createLayoutParametersForChild(): LayoutParameters{
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
		return Vector2.multiplyV(localScale, parent.getScale());
	}

	public function new() {}

	public function getIsDirty() {
		return isDirty;
	}

	public final function render(g2:Graphics, opacity:Float) {
		if (isDirty){
			layout();
			isDirty = false;
		}
		if (!getEnabled())
			return;
		g2.opacity = opacity * renderOpacity;
		onRender(g2, opacity);
		for (c in children) {
			c.render(g2, renderOpacity);
		}
		g2.opacity = 1;
	}

	function onRender(g2:Graphics, opacity:Float) {}

	public function addChild(c:Element) {
		if (children.contains(c))
			return;

		children.push(c);
		c.parent = c;

		if (!Std.isOfType(c.getLayoutParameters(), getChildLayoutParameterType())) {
			c.layoutParameters = createLayoutParametersForChild();
		}
		
		isDirty = true;
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

	function layout(){}

	public inline function getChildCount() {
		return children.length;
	}

	public function getPreferredSize(): Vector2{
		return Vector2.zero();
	}
}
