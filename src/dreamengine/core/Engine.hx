package dreamengine.core;

import kha.math.Random;
import kha.Display;
import dreamengine.plugins.renderer_base.Mesh;
import dreamengine.plugins.renderer_2d.Renderer2D;
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

	var loopEvents:Array<Void->Void> = new Array<Void->Void>();
	var preLoopEvents:Array<Void->Void> = new Array<Void->Void>();
	var postLoopEvents:Array<Void->Void> = new Array<Void->Void>();

	var mainWindow:kha.Window;

	var mainFrameBuffer:kha.Framebuffer;

	var renderer:Renderer;

	var waitingRenderer = false;

	function new() {}

	public static function start(onStarted:Engine->Void) {
		var engine = new Engine();
		engine.pluginContainer = new PluginContainer(engine);

		trace("Initializing Engine");

		trace("Setting up Kha");
		Random.init(cast Date.now().getTime());
		kha.System.start(new SystemOptions("Dream Game", 1920, 1080), function(w) {
			var primitivesLoaded = 0;
			var quad = new Mesh();

			quad.vertices = [
				-0.5, -0.5, 0,
				-0.5,  0.5, 0,
				 0.5,  0.5, 0,
				 0.5, -0.5, 0,
			];
			quad.uvs = [
				0, 1,
				0, 0,
				1, 0,
				1, 1,
			];
			quad.indices = [
				0, 1, 2,
				2, 3, 0
			];
			quad.normals = [
				0, 0, 1,
				0, 0, 1,
				0, 0, 1,
				0, 0, 1,
			];

			quad.generate();

			Primitives.quadMesh = quad;

			Assets.loadBlob("engine_primitive_sphere_obj", x -> {
				Primitives.sphereMesh = ObjLoader.load(x);
				primitivesLoaded++;
				if (primitivesLoaded >= 4) {
					engine.onSystemStarted(w, onStarted);
				}
			});
			Assets.loadBlob("engine_primitive_cube_obj", x -> {
				Primitives.cubeMesh = ObjLoader.load(x);
				primitivesLoaded++;
				if (primitivesLoaded >= 4) {
					engine.onSystemStarted(w, onStarted);
				}
			});
			Assets.loadBlob("engine_primitive_plane_obj", x -> {
				Primitives.planeMesh = ObjLoader.load(x);

				primitivesLoaded++;
				if (primitivesLoaded >= 4) {
					engine.onSystemStarted(w, onStarted);
				}
			});
			Assets.loadBlob("engine_primitive_suzanne_obj", x -> {
				Primitives.suzanneMesh = ObjLoader.load(x);
				primitivesLoaded++;
				if (primitivesLoaded >= 4) {
					engine.onSystemStarted(w, onStarted);
				}
			});
		});
	}

	function onSystemStarted(window:Window, onStarted:Engine->Void) {
		mainWindow = window;
		trace("Setting up game loop");
		trace(Display.primary.frequency);
		Scheduler.addTimeTask(onTick, 0, 1 / 60);
		kha.System.notifyOnFrames(onFrame);

		initializeDevice();

		renderer = new Renderer();

		onStarted(this);
	}

	function initializeDevice() {
		Screen.initialize();
	}

	public function getRenderer() {
		return renderer;
	}

	public function createTimeTask(task:Void->Void, period:Float) {
		Scheduler.addTimeTask(task, 0, period);
	}

	public function registerPreLoopEvent(event:Void->Void) {
		preLoopEvents.push(event);
	}

	public function unregisterPreLoopEvent(event:Void->Void) {
		preLoopEvents.remove(event);
	}

	public function registerLoopEvent(event:Void->Void) {
		loopEvents.push(event);
	}

	public function registerPostLoopEvent(event:Void->Void) {
		postLoopEvents.push(event);
	}

	public function unregisterPostLoopEvent(event:Void->Void) {
		postLoopEvents.remove(event);
	}

	public function unregisterLoopEvent(event:Void->Void) {
		loopEvents.remove(event);
	}

	function onFrame(framebuffers:Array<kha.Framebuffer>) {
		renderer.waitingRenderer = false;
		var t = Scheduler.realTime();
		for (fr in framebuffers) {
			renderer.render(fr);
		}
		var tdiff = Scheduler.realTime() - t;
		Time.setRendererDelta(tdiff);
	}

	public function onTick() {
		for (e in preLoopEvents) {
			e();
		}
		for (e in loopEvents) {
			e();
		}
		Time.update();
		for (e in postLoopEvents) {
			e();
		}
		renderer.waitingRenderer = true;
	}

	function finalize() {
		pluginContainer.finalize();
	}

	function loadProject(path:String) {}
}
