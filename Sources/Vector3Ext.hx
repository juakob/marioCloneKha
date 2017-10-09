package ;
import kha.math.Vector3;

class Vector3Ext {

	@:extern
	static public inline function set(v:Vector3,x:Float,y:Float,z:Float){
		
		v.x = x;
		v.y = y;
		v.z = z;

		return v;
	}

	@:extern
	static public inline function setFrom(v:Vector3, vec:Vector3){
		v.x = vec.x;
		v.y = vec.y;
		v.z = vec.z;
		
		return v;
	}

	@:extern
	static public inline function divVec(v:Vector3, vec:Vector3){
		
		var vd:Vector3 = new Vector3();
		vd.x = v.x / vec.x;
		vd.y = v.y / vec.y;
		vd.z = v.z / vec.z;
		
		return vd;
	}

	@:extern
	static public inline function multVec(v:Vector3, vec:Vector3){
		var vm:Vector3 = new Vector3();
		
		vm.x = v.x * vec.x;
		vm.y = v.y * vec.y;
		vm.z = v.z * vec.z;
		
		return vm;
	}

	@:extern
	static public inline function negate(v:Vector3){
		var vm:Vector3 = new Vector3();
		
		vm.x = v.x * -1;
		vm.y = v.y * -1;
		vm.z = v.z * -1;
		
		return vm;
	}

}