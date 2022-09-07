package dreamengine.plugins.renderer_2d.components;

import kha.Image;
import dreamengine.plugins.ecs.Component;

class Sprite extends Component{
    var image:Image;
    public var flip:Bool = false;
    var ppu:Float = 100;

    public function new(image:Image, ppu:Float = 100, flip = false){
        super();
        this.image = image;
        this.flip = flip;
        this.ppu = ppu;
    }

    public function getPPU(){
        return ppu;
    }
    public function getImage(){
        return image;
    }
    public function setImage(image:Image){
        this.image = image;
    }
}