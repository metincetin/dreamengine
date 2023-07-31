package dreamengine.plugins.renderer_base.components;

import dreamengine.plugins.ecs.Component;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;

class Material extends Component {
	var fragmentShader:FragmentShader;
	var vertexShader:VertexShader;

	public function new(vShader:VertexShader, fShader:FragmentShader) {
		super();
		this.fragmentShader = fShader;
		this.vertexShader = vShader;
	}

	public function getVertexShader() {
		return vertexShader;
	}

	public function setVertexShader(value:VertexShader) {
		vertexShader = value;
	}

	public function getFragmentShader() {
		return fragmentShader;
	}

	public function setFragmentShader(value:FragmentShader) {
		fragmentShader = value;
	}
}
