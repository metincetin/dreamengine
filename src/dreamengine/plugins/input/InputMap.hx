package dreamengine.plugins.input;

import haxe.DynamicAccess;
import dreamengine.plugins.input.devices.BaseKeyboard.KeyboardKey;
import haxe.Json;

class InputMap {
	var map = new Map<String, InputDefinition>();

	public var deviceList:Array<InputDevice> = [];

	public function new() {}

	public static function fromXMLString(value:String) {
		var inputMap = new InputMap();

		var xml = Xml.parse(value);
		var root = xml.firstElement();

		for (v in root) {
			if (v.nodeType != Element)
				continue;
			if (v.nodeName != "InputDefinition") {
				throw "Elements in root should be InputDefinition in a input map";
			}

			var inputDef = new InputDefinition();
			parseInputDefinitionXML(inputDef, v);

			inputMap.map.set(inputDef.name, inputDef);
		}

		return inputMap;
	}

	static function parseInputDefinitionXML(def:InputDefinition, node:Xml) {
		var name = node.get("name");
		var type = node.get("type");

		if (name != null && name != "") {
			def.name = name;
		} else {
			throw "InputDefinition name should not be empty.";
		}
		if (type != null) {
			def.inputType = type;
		}

		for (v in node) {
			if (v.nodeType != Element)
				continue;
			var inputBinding = new InputBinding();

			if (v.exists("name")) {
				inputBinding.name = v.get("name");
			}
			if (v.exists("device")) {
				inputBinding.device = v.get("device");
			} else {
				throw "device attribute should be set for InputBinding.";
			}
			populateBinding(inputBinding, def, v);
			def.bindings.push(inputBinding);
		}
	}

	static function populateBinding(binding:InputBinding, inputDef:InputDefinition, node:Xml) {
		var type = inputDef.inputType;
		switch (type) {
			case Button:
				var keyChild = node.firstElement();
				if (keyChild == null)
					return;
				if (keyChild.nodeName != "Digital") {
					throw "InputDefinition of type Button only accepts their bindings to contain <Digital/>";
				}
				if (!keyChild.exists("key")) {
					throw "Digital requires a key.";
				}
				binding.positive = keyChild.get("key");
			case Float:
				var keyChild = node.firstChild();
				if (keyChild == null)
					return;
				if (keyChild.nodeName != "AnalogValue" || keyChild.nodeName != "DigitalValue") {
					throw("InputDefinition of type Button only accepts their bindings to contain <AnalogValue/> or <DigitalValue/>");
				}
			case Vector:
				var positiveElement = node.elementsNamed("Positive").next();
				var negativeElement = node.elementsNamed("Negative").next();
				if (positiveElement == null) {
					throw "Positive is non-existent on InputBinding.";
				}
				if (negativeElement == null) {
					throw "Negative is non-existent on InputBinding.";
				}

				var positiveKey = positiveElement.firstElement();
				var negativeKey = negativeElement.firstElement();
				if (positiveKey == null) {
					throw "Positive should contain a value.";
				}
				if (negativeKey == null) {
					throw "Negative should contain a value.";
				}
				if (!positiveKey.exists("key")) {
					throw "Requires a key.";
				}
				if (!negativeKey.exists("key")) {
					throw "Requires a key.";
				}

				// TODO the diff between analog and digital here
				binding.positive = positiveKey.get("key");
				binding.negative = negativeKey.get("key");
		}
	}

	public function begin(inputHandler:IInputHandler) {
		if (deviceList.contains(Keyboard)) {
			inputHandler.getKeyboard(0).addPressedListener(onKeyboardKeyPressed);
			inputHandler.getKeyboard(0).addReleasedListener(onKeyboardKeyReleased);
		}
	}

	function onKeyboardKeyPressed(keycode:KeyboardKey) {}

	function onKeyboardKeyReleased(keyCode:KeyboardKey) {}

	public function addEntry(name:String, entry:InputDefinition) {
		map.set(name, entry);
	}

	public function getEntry(name:String) {
		return map[name];
	}

	public function readFloat(inputName:String):Float {
		if (map.exists(inputName)) {
			return cast map[inputName].getValue();
		}
		return 0;
	}
}
