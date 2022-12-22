package dreamengine.plugins.dreamui.layout_parameters;

enum VerticalAlignment{
    Top;
    Center;
    Bottom;
    Stretch;
}

class HorizontalBoxLayoutParameters extends LayoutParameters{
    public var verticalAlignment:VerticalAlignment = Stretch;
}