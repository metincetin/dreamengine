package dreamengine.plugins.renderer_3d.components;

import kha.Color;
import dreamengine.plugins.ecs.Component;

class Light extends Component {
	public var intensity:Float;
	public var color:Color;

	public function new(color:Color = Color.White, intensity:Float = 1) {
		super();
		this.color = color;
		this.intensity = intensity;
	}
}
