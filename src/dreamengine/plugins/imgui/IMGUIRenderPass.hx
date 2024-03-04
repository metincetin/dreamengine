package dreamengine.plugins.imgui;

import dreamengine.core.Renderer;
import dreamengine.core.RenderPass;

class IMGUIRenderPass extends RenderPass{
    @:allow(dreamengine.plugins.imgui.IMGUIPlugin)
    @:allow(dreamengine.plugins.imgui.RenderStack)
    static var waitingRenderer = false;
    override function execute(renderer:Renderer) {
        waitingRenderer = false;
        for (c in renderer.cameras){
            var g2 = c.getRenderTarget().g2;

            g2.begin(false);

            g2.color = IMGUI.color;
            g2.fontSize = IMGUI.fontSize;

            for(r in RenderStack.renderers){
                r.render(g2);
            }

            g2.end();
        }

    }
}