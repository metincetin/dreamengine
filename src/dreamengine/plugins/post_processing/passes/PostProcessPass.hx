package dreamengine.plugins.post_processing.passes;

import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class PostProcessPass extends RenderPass{
    var plugin:PostProcessPlugin;

    public function new (plugin:PostProcessPlugin){
        super();
        this.plugin = plugin;
    }


    override function execute(renderer:Renderer) {
        for(cam in renderer.cameras){
            var stack = plugin.getStack();
            if (stack != null)
                stack.render(cam.getRenderTarget());
        }
    }

}