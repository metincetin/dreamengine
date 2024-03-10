package dreamengine.plugins.ecs;

class FunctionSystem extends System{
    var func:ECSContext->Void;
    public function new(f:ECSContext->Void){
        super();
        func = f;
    }

    override function execute(ctx:ECSContext) {
        func(ctx);
    }
}