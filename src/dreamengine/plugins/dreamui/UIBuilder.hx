package dreamengine.plugins.dreamui;

class UIBuilder{
    var elements = new Array<ElementBuilder>();

    function new(){}

    public static function create(){
        return new UIBuilder();
    }

    public function addElement(element:Element){
        var builder = new ElementBuilder(this);
        elements.push(builder);
        return builder;
    }


    public function build(parent:Element){
        for (c in elements){
            c.populate(parent);
        }
    }
}