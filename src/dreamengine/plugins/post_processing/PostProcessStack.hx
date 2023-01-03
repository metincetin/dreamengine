package dreamengine.plugins.post_processing;

import kha.Image;


class PostProcessStack{
    var effects = new Array<PostProcessEffect>();

    public function new(...rest:PostProcessEffect){
        for (e in rest){
            effects.push(e);
        }
    }

    public function render(img:Image){
        for(eff in effects){
            eff.execute(img);
        }
    }
}