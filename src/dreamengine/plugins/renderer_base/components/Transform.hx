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
		throw("Not implemented");
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

		var rot = rotation.toEuler();

		var m = FastMatrix4.identity();
		// m = m.multmat(FastMatrix4.rotation(rotation.x, rotation.y, rotation.z));
		m = m.multmat(FastMatrix4.scale(scale.x, scale.y, scale.z));
		m = m.multmat(FastMatrix4.rotation(Mathf.degToRad(rot.x), Mathf.degToRad(rot.y), Mathf.degToRad(rot.z)));
		m = m.multmat(FastMatrix4.translation(position.x, -position.y, position.z));
		// var m = FastMatrix4.rotation(Mathf.degToRad(rotation.x), Mathf.degToRad(rotation.y), Mathf.degToRad(rotation.z));
		// // m = m.multmat(FastMatrix4.scale(scale.x, scale.y, scale.z));

		// m._00 *= scale.x;
		// m._01 *= scale.x;
		// m._02 *= scale.x;
		// m._03 *= scale.x;
		// m._10 *= scale.y;
		// m._11 *= scale.y;
		// m._12 *= scale.y;
		// m._13 *= scale.y;
		// m._20 *= scale.z;
		// m._21 *= scale.z;
		// m._22 *= scale.z;
		// m._23 *= scale.z;

		// m._30 = position.x;
		// m._31 = position.y;
		// m._32 = position.z;

		localMatrix = m;
	}
}
