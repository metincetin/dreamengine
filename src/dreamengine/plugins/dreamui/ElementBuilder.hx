package dreamengine.plugins.dreamui;


class ElementBuilder{
    var UIBuilder:UIBuilder;
	var children = new Array<ElementBuilder>();

	var parent:ElementBuilder;
	var element:Element;


	public function new(UIBuilder:UIBuilder) {
		this.UIBuilder = UIBuilder;
        element = createElement();
	}

    function createElement():Element{
        return new Element();
    }

	public function populate(parent:Element) {
		parent.addChild(element);
		
		for (c in children) {
			c.populate(element);
		}
	}
    public function build(){
		for (c in children) {
			c.populate(element);
		}

		return element;
    }

	public function complete() {
		return UIBuilder;
	}

	public function child(element:Element) {
		var r = new ElementBuilder(UIBuilder);
		r.parent = this;
		children.push(r);
		return r;
	}

	public function getParent() {
		return parent;
	}
}