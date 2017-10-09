package ;

import kha.math.Quaternion;
import kha.math.Vector3;
import kha.math.Matrix4;

using Matrix4Ext;
using Vector3Ext;
using QuaternionExt;

@:enum
abstract Space (Int){
    var Local = 0;
    var Global = 1;
}

class Transform {
    
    public static inline var D2R:Float = 3.1415927410125732421875/180;
	public static inline var R2D:Float = 180/3.1415927410125732421875;

    var matrix : Matrix4;
    var localMatrix : Matrix4;
    var helperQ:Quaternion = new Quaternion();
    var isDirty:Bool = false;

    public var rotation         (default,null) : Quaternion;
    public var localRotation    (default,null) : Quaternion;
    public var position         (default,null) : Vector3;
    public var scale            (default,null) : Vector3;
    public var globalScale      (default,null) : Vector3;
    public var localPosition    (default,null) : Vector3;
    public var euler            (default,null) : Vector3;
    public var localEuler       (default,null) : Vector3;

    public var childCount(get, null) : Int;
    function get_childCount() : Int{
        return children.length;
    }

    function updateLocalPosition(){
        if(parent != null)
        localPosition.setFrom(position.sub(parent.position));        
        else
        localPosition.setFrom(position); 

        localMatrix._30 = localPosition.x;
        localMatrix._31 = localPosition.y;
        localMatrix._32 = localPosition.z;   
        
    }
    function updateLocalRotation(){
        if(parent != null){
            localRotation.setFrom(rotation.mult(parent.rotation.conjugate()));
            //localRotation.normalize();
        }
        else
        localRotation.setFrom(rotation);
    }

     function updatePosition(){
        if(parent != null)
        position.setFrom(localPosition.add(parent.position));
        else
        position.setFrom(localPosition);    
        
        matrix._30 = position.x;
        matrix._31 = position.y;
        matrix._32 = position.z;

    }
    function updateRotation(){
        if(parent != null){  
            rotation.setFrom(localRotation.mult(parent.rotation));
           // rotation.normalize();
        }
        else
        rotation.setFrom(localRotation);
    }

    

    function updateGlobalScale(){
        if(parent != null)
        globalScale.setFrom(scale.multVec(parent.globalScale));
        else
        globalScale.setFrom(scale);
    }

    //Needs fixing
    function updateScale(){
        if(parent != null)
        scale.setFrom(globalScale.divVec(parent.globalScale));
        else
        scale.setFrom(scale);
    }

    public function getMatrix() : Matrix4{
        if(isDirty) buildMatrix();

        return matrix;
    }


    function buildMatrix() {
        
        if(isDirty){

           localMatrix.compose(localRotation,scale,localPosition);

            if(parent != null)matrix.setFrom(parent.matrix.multmat(localMatrix));
            else matrix.setFrom(localMatrix);

            updateChildren();
            
        }

        isDirty = false;
    }

    public function resetTransform(){
       position.x = localPosition.x = 0;
       position.y = localPosition.y = 0;
       position.z = localPosition.z = 0;

       scale.x =  globalScale.x = 1;
       scale.y =  globalScale.y = 1;
       scale.z =  globalScale.z = 1;

       rotation.x = localRotation.x = 0;
       rotation.y = localRotation.y = 0;
       rotation.z = localRotation.z = 0;
       rotation.w = localRotation.w = 1;

       isDirty = true;
    }

    public function rotate(axis:Vector3, degrees:Float, space:Space = Space.Local){
        rotateRad(axis,degrees * D2R,space);
    }

     public function rotateRad(axis:Vector3, radians:Float, space:Space = Space.Local){
        var q = Quaternion.fromAxisAngle(axis, radians);
         var qt;
        switch(space)
        {
            case Space.Global:
            qt = rotation.mult(q);
            rotation.setFrom(qt);
            //rotation.normalize();
            updateLocalRotation();

            case Space.Local:
            qt = localRotation.mult(q);
            localRotation.setFrom(qt);
           // localRotation.normalize();            
            updateRotation();

            //localEuler = localRotation.getEulerAngles(Quaternion.AXIS_X,Quaternion.AXIS_Y,Quaternion.AXIS_Z);

        }

        isDirty = true;
    }

    public function setScale(x:Float, y:Float, z:Float){
        scale.x = x;
        scale.y = y;
        scale.z = z;
        updateGlobalScale();
        isDirty = true;
    }

    public function setPosition(x:Float, y:Float, z:Float){
        position.x = x;
        position.y = y;
        position.z = z;

        //Immediately update matrix
        matrix._30 = x;
        matrix._31 = y;
        matrix._32 = z;

        updateLocalPosition();
        //isDirty = true;
    }

    public function translateVec(v:Vector3){
        translate(v.x,v.y,v.z);
    }

    
    public function translate(x:Float, y:Float, z:Float){
        position.x += x;
        position.y += y;
        position.z += z;
        updateLocalPosition();
        isDirty = true;
    }


    public function setRotation(axis:Vector3, degrees:Float){
        
        var q = Quaternion.fromAxisAngle(axis, degrees * D2R);
        rotation.x = q.x;
        rotation.y = q.y;
        rotation.z = q.z;
        rotation.w = q.w;
        updateLocalRotation();
        isDirty = true;
    }

     public function setRotationQuat(q:Quaternion){
        rotation.setFrom(q);
        updateLocalRotation();
        isDirty = true;
    }

    public function setRotationComp(x:Float,y:Float,z:Float,w:Float){
        rotation.x = x;
        rotation.y = y;
        rotation.z = z;
        rotation.w = w;
        updateLocalRotation();
        isDirty = true;
    }

    public function setLocalPosition(x:Float, y:Float, z:Float){
        
        localPosition.x = x;
        localPosition.y = y;
        localPosition.z = z;

        //Immediately update matrix        
        localMatrix._30 = x;
        localMatrix._31 = y;
        localMatrix._32 = z;
        
        updatePosition();
        //isDirty = true;
    }

    public function setLocalRotation(axis:Vector3, degrees:Float){        
        localRotation = Quaternion.fromAxisAngle(axis, degrees * D2R);
        updateRotation();
        isDirty = true;
    }

    public function setLocalRotQuat(q:Quaternion){
        localRotation.setFrom(q);
        updateRotation();
        isDirty = true;
    }

    public function translateLocalVec(v:Vector3){
        translateLocal(v.x,v.y,v.z);
    }

    public function translateLocal(x:Float, y:Float, z:Float){
        localPosition.x += x;
        localPosition.y += y;
        localPosition.z += z;
        updatePosition();
        isDirty = true;
    }
    
    /** Up vector in world space **/
    public var up(get, null) : Vector3;
    function get_up() : Vector3{
        up.x = matrix._10;
        up.y = matrix._11;
        up.z = matrix._12;
        up.normalize();
        return up;
    }
     /** Right vector in world space **/
    public var right(get, null) : Vector3;
     function get_right() : Vector3{
        right.x = matrix._00;
        right.y = matrix._01;
        right.z = matrix._02;
        right.normalize();
        return right;
    }
    /** foward vector in world space **/
    public var forward(get, null) : Vector3;
    function get_forward() : Vector3{
        forward.x = matrix._20;
        forward.y = matrix._21;
        forward.z = matrix._22;
        forward.normalize();
        return forward;
    }
  /** Up vector in local space **/
    public var localUp(get, null) : Vector3;
    function get_localUp() : Vector3{
        localUp.x = localMatrix._10;
        localUp.y = localMatrix._11;
        localUp.z = localMatrix._12;
        localUp.normalize();
        return localUp;
    }
     /** Right vector in local space **/
    public var localRight(get, null) : Vector3;
     function get_localRight() : Vector3{
        localRight.x = localMatrix._00;
        localRight.y = localMatrix._01;
        localRight.z = localMatrix._02;
        localRight.normalize();
        return localRight;
    }
    /** foward vector in local space **/
    public var localForward(get, null) : Vector3;
        function get_localForward() : Vector3{
        localForward.x = localMatrix._20;
        localForward.y = localMatrix._21;
        localForward.z = localMatrix._22;
        localForward.normalize();
        return localForward;
    }
    
    public var parent(default, null) : Transform = null;

    public function setParent(p:Transform, retainWorldPosition:Bool){
    
        if(parent == p) return;

        if(parent != null) {
            parent.removeChild(this);
        }
        if(p != null){
            p.addChild(this);
            parent = p;   
        }

        if(retainWorldPosition){
           updateLocalPosition();
           updateLocalRotation();
           updateScale();
        }
        else{
            updatePosition();
            updateRotation();
            updateGlobalScale();
        }

        buildMatrix();
        updateChildren();
    }
    
     var children:Array<Transform> = new Array<Transform>();


    //Fix all transform/parent/child relations
    function updateChildren(){
        for(i in 0...children.length){
            children[i].updatePosition();
            children[i].updateRotation();
            children[i].updateGlobalScale();
            children[i].isDirty = true;
        }   
    }
    
    public function getChild(childIndex:Int) : Transform{
        return children[childIndex];
    }
    
    function removeChild(t:Transform)
    {
        children.remove(t);
        t.parent = null;
    }
    
    public function addChild(t:Transform){
        children.push(t);
    }
    
    public function lookAt(at:Vector3, up:Vector3){

        var f:Vector3;
        var l:Vector3;
        var u:Vector3;

        f = at.sub(position);
        f.normalize();
        l = up.cross(f);
        l.normalize();
        u = f.cross(l);
        u.normalize();

        var m = Matrix4.identity();
        m._00 =  -l.x;
        m._01 =  -l.y;
        m._02 =  -l.z;

        m._10 = u.x;
        m._11 = u.y;
        m._12 = u.z;

        m._20= -f.x;
        m._21 = -f.y;
        m._22 = -f.z;

       
        helperQ.fromRotationMat(m);
        setRotationQuat(helperQ);

        isDirty = true;
    }

    public function new(){
        matrix          = Matrix4.identity();
        localMatrix     = Matrix4.identity();
        rotation        = new Quaternion();
        localRotation   = new Quaternion();
        position        = new Vector3();
        localPosition   = new Vector3();
        euler           = new Vector3();
        scale           = new Vector3(1,1,1);
        globalScale     = new Vector3(1,1,1);
        localForward    = new Vector3(0,0,1);
        localRight      = new Vector3(1,0,0);
        localUp         = new Vector3(0,1,0);
        forward         = new Vector3(0,0,1);
        right           = new Vector3(1,0,0);
        up              = new Vector3(0,1,0);

        isDirty= true;

        buildMatrix();
    }
}