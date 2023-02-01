package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.layout_parameters.VerticalBoxLayoutParameters;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.HorizontalBoxLayoutParameters;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class VerticalBoxContainer extends Element{
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

        var selfSize = rect.getSize();
        
        var rectPos = rect.getPosition();

        for (i in 0...getChildCount()){
            var c = getChild(i);

            var size = new Vector2(32, 32);
            

            var xPos = 0.0;
            switch(c.getLayoutParametersAs(VerticalBoxLayoutParameters).horizontalAlignment){
                case Left:
                    xPos = rectPos.x + padding.left;
                case Center:
                    xPos = rectPos.x + selfSize.x * 0.5 - (padding.left - padding.right);
                case Right:
                    xPos = rectPos.x + selfSize.x - padding.right;
                case Stretch:
                    xPos = rectPos.y + padding.top;
                    size.x = selfSize.x - (padding.left + padding.right);
            }
            
            if (i == 0)
            {
                offset += padding.left;
            }

            c.rect.setSize(size);
            c.rect.setPosition(new Vector2(xPos, rectPos.y + offset));
            offset += size.y;
            offset += spacing;
        }
    }  

    override function createLayoutParametersForChild():LayoutParameters {
        return new VerticalBoxLayoutParameters();
    }
    override function getChildLayoutParameterType():Class<LayoutParameters> {
        return VerticalBoxLayoutParameters;
    }

    override function onRender(g2:Graphics, opacity:Float) {
    }
}