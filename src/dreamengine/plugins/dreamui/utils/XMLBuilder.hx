package dreamengine.plugins.dreamui.utils;

import haxe.exceptions.ArgumentException;
import haxe.xml.Parser;

class XMLBuilder {
	public static function build(xml:String, parent:Element = null){
		var value = Parser.parse(xml);

		var root = value.firstChild().firstElement().firstElement();

		var rootElement = tryCreateElement(root, parent);

		parseChildren(root, rootElement);

		return rootElement;
	}

	static function parseChildren(node:Xml, element:Element) {
		var children = node.elements();

		for (e in children) {
			var childElement = tryCreateElement(e, element);

			parseChildren(e, childElement);
		}
	}

	static function tryCreateElement(node:Xml, parent:Element = null) {
		var type = UIXMLElementTypes.getType(node.nodeName);
		if (type == null){
			throw new ArgumentException("Incorrect ElementType", 'given type ${node.nodeName} not found. Register it with UIXMLElementTypes.registerType');
		}

		var inst = cast(Type.createInstance(type, []), Element);
        if (parent != null){
            parent.addChild(inst);
        }

		for (attr in node.attributes()) {
			setFieldFor(inst, node, attr);
		}

		inst.parseStyle();
		return inst;
	}

	static function setFieldFor(element:Element, node:Xml, attribute:String) {
		var rtti = haxe.rtti.Rtti.getRtti(Type.getClass(element));

		if (attribute == "class"){
			var classList = node.get(attribute).split(" ");
			for (c in classList){
				element.addStyleClass(c, false);
			}
		}
		if (attribute == "id"){
			element.name = node.get(attribute);
		}

		for (f in rtti.fields) {
			if (f.name == attribute) {
				switch (f.type) {
					case CClass(name, _):
						var cl = Type.resolveClass(name);
						Reflect.setField(element, attribute, tryParseValue(cl, node.get(attribute)));
					case CEnum(name, _):
						Reflect.setField(element, attribute, Std.parseInt(node.get(attribute)));
					case _:
				}
			}
		}
	}

	static function tryParseValue(cl:Class<Dynamic>, valueString:String):Dynamic {
        switch(cl){
            case Int:
                return Std.parseInt(valueString);
            case Float:
                return Std.parseFloat(valueString);
            case String:
                return valueString;
        }
        return null;
    }
}
