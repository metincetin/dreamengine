package dreamengine.plugins.dreamui.slots;

import dreamengine.core.math.Vector.Vector2;

class BaseSlot {
	var parent:Element;
	var childIndex:Int = 0;
	
	public function new(parent:Element, childIndex:Int) {
		this.parent = parent;
		this.childIndex = childIndex;
	}

	public function getParent() {
		return parent;
	}

	public function setParent(p:Element) {
		this.parent = p;
	}


	public function getChildIndex(){
		return childIndex;
	}
	public function setChildIndex(value:Int){
		this.childIndex = value;
	}

	public function getSize():Vector2 {
		return new Vector2(100, 100);
	}

	public function getPosition():Vector2 {
		return new Vector2(0, 0);
	}
}
