package dreamengine.core;

import dreamengine.plugins.renderer_3d.passes.RenderSkybox;
import dreamengine.plugins.dreamui.events.IFocusable;
import kha.System;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.renderer_3d.components.Light;
import dreamengine.plugins.renderer_3d.passes.RenderShadows;
import dreamengine.plugins.renderer_base.Material;
import dreamengine.plugins.renderer_3d.passes.RenderOpaques;
import kha.Scaler;
import kha.Framebuffer;
import dreamengine.plugins.renderer_base.components.Camera;
import dreamengine.plugins.renderer_base.*;

class Renderer{
    public var opaques:Array<Renderable> = [];
    public var transparents:Array<Renderable> = [];
    public var cameras:Array<Camera> = [];
    public var lights:Array<LightData> = [];
    public var pipeline:Array<RenderPass> = [];

    var opaqueIndex = 0;
    var transparentIndex = 0;
    var cameraIndex = 0;
    var lightIndex = 0;

    var framebuffer:Framebuffer;
	public var waitingRenderer:Bool;


    public function new(){
        Material.setDefault(new Material(kha.Shaders.simple_vert, kha.Shaders.simple_frag));
    }

    public function getFramebuffer(){ return framebuffer; }

    public function render(framebuffer:Framebuffer){
        this.framebuffer = framebuffer;
        for(c in cameras){
            var g = c.getRenderTarget().g4;
            g.begin();
            g.clear(Transparent, 1);
            g.end();
        }

        framebuffer.g2.begin();
        framebuffer.g2.clear();
        framebuffer.g2.end();

        for(p in pipeline){
            p.execute(this);
        }

        framebuffer.g2.begin(false);

        for(c in cameras){
            Scaler.scale(c.getRenderTarget(), framebuffer, kha.System.screenRotation);
        }
        framebuffer.g2.end();

        opaqueIndex = 0;
        transparentIndex = 0;
        cameraIndex = 0;
        lightIndex = 0;
    }

    public function addOpaque(renderable:Renderable){
        if (waitingRenderer) return;
        opaques[opaqueIndex] = renderable;
        opaqueIndex++;
    }

    public function setCamera(camera:Camera) {
        if (waitingRenderer) return;
        cameras[cameraIndex] = camera;
        cameraIndex++;
    }

    public function addLight(light:LightData) {
        if (waitingRenderer) return;
        lights[lightIndex] = light;
        lightIndex++;
    }

    public function addTransparent(renderable: Renderable) {
        if (waitingRenderer) return;
        transparents[transparentIndex] = renderable;
        transparentIndex++;
    }
}