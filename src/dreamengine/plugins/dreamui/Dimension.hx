package dreamengine.plugins.dreamui;

class Dimension {
    public var left = 0.0;
    public var right = 0.0;
    public var top = 0.0;
    public var bottom = 0.0;

    public function new(){}

    public static function allSides(value:Float){
        var dim = new Dimension();
        dim.left = value;
        dim.right = value;
        dim.top = value;
        dim.bottom = value;
        return dim;
    }
}