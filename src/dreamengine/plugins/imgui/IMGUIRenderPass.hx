package dreamengine.plugins.imgui;

import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class IMGUIRenderPass extends RenderPass{
    override function execute(renderer:Renderer) {
        for (c in renderer.cameras){
            var g2 = c.getRenderTarget().g2;

            g2.begin(false);
            for(r in RenderStack.renderers){
                r.render(g2);
            }

            g2.end();
        }

        RenderStack.clear();
    }
}