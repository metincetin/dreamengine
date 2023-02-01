package dreamengine.plugins.dreamui.layout_parameters;

enum HorizontalAlignment{
    Left;
    Center;
    Right;
    Stretch;
}

class VerticalBoxLayoutParameters extends LayoutParameters{
    public var horizontalAlignment:HorizontalAlignment = Stretch;
}