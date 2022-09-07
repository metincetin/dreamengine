package dreamengine.core;
using dreamengine.core.Engine;

interface IPlugin{
    public function initialize(engine:Engine): Void;
    public function finalize(): Void;
    public function getName(): String;
    public function getDependentPlugins():Array<Class<IPlugin>>;
    public function handleDependency(ofType:Class<IPlugin>):IPlugin;
}