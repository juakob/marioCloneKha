package ;

import kha.math.Quaternion;
import kha.math.Matrix4;

class QuaternionExt {

	@:extern
	static public inline function fromRotationMat(q:Quaternion, m:Matrix4){
		
		// Assumes the upper 3x3 is a pure rotation matrix
		var m11 = m._00, m12 = m._10, m13 = m._20;
		var m21 = m._01, m22 = m._11, m23 = m._21;
		var m31 = m._02, m32 = m._12, m33 = m._22;

		var tr = m11 + m22 + m33;
		var s = 0.0;

		if (tr > 0) {
			s = 0.5 / Math.sqrt(tr + 1.0);
			q.w = 0.25 / s;
			q.x = (m32 - m23) * s;
			q.y = (m13 - m31) * s;
			q.z = (m21 - m12) * s;
		}
		else if (m11 > m22 && m11 > m33) {
			s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);
			q.w = (m32 - m23) / s;
			q.x = 0.25 * s;
			q.y = (m12 + m21) / s;
			q.z = (m13 + m31) / s;
		}
		else if (m22 > m33) {
			s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);
			q.w = (m13 - m31) / s;
			q.x = (m12 + m21) / s;
			q.y = 0.25 * s;
			q.z = (m23 + m32) / s;
		}
		else {
			s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);
			q.w = (m21 - m12) / s;
			q.x = (m13 + m31) / s;
			q.y = (m23 + m32) / s;
			q.z = 0.25 * s;
		}


		return q;
	}

	@:extern
	static public inline function setFrom(q:Quaternion, quat:Quaternion){
		q.x = quat.x;
		q.y = quat.y;
		q.z = quat.z;
		q.w = quat.w;
	}
	@:extern
	static public inline function conjugate(q:Quaternion) : Quaternion{
		var qj = new Quaternion();
		qj.w = q.w;
		qj.x = -q.x;
		qj.y = -q.y;
		qj.z = -q.z;
		return qj;
	}
	

}