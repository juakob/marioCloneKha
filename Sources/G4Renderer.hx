package;

import kha.Canvas;
import kha.graphics4.*;
import kha.math.*;

class G4Renderer {

    public static var defaultStructure:VertexStructure;

    var root:Transform = new Transform();
    public static var camera:Camera3D;

    //------------------------------------------
    //
    var quadVBO:kha.graphics4.VertexBuffer;
    var quadIBO:kha.graphics4.IndexBuffer;

    var skyboxPipe:PipelineState; 

    var iSkyTop:ConstantLocation;
    var iSkyHorizon:ConstantLocation;
    var iSkyboxSteps:ConstantLocation;
    var iSkyboxInverseProj:ConstantLocation;
    var iSkyboxModelView:ConstantLocation;
    var skyboxSteps:Int = 30;
    var skyboxTop:FastVector4 = new FastVector4(1.0,1.0,1.0,1.0);
    var skyboxHorizon:FastVector4 = new FastVector4(0.7,0.7,8.0,1.0);

    //-------------------------------------------
    //
    var defaultPipeline:PipelineState;
    var iMVP:ConstantLocation;
    var iTexture:TextureUnit;
    var iLightDirection:ConstantLocation;
    var lightDirection:FastVector3;

   public function new() {

        camera = new Camera3D();
        var width = kha.System.windowWidth(0);
        var height = kha.System.windowHeight(0);
        camera.setPerspective(45 * (Math.PI/180),width/height, 0.01, 10000);
        camera.transform.setPosition(0,2.0,0);
        setupPipelines();
        createQuad();

        lightDirection = new FastVector3(0.1,-1,-1);

       
   }

   public function addNode(t:Node) {
     root.addChild(t);
   }
    public function init(){ 
    var bgg = new BackgroundGenerator();
     bgg.init(this);
    bgg.setAssets();
    }
   

   function setupPipelines(){

        var vs = new VertexStructure();
        vs.add("vertexPosition", VertexData.Float4);
    
        skyboxPipe = new PipelineState();
        skyboxPipe.inputLayout = [vs];
        skyboxPipe.vertexShader = kha.Shaders.skyboxgradient_vert;
        skyboxPipe.fragmentShader = kha.Shaders.skyboxgradient_frag;
        skyboxPipe.depthWrite = true;

        skyboxPipe.compile();

        iSkyTop = skyboxPipe.getConstantLocation("skytop");
        iSkyHorizon = skyboxPipe.getConstantLocation("skyhorizon");
        iSkyboxSteps = skyboxPipe.getConstantLocation("steps");
        iSkyboxInverseProj = skyboxPipe.getConstantLocation("inProjectionMatrix");
        iSkyboxModelView = skyboxPipe.getConstantLocation("modelView");

        defaultStructure = new VertexStructure();
        defaultStructure.add("position", VertexData.Float3);
        defaultStructure.add("uv", VertexData.Float2);
        defaultStructure.add("normal", VertexData.Float3);
        
        defaultPipeline = new PipelineState();
        defaultPipeline.vertexShader = kha.Shaders.default_vert;
        defaultPipeline.fragmentShader = kha.Shaders.default_frag;
        defaultPipeline.depthWrite = true;
        defaultPipeline.depthMode = CompareMode.LessEqual;
        defaultPipeline.inputLayout = [defaultStructure];

        defaultPipeline.compile();

        iMVP = defaultPipeline.getConstantLocation("MVP");
        iTexture = defaultPipeline.getTextureUnit("tex");
        iLightDirection = defaultPipeline.getConstantLocation("LightDirection");

   }

   function createQuad(){

            var vs = new VertexStructure();
            vs.add("position", VertexData.Float4);
            
            quadVBO = new VertexBuffer(4,vs,Usage.StaticUsage);
            var data = quadVBO.lock();
            data.set(0,-1);// x
            data.set(1,-1);// y
            data.set(2,1); // z
            data.set(3,1); // w
            //
            //
            data.set(4,1); // x
            data.set(5,-1);// y
            data.set(6,1); // z
            data.set(7,1); // w
            //
            //
            data.set(8,1); // x
            data.set(9,1); // y
            data.set(10,1);// z            
            data.set(11,1);// w
            //
            //
            data.set(12,-1);// x
            data.set(13,1); // y
            data.set(14,1); // z            
            data.set(15,1); // w
            
            quadVBO.unlock();

            quadIBO = new IndexBuffer(6, Usage.StaticUsage);
            var idata = quadIBO.lock();
            idata[0] = 0;
            idata[1] = 1;
            idata[2] = 2;
            idata[3] = 2;
            idata[4] = 3;
            idata[5] = 0;
            quadIBO.unlock();

    }

    public function render(buffer:Canvas){
            buffer.g4.begin();
            buffer.g4.clear(camera.clearColor,1.0,1);
           renderSky(buffer);
            renderTree(buffer);
            buffer.g4.end();
    }

    function renderTree(buffer:Canvas){
     buffer.g4.setPipeline(defaultPipeline);
     buffer.g4.setVector3(iLightDirection, lightDirection);
     
        for(i in 0...root.childCount){
            var node = root.getChild(i);
            for(index in 0...node.childCount){
                var child = cast(node.getChild(index), Node);
                if(child.mesh == null) continue;

                var mvp = FastMatrix4.identity();
                mvp.setFrom(mvp.multmat(camera.projectionMatrix));
                mvp.setFrom(mvp.multmat(camera.viewMatrix));
                mvp.setFrom(mvp.multmat(FastMatrix4.fromMatrix4(child.getMatrix())));

                if(child.texture != null)
                buffer.g4.setTexture(iTexture, child.texture);
                buffer.g4.setMatrix(iMVP, mvp);

                buffer.g4.setIndexBuffer(child.mesh.indices);
                buffer.g4.setVertexBuffer(child.mesh.vertices);
                buffer.g4.drawIndexedVertices();
            }
        }
    }

    function renderSky(buffer:Canvas) {
        buffer.g4.setPipeline(skyboxPipe);
        buffer.g4.setMatrix(iSkyboxInverseProj, camera.projectionMatrix.inverse());
        buffer.g4.setMatrix(iSkyboxModelView, camera.viewMatrix);
        buffer.g4.setVector4(iSkyTop, skyboxTop);
        buffer.g4.setVector4(iSkyHorizon, skyboxHorizon);
        buffer.g4.setInt(iSkyboxSteps, skyboxSteps);
        buffer.g4.setIndexBuffer(quadIBO);
		buffer.g4.setVertexBuffer(quadVBO);
        buffer.g4.drawIndexedVertices();
    }
}
