package dreamengine.plugins.renderer_base.components;

import dreamengine.core.math.Quaternion;
import kha.math.FastMatrix2;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.FastMatrix4;
import dreamengine.core.math.Mathf;
import dreamengine.core.math.Vector3;
import dreamengine.plugins.ecs.Component;

class Transform extends Component {
	var position:Vector3 = Vector3.zero();
	var rotation:Quaternion = Quaternion.identity();
	var scale:Vector3 = Vector3.one();

	public var worldMatrix:FastMatrix4 = FastMatrix4.identity();
	public var localMatrix:FastMatrix4 = FastMatrix4.identity();

	public static function fromPosition(x:Float = 0, y:Float = 0, z:Float = 0) {
		var t = new Transform();
		t.position = new Vector3(x, y, z);
		t.updateMatrix();
		return t;
	}

	public static function prs(position:Vector3, rotation:Quaternion, scale:Vector3) {
		var t = new Transform();
		t.position = position;
		t.rotation = rotation;
		t.scale = scale;
		t.updateMatrix();
		return t;
	}

	public function getForward():Vector3 {
		var q = getRotation();
		var ret = new Vector3(2.0 * (q.x * q.z - q.w * q.y), 2.0 * (q.y * q.z + q.w * q.x), 1.0 - 2.0 * (q.x * q.x + q.y * q.y));
		ret.normalize();
		return ret;
	}

	public function getRight():Vector3 {
		var q = getRotation();
		var ret = new Vector3(1 - 2 * (q.y * q.y + q.z * q.z), 2 * (q.x * q.y - q.w * q.z), 2 * (q.x * q.z + q.w * q.y));
		ret.normalize();
		return ret;
	}

	public function getUp():Vector3 {
		var q = getRotation();
		var ret = new Vector3(2.0 * (q.x * q.y + q.w * q.z),
                1.0 - 2.0 * (q.x * q.x + q.z * q.z),
                2.0 * (q.y * q.z - q.w * q.x));
		ret.normalize();
		return ret;
	}

	public function getPosition():Vector3 {
		return position.copy();
	}

	public function setPosition(value:Vector3) {
		position = value;
		updateMatrix();
	}

	public function translate(value:Vector3) {
		position.x += value.x;
		position.y += value.y;
		position.z += value.z;
		updateMatrix();
	}

	public function getRotation():Quaternion {
		return rotation;
	}

	public function setRotation(value:Quaternion) {
		this.rotation = value;
		updateMatrix();
	}

	public function setEulerAngles(value:Vector3) {
		this.rotation = Quaternion.fromEuler(value);
		updateMatrix();
	}

	public function rotate(axis:Vector3, angle:Float) {
		var v = rotation.multipliedV(axis * angle);
		setRotation(v);
	}

	public function getScale():Vector3 {
		return scale;
	}

	public function setScale(value:Vector3) {
		scale.x = value.x;
		scale.y = value.y;
		scale.z = value.z;
		updateMatrix();
	}

	function updateMatrix() {

		var trMatrix = FastMatrix4.translation(position.x, position.y, position.z);
		var rotMatrix = rotation.toMatrix();
		var scaleMatrix = FastMatrix4.scale(scale.x, scale.y, scale.z);

		localMatrix = trMatrix.multmat(rotMatrix).multmat(scaleMatrix);
	}
}
