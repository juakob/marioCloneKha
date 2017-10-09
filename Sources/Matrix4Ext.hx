package ;

import  kha.math.*;

using Vector3Ext;
using QuaternionExt;

class Matrix4Ext {
  @:extern
  static private inline function fromQuaternion(m:Matrix4, q:Quaternion): Matrix4{
    
    	var x = q.x, y = q.y, z = q.z, w = q.w;
		var x2 = x + x, y2 = y + y, z2 = z + z;
		var xx = x * x2, xy = x * y2, xz = x * z2;
		var yy = y * y2, yz = y * z2, zz = z * z2;
		var wx = w * x2, wy = w * y2, wz = w * z2;

		m._00 = 1.0 - (yy + zz);
		m._10 = xy - wz;
		m._20 = xz + wy;

		m._01 = xy + wz;
		m._11 = 1.0 - (xx + zz);
		m._21 = yz - wx;

		m._02 = xz - wy;
		m._12 = yz + wx;
		m._22 = 1.0 - (xx + yy);

		m._03 = 0.0; m._13 = 0.0; m._23 = 0.0;
		m._30 = 0.0; m._31 = 0.0; m._32 = 0.0; m._33 = 1.0;

    return m;
  }

  @:extern
  static private inline function scale(m:Matrix4, s:Vector3) : Matrix4{

    m._00 *= s.x; m._01 *= s.x; m._02 *= s.x; m._03 *= s.x;
	m._10 *= s.y; m._11 *= s.y; m._12 *= s.y; m._13 *= s.y;
	m._20 *= s.z; m._21 *= s.z; m._22 *= s.z; m._23 *= s.z;

    return m;
  }

   @:extern
  static private inline function translate(m:Matrix4, p:Vector3) : Matrix4{

    m._30 = p.x;
    m._31 = p.y;
    m._32 = p.z;
    
    return m;
  }

	 @:extern
  static public inline function compose(m:Matrix4, q:Quaternion, s:Vector3, p:Vector3) : Matrix4{
    
		fromQuaternion(m,q);
		scale(m,s);
		translate(m,p);

		return m;

	}

  @:extern
  static public inline function composeRS(m:Matrix4, q:Quaternion, s:Vector3) : Matrix4{
    
		fromQuaternion(m,q);
		scale(m,s);

		return m;

	}

 @:extern
  static public inline function  decompose(m:Matrix4, q:Quaternion, s:Vector3, p:Vector3):Matrix4 {
		
		var helpVec = new Vector3();
		var helpMat = Matrix4.identity();

		var sx = helpVec.set(m._00, m._01, m._02).length;
		var sy = helpVec.set(m._10, m._11, m._12).length;
		var sz = helpVec.set(m._20, m._21, m._22).length;
		var det = m.determinant();
		if (det < 0.0) sx = -sx;
		p.x = m._30; p.y = m._31; p.z = m._32;
		// Scale the rotation part
		helpMat._00 = m._00; helpMat._10 = m._10; helpMat._20 = m._20; helpMat._30 = m._30;
		helpMat._01 = m._01; helpMat._11 = m._11; helpMat._21 = m._21; helpMat._31 = m._31;
		helpMat._02 = m._02; helpMat._12 = m._12; helpMat._22 = m._22; helpMat._32 = m._32;
		helpMat._03 = m._03; helpMat._13 = m._13; helpMat._23 = m._23; helpMat._33 = m._33;
		var invSX = 1.0 / sx;
		var invSY = 1.0 / sy;
		var invSZ = 1.0 / sz;
		helpMat._00 *= invSX;
		helpMat._01 *= invSX;
		helpMat._02 *= invSX;
		helpMat._03 = 0.0;
		helpMat._10 *= invSY;
		helpMat._11 *= invSY;
		helpMat._12 *= invSY;
		helpMat._13 = 0.0;
		helpMat._20 *= invSZ;
		helpMat._21 *= invSZ;
		helpMat._22 *= invSZ;
		helpMat._23 = 0.0;
		helpMat._30 = 0.0;
		helpMat._31 = 0.0;
		helpMat._32 = 0.0;
		helpMat._33 = 0.0;
		q.fromRotationMat(helpMat);
		s.x = sx; s.y = sy; s.z = sz;
		return m;
	}

	@:extern
  	static public function setFrom(m:Matrix4, mIn:Matrix4) : Matrix4{
		m._00 = mIn._00; m._10 = mIn._10; m._20 = mIn._20; m._30 = mIn._30;
		m._01 = mIn._01; m._11 = mIn._11; m._21 = mIn._21; m._31 = mIn._31;
		m._02 = mIn._02; m._12 = mIn._12; m._22 = mIn._22; m._32 = mIn._32;
		m._03 = mIn._03; m._13 = mIn._13; m._23 = mIn._23; m._33 = mIn._33;
		return m;
  	}




}