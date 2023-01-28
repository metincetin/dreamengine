package dreamengine.plugins.dreamui.utils;

import haxe.xml.Parser;

class XMLBuilder {
	public static function buildTo(xml:String, parent:Element) {
		var value = Parser.parse(xml);

		var root = value.firstChild().firstElement().firstElement();

		var rootElement = tryCreateElement(root, parent);

		parseChildren(root, rootElement);
	}

	static function parseChildren(node:Xml, element:Element) {
		var children = node.elements();

		for (e in children) {
			var childElement = tryCreateElement(e, element);

			parseChildren(e, childElement);
		}
	}

	static function tryCreateElement(node:Xml, parent:Element = null) {
		var inst = cast(Type.createInstance(Type.resolveClass("dreamengine.plugins.dreamui." + node.nodeName), []), Element);

        if (parent != null){
            parent.addChild(inst);
        }

		for (attr in node.attributes()) {
			setFieldFor(inst, node, attr);
		}

		return inst;
	}

	static function setFieldFor(element:Element, node:Xml, attribute:String) {
		var rtti = haxe.rtti.Rtti.getRtti(Type.getClass(element));

		for (f in rtti.fields) {
			if (f.name == attribute) {
				switch (f.type) {
					case CClass(name, _):
						var cl = Type.resolveClass(name);
						Reflect.setField(element, attribute, tryParseValue(cl, node.get(attribute)));
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
