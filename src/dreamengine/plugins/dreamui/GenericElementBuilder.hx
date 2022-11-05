package dreamengine.plugins.dreamui;

import dreamengine.plugins.dreamui.slots.BaseSlot;

class GenericElementBuilder extends ElementBuilder{
	public static function create(element:Element){
		var r = new ElementBuilder(UIBuilder);
		r.element = element;
		return r;
	}
}
