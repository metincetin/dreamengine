package dreamengine.plugins.input.devices;

import haxe.io.Bytes;
import haxe.Constraints;
import dreamengine.core.math.Vector.Vector2i;

class BaseMouse implements IPointer implements IKeyDevice {
	public var index:Int;

	var pointerPosition = new Vector2i();
	var pointerDelta = new Vector2i();

	var keyPressed:Map<Int, Array<Void->Void>> = new Map<Int, Array<Void->Void>>();
	var keyReleased:Map<Int, Array<Void->Void>> = new Map<Int, Array<Void->Void>>();
	var deltaChanged:Array<Vector2i->Void> = new Array<Vector2i->Void>();

	public function new(index:Int) {
		this.index = index;
	}

	public function getPointerPosition():Vector2i {
		return pointerPosition;
	}

	public function getPointerDelta():Vector2i {
		return pointerDelta;
	}

	public function addKeyPressedListener(key:Int, f:Void->Void) {
		if (!keyPressed.exists(key)) {
			keyPressed.set(key, new Array());
		}
		keyPressed.get(key).push(f);
	}

	public function removeKeyPressedListener(f:Void->Void) {
		var t = -1;
		for (v in keyReleased.keyValueIterator()) {
			if (v.value.contains(f)) {
				t = v.key;
				break;
			}
		}
		if (t != -1) {
			keyPressed.get(t).remove(f);
		}
	}

	public function addDeltaChangedListener(f:Vector2i->Void) {
		deltaChanged.push(f);
	}

	public function removeDeltaChangedListener(f:Vector2i->Void) {
		deltaChanged.remove(f);
	}

	public function addKeyReleasedListener(key:Int, f:Void->Void) {
		if (!keyReleased.exists(key)) {
			keyReleased.set(key, new Array());
		}
		keyReleased.get(key).push(f);
	}

	public function removeKeyReleasedListener(f:Void->Void) {
		var t = -1;
		for (v in keyReleased.keyValueIterator()) {
			if (v.value.contains(f)) {
				t = v.key;
				break;
			}
		}
		if (t != -1) {
			keyReleased.get(t).remove(f);
		}
	}

	public function isKeyPressed(key:Int):Bool {
		return false;
	}
}
