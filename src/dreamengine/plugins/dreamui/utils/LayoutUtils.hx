package dreamengine.plugins.dreamui.utils;

import dreamengine.core.math.Vector2;

class LayoutUtils{
    public static function getPivotOffset(element:Element){
        var size = element.getRect().getSize();
        var pivot = element.getPivot();

        var pivotOffset = new Vector2();

        pivotOffset.x = -size.x * pivot.x;
        pivotOffset.y = -size.y * pivot.y;

        return pivotOffset;
    }

}