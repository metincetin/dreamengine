package dreamengine.plugins.dreamui.layout_parameters;

class Constraints{
    var maxHeight:Float = 0;
    var minHeight:Float = 0;
    var maxWidth:Float = 0;
    var minWidth:Float = 0;

    public function new(){}
}

class LayoutParameters{
    public var constraints = new Constraints();

    public function new(){}
}