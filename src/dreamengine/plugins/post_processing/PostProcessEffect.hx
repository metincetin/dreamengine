package dreamengine.plugins.post_processing;

import kha.Image;
import kha.graphics4.FragmentShader;

class PostProcessEffect {
	
    var shader: FragmentShader;
    public function new(shader:FragmentShader) {
		this.shader = shader;
	}

    public function execute(img:Image){}
}
