package dreamengine.core;

import dreamengine.plugins.renderer_3d.components.Mesh;
import dreamengine.plugins.renderer_3d.loaders.ObjLoader;
import dreamengine.plugins.renderer_3d.Primitives;
import dreamengine.device.Screen;
import kha.FramebufferOptions;
import kha.WindowOptions;
import kha.Window;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import haxe.Timer;
import kha.Scheduler;
import dreamengine.core.Plugin.IPlugin;
import haxe.Constraints;

class Engine {
	public var pluginContainer:PluginContainer;

	var version:String;
	var shouldExit = false;

	var renderEvents:Array<Framebuffer->Void> = new Array<Framebuffer->Void>();
	var postRenderEvents:Array<Framebuffer->Void> = new Array<Framebuffer->Void>();

	var loopEvents:Array<Void->Void> = new Array<Void->Void>();
	var postLoopEvents:Array<Void->Void> = new Array<Void->Void>();

	var mainWindow:kha.Window;

	var mainFrameBuffer:kha.Framebuffer;

	function new(){

	}

	public static function start(onStarted: Engine->Void) {
		var engine = new Engine();
		engine.pluginContainer = new PluginContainer(engine);

		trace("Initializing Engine");

		trace("Setting up Kha");
		kha.System.start(new SystemOptions("Dream Game", 1344, 756), function(w){ engine.onSystemStarted(w, onStarted);});
		Assets.loadBlob("engine_primitive_sphere_obj", x->{Primitives.sphereMesh= ObjLoader.load(x.toString());});
		Assets.loadBlob("engine_primitive_cube_obj", x->{Primitives.cubeMesh = ObjLoader.load(x.toString());});
		Assets.loadBlob("engine_primitive_plane_obj", x->{Primitives.planeMesh = ObjLoader.load(x.toString());});
		Assets.loadBlob("engine_primitive_suzanne_obj", x->{Primitives.suzanneMesh = ObjLoader.load(x.toString());});
	}

	function onSystemStarted(window:Window, onStarted: Engine->Void) {
		mainWindow = window;
		trace("Setting up game loop");
		Scheduler.addTimeTask(onTick, 0, 1 / 60);
		kha.System.notifyOnFrames(onFrame);

		initializeDevice();

		onStarted(this);
	}

	function initializeDevice() {
		Screen.initialize();
	}

	public function createTimeTask(task:Void->Void, period:Float){
		Scheduler.addTimeTask(task,0, period);
	}

	public function registerRenderEvent(event:Framebuffer->Void) {
		renderEvents.push(event);
	}

	public function unregisterRenderEvent(event:Framebuffer->Void) {
		renderEvents.remove(event);
	}

	public function registerPostRenderEvent(event:Framebuffer->Void) {
		postRenderEvents.push(event);
	}

	public function unregisterPostRenderEvent(event:Framebuffer->Void) {
		postRenderEvents.remove(event);
	}

	public function registerLoopEvent(event:Void->Void) {
		loopEvents.push(event);
	}
	public function registerPostLoopEvent(event:Void->Void){
		postLoopEvents.push(event);
	}
	public function unregisterPostLoopEvent(event:Void->Void){
		postLoopEvents.remove(event);
	}

	public function unregisterLoopEvent(event:Void->Void) {
		loopEvents.remove(event);
	}

	function onFrame(framebuffers:Array<kha.Framebuffer>) {
		if (framebuffers.length == 0)
			return;
		mainFrameBuffer = framebuffers[0];
		onRender();
	}

	// executes main update loop. Returns true if game should exit
	public function onTick() {
		for (e in loopEvents) {
			e();
		}
		Time.update();
		for(e in postLoopEvents){
			e();
		}
		return false;
	}

	function onRender() {
		if (mainFrameBuffer == null)
			return;
		
		for (e in renderEvents) {
			e(mainFrameBuffer);
		}
		Gizmos.render(mainFrameBuffer);
	}

	function finalize() {
		pluginContainer.finalize();
	}

	function loadProject(path:String) {}
}
