package dreamengine.plugins.dreamui.containers;

@:enum
abstract BoxChildStart(Int) from Int{
    var Begin = 0;
    var Middle = 1;
    var End = 2;

    @:from
    static function fromString(string:String){
        switch (string){
            case "begin":
                return Begin;
            case "middle":
                return Middle;
            case "end":
                return End;
        }
        return Begin;
    }
}