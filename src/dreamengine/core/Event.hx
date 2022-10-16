package dreamengine.core;

@:notNull
class Event {
	public function new() {}

	var listeners:Array<Void->Void> = [];

	public function addListener(v:Void->Void) {
		listeners.push(v);
	}

	public function removeListener(v:Void->Void) {
		listeners.remove(v);
	}

	public function invoke() {
		for (e in listeners) {
			e();
		}
	}
}

@:generic
class Event1<T> {
	var listeners:Array<T->Void> = [];

	public function addListener(v:T->Void) {
		listeners.push(v);
	}

	public function removeListener(v:T->Void) {
		listeners.remove(v);
	}

	public function invoke(v:T) {
		for (e in listeners) {
			e(v);
		}
	}
}

@:generic
class Event2<T, V> {}

@:generic
class Event3<T, V, U> {}
