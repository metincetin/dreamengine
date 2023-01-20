package dreamengine.core;

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

	var mainWindow:kha.Window;

	var mainFrameBuffer:kha.Framebuffer;

	public function new() {
		pluginContainer = new PluginContainer(this);

		trace("Initializing Engine");

		trace("Setting up Kha");
		kha.System.start(new SystemOptions("Dream Game", 800, 400), onSystemStarted);
	}

	function onSystemStarted(window:Window) {
		mainWindow = window;
		kha.System.notifyOnFrames(onFrame);
		trace("Setting up game loop");
		Scheduler.addTimeTask(onTick, 0, 1 / 60);
		Scheduler.addFrameTask(onRender, 0);

		initializeDevice();
	}

	function initializeDevice() {}

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

	public function unregisterLoopEvent(event:Void->Void) {
		loopEvents.remove(event);
	}

	function onFrame(framebuffers:Array<kha.Framebuffer>) {
		if (framebuffers.length == 0)
			return;
		mainFrameBuffer = framebuffers[0];
	}

	// executes main update loop. Returns true if game should exit
	public function onTick() {
		for (e in loopEvents) {
			e();
		}
		Time.update();
		return false;
	}

	function onRender() {
		if (mainFrameBuffer == null)
			return;
		
		for (e in renderEvents) {
			e(mainFrameBuffer);
		}
	}

	function finalize() {
		pluginContainer.finalize();
	}

	function loadProject(path:String) {}
}
