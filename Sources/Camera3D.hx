package ;

import kha.Image;
import kha.Color;
import kha.FastFloat;
import kha.math.*;


class Camera3D {
    
    public var clearColor:Color = Color.Black;
    public var renderTarget:Image;
    
    public var projectionMatrix(default, null):FastMatrix4;

    public var viewportPosition:Vector2i;
    public var viewportSize:Vector2i;

    public var isOrthographic(default, null) : Bool = false;

    public var transform:Transform  = new Transform();
    var flipY:Bool = false;
    var fov:FastFloat = 0;
    public var fieldOfView(default, set) : FastFloat;
    function set_fieldOfView(v:FastFloat) : FastFloat{
        fov = v;
        if(!isOrthographic)
        setPerspective(fov, aspect,zn,zf);
        return fov;
    }

    var width:FastFloat = 800;
    var height:FastFloat = 600;
    var aspect:FastFloat = 0;
 
    var zn:FastFloat = 0.1;
    var zf:FastFloat = 100;


    public var viewMatrix(get,null):FastMatrix4 = FastMatrix4.identity();

    @:access(graphics.Transform)
    function get_viewMatrix() : FastMatrix4{
        
        viewMatrix.setFrom(FastMatrix4.fromMatrix4(transform.getMatrix().inverse()));
        return viewMatrix;
        
    }

   public var orthographicSize(default,set):FastFloat = 0.01;

    function set_orthographicSize(v:FastFloat) : FastFloat{
        orthographicSize = v;
        if(isOrthographic)
        setOrtho(width,height,zn,zf);
        return orthographicSize;
    }


    public function new(){

        projectionMatrix = FastMatrix4.identity();
        setPerspective(60 * (Math.PI/180.0),4/3, 0.01,100.0);


        viewportPosition = new Vector2i(0,0);
        viewportSize = new Vector2i(kha.System.windowWidth(),kha.System.windowHeight());
    }
    
    public function setOrtho(halfWidth:FastFloat,halfHeight,zn:FastFloat,zf:FastFloat){

        width = halfWidth;
        height = halfHeight;
        this.zn = zn;
        this.zf = zf;
        projectionMatrix.setFrom(FastMatrix4.orthogonalProjection(-orthographicSize*width,orthographicSize*width,-orthographicSize*height,orthographicSize*height,zn,zf));
        #if (kha_webgl || kha_opengl || kha_android)
            projectionMatrix._11 *= -1;
        #end
        isOrthographic = true;
    }

    public function setPerspective(fov:FastFloat, aspect:FastFloat, zn:FastFloat, zf:FastFloat){
        this.fov = fov;
        this.aspect = aspect;
        this.zn = zn;
        this.zf = zf;
        projectionMatrix.setFrom(FastMatrix4.perspectiveProjection(fov,aspect,zn,zf));
        #if (kha_webgl || kha_opengl || kha_android)
            //projectionMatrix._11 *= -1;
        #end
        
        isOrthographic = false;
    }

    public function switchProjection(){
        if(isOrthographic) setPerspective(fov,aspect,zn,zf);
        else setOrtho(width,height,zn,zf);
    }



}