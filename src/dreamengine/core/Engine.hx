package dreamengine.core;

import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import haxe.Timer;
import kha.Scheduler;

import dreamengine.core.Plugin.IPlugin;
import haxe.Constraints;


class Engine{
    public var pluginContainer:PluginContainer;
    
    var version:String;
    var shouldExit = false;


    var renderEvents:Array<Function> = new Array<Function>();
    var postRenderEvents:Array<Function> = new Array<Function>();

    var loopEvents:Array<Function> = new Array<Function>();


    public function new(corePlugins: Array<IPlugin>){
        pluginContainer = new PluginContainer(this);


        trace("Initializing Engine");

        trace("Setting up core plugins");

        if (corePlugins != null){
            for (plugin in corePlugins){
                pluginContainer.addPlugin(plugin);
            }
        }

        initializeDevice();

        trace("Initializing game");
        setupMainLoop();
    }
    function initializeDevice(){
    }

    public function registerRenderEvent(event:Function){
        renderEvents.push(event);
    }

    public function unregisterRenderEvent(event:Function){
        renderEvents.remove(event);
    }

    public function registerPostRenderEvent(event:Function){
        postRenderEvents.push(event);
    }

    public function unregisterPostRenderEvent(event:Function){
        postRenderEvents.remove(event);
    }

    public function registerLoopEvent(event:Function){
        loopEvents.push(event);
    }

    public function unregisterLoopEvent(event:Function){
        loopEvents.remove(event);
    }

    function setupMainLoop(){
    }

    // executes main update loop. Returns true if game should exit
    public function mainLoop(){
        for (e in loopEvents){
            e();
        }
        Time.update();
        return false;
    }
    public function renderLoop(frameBuffers: Array<Framebuffer>){
        var frameBuffer = frameBuffers[0];
        for(e in renderEvents){
            e(frameBuffer);
        }
    }

    function finalize(){
        pluginContainer.finalize();
    }

    function loadProject(path:String){}
}