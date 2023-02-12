package dreamengine.plugins.dreamui.containers;

import dreamengine.plugins.dreamui.layout_parameters.VerticalBoxLayoutParameters;
import kha.graphics2.Graphics;
import dreamengine.core.math.Vector2;
import dreamengine.plugins.dreamui.layout_parameters.HorizontalBoxLayoutParameters;
import dreamengine.plugins.dreamui.layout_parameters.LayoutParameters;

class VerticalBoxContainer extends Element{
    var spacing = 0.0;
    var padding = Dimension.allSides(12);

    

    var prefSize = new Vector2();

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

            var size = c.getPreferredSize();
            

            
            var pivotOffset = size * c.pivot; 
            var xPos = 0.0;

            switch(c.getLayoutParametersAs(VerticalBoxLayoutParameters).horizontalAlignment){
                case Left:
                    xPos = rectPos.x + padding.left - pivotOffset.x;
                case Center:
                    xPos = rectPos.x + selfSize.x * 0.5 - pivotOffset.x - (padding.left - padding.right);
                case Right:
                    xPos = rectPos.x + selfSize.x - padding.right - pivotOffset.x;
                case Stretch:
                    xPos = rectPos.y + padding.top;
                    size.x = selfSize.x - (padding.left + padding.right);
            }
            
            if (i == 0)
            {
                offset += padding.top;
                offset += pivotOffset.y;
            }


            c.rect.setSize(size);
            c.rect.setPosition(new Vector2(xPos, rectPos.y - pivotOffset.y + offset));
            offset += size.y * pivot.y;
            offset += spacing;
        }

        prefSize.y = offset;

        parent.isDirty = true;
    }  

    override function getPreferredSize():Vector2 {
        return prefSize;
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