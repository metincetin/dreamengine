package dreamengine.core;

import kha.System;
import dreamengine.plugins.renderer_3d.components.DirectionalLight;
import dreamengine.plugins.renderer_3d.components.Light;
import dreamengine.plugins.renderer_3d.passes.RenderShadows;
import dreamengine.plugins.renderer_base.Material;
import dreamengine.plugins.renderer_3d.passes.RenderOpaques;
import kha.Scaler;
import kha.Framebuffer;
import dreamengine.plugins.renderer_base.components.Camera;

class Renderer{
    public var opaques:Array<Renderable> = [];
    public var transparents:Array<Renderable> = [];
    public var cameras:Array<Camera> = [];
    public var lights:Array<Light> = [];
    public var pipeline:Array<RenderPass> = [];


    var opaqueIndex = 0;
    var cameraIndex = 0;
    var lightIndex = 0;

    var framebuffer:Framebuffer;

    public function new(){
        Material.setDefault(new Material(kha.Shaders.simple_vert, kha.Shaders.simple_frag));
        pipeline.push(new RenderOpaques());
        pipeline.push(new RenderShadows());
    }

    public function getFramebuffer(){ return framebuffer; }

    public function render(framebuffer:Framebuffer){
        this.framebuffer = framebuffer;
        for(c in cameras){
            var g = c.getRenderTarget().g2;
            g.begin();
            g.clear(Blue);
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
        cameraIndex = 0;
        lightIndex = 0;
    }

    public function addOpaque(renderable:Renderable){
        opaques[opaqueIndex] = renderable;
        opaqueIndex++;
    }

    public function setCamera(camera:Camera) {
        cameras[cameraIndex] = camera;
        cameraIndex++;
    }

    public function addLight(light:Light) {
        lights[lightIndex] = light;
        lightIndex++;
    }
}