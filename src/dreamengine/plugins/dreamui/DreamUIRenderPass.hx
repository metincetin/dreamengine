package dreamengine.plugins.dreamui;

import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class DreamUIRenderPass extends RenderPass{
	var plugin:DreamUIPlugin;

    public function new (plugin:DreamUIPlugin){
        super();
        this.plugin = plugin;
    }

    // should consider render to cameras?
    override function execute(renderer:Renderer) {
            var screen = plugin.getScreenElement();
            if (screen != null)
            {
                var g2 = renderer.getFramebuffer().g2;
                g2.begin(false);
                screen.render(g2, 1);
                g2.end();
            }
    }
}