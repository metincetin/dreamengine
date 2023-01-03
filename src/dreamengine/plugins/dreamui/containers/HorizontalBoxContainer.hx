package dreamengine.plugins.dreamui.containers;

import kha.graphics2.Graphics;
import dreamengine.plugins.dreamui.layout_parameters.CanvasLayoutParameters;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.HorizontalBoxLayoutParameters;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class HorizontalBoxContainer extends Element{
    var spacing = 0.0;
    var padding = Dimension.allSides(12);

    public function getSpacing(){
        return spacing;
    }

    public function setSpacing(value:Float){
        spacing = value;
        isDirty = true;
    }
    

    override function layout() {

        var offset = 0.0;

        var selfSize = rect.size;
        for (i in 0...getChildCount()){
            var c = getChild(i);

            var size = new Vector2(32, 32);
            
            var yPos = 0.0;
            switch(c.getLayoutParametersAs(HorizontalBoxLayoutParameters).verticalAlignment){
                case Top:
                    yPos = rect.position.y + padding.top;
                case Center:
                    yPos = rect.position.y + selfSize.y * 0.5 - (padding.top - padding.bottom);
                case Bottom:
                    yPos = rect.position.y + selfSize.y - padding.bottom;
                case Stretch:
                    yPos = rect.position.y + padding.top;
                    size.y = selfSize.y - (padding.bottom + padding.top);
            }
            
            if (i == 0)
            {
                offset += padding.left;
            }

            c.rect.size = size;
            c.rect.position = new Vector2(rect.position.x + offset, yPos);
            offset += size.x;
            offset += spacing;
        }
    }  

    override function createLayoutParametersForChild():LayoutParameters {
        return new HorizontalBoxLayoutParameters();
    }
    override function getChildLayoutParameterType():Class<LayoutParameters> {
        return HorizontalBoxLayoutParameters;
    }

    override function onRender(g2:Graphics, opacity:Float) {
    }
}