package dreamengine.plugins.haxeui;

import haxe.ui.styles.CompositeStyleSheet;
import haxe.ui.styles.StyleSheet;
import haxe.ui.Toolkit;
import haxe.ui.util.Color;
import haxe.ui.core.Component;
import kha.Assets;
import haxe.ui.macros.ComponentMacros;
import dreamengine.core.Engine;
import dreamengine.core.Plugin.IPlugin;

class HaxeUIPlugin implements IPlugin{
    
    public function new(){}

    var screen:haxe.ui.core.Screen;
    var root:Component;

    public function getRoot(){
        return root;
    }

    public function setStyle(css:String){
        var styleSheet = new CompositeStyleSheet();
        var s = new StyleSheet();
        s.parse(css);
        
        styleSheet.addStyleSheet(s);
        Toolkit.styleSheet = styleSheet;
        trace(s);
    }

	public function initialize(engine:Engine) {
        haxe.ui.Toolkit.init();
        screen = haxe.ui.core.Screen.instance;
        
        root = new Component();
        root.percentWidth = 100;
        root.percentHeight = 100;

        screen.addComponent(root);
        
        engine.registerRenderEvent(onRender);
    }

    function onRender(g2){
        screen.renderTo(g2);
    }

	public function finalize() {}

	public function getName():String {
        return "haxeui";
    }

	public function getDependentPlugins():Array<Class<IPlugin>> {
        return [];
    }

	public function handleDependency(ofType:Class<IPlugin>):IPlugin {
        return null;
    }
}