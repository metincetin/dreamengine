package dreamengine.plugins.dreamui.containers;


class ElementSwitcher extends Element {
	var currentElement = 0;

	public function setCurrentElement(value:Int) {
		currentElement = value;
		activateChild();
	}

	public function setElementByElementType<T:Class<Element>>(type:T) {
		for (i in 0...getChildCount()) {
			var element = getChild(i);
			if (Std.isOfType(element, type)) {
				setCurrentElement(i);
				return;
			}
		}
	}

	public function nextElement(shouldReturn:Bool) {
		if (shouldReturn) {
			setCurrentElement((currentElement + 1) % getChildCount());
		} else if (currentElement + 1 < getChildCount()) {
			setCurrentElement(currentElement + 1);
		}
	}

	function activateChild() {
		if (getChildCount() == 0)
			return;
		for (i in 0...getChildCount()) {
			getChild(i).visibility = i == currentElement ? Visible : Collapsed;
		}
	}

	override function addChild(c:Element) {
		super.addChild(c);
		if (getChildCount() == 1) {
			setCurrentElement(0);
		} else {
			if (getChildCount() - 1 != currentElement) {
				c.visibility = Collapsed;
			}
		}
	}
}
