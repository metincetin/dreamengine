package dreamengine.plugins.renderer_base.components;

import kha.graphics4.TextureFormat;
import dreamengine.device.Screen;
import kha.Image;
import dreamengine.core.math.Vector.Vector3;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import dreamengine.core.math.Vector.Vector2;
import dreamengine.plugins.ecs.Entity;
import dreamengine.plugins.ecs.Component.Component;

class Camera extends Component {
	public var projection:Projection;
	public var fov:Float;
	public var aspect:Float;
	public var size:Float;
	public var clippingPlanes:Vector2;

	public var renderTexture:Image;
	public var depthTexture:Image;

	var projectionMatrix:FastMatrix4;
	var viewMatrix:FastMatrix4;

	public var msaa:Int = 0;

	public function new() {
		super();
	}

	public static function perspective(fov:Float, aspect:Float, clippingPlanes:Vector2):Camera {
		var cam = new Camera();
		cam.aspect = aspect;
		cam.fov = fov;
		cam.projection = Perspective;
		cam.clippingPlanes = clippingPlanes;
		cam.projectionMatrix = FastMatrix4.perspectiveProjection(fov, aspect, clippingPlanes.x, clippingPlanes.y);
		return cam;
	}

	public static function orthogonal(size:Float, clippingPlanes:Vector2):Camera {
		var cam = new Camera();
		cam.size = size;
		cam.clippingPlanes = clippingPlanes;
		cam.projection = Orthographic;
		cam.projectionMatrix = FastMatrix4.orthogonalProjection(-size, size, -size, size, clippingPlanes.x, clippingPlanes.y);
		return cam;
	}

	public function getViewMatrix() {
		return viewMatrix;
	}

	public function getProjectionMatrix():FastMatrix4 {
		return projectionMatrix;
	}

	public function getViewProjectionMatrix():FastMatrix4 {
		var vp = projectionMatrix;
		vp = vp.multmat(viewMatrix);
		return vp;
	}

	public function setViewMatrix(view:FastMatrix4) {
		this.viewMatrix = view;
	}

	override function onAdded(entity:Entity) {
		ActiveCamera.registerCamera(this, cast entity.getComponent(Transform));

		createRenderTexture();
	}

	override function onRemoved(entity:Entity) {
		ActiveCamera.unregisterCamera(this, cast entity.getComponent(Transform));
		renderTexture.unload();
	}

	function createRenderTexture() {
		var res = Screen.getResolution();
		renderTexture = Image.createRenderTarget(Std.int(res.x * 1), Std.int(res.y * 1), TextureFormat.RGBA128, DepthAutoStencilAuto, 1);
	}

	public function isInsideView(point: Vector3): Bool{
		return true;
	}
}

enum Projection {
	Perspective;
	Orthographic;
}
