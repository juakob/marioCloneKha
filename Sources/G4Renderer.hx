package;

import kha.*;
import kha.graphics4.*;
import kha.math.*;

class BackgroundGenerator {

    var plane:Node;
    var frontLayer:Node;
    var midLayer:Node;
    var midBackLayer:Node;
    var backLayer:Node;

    var pillar:Mesh;
    var ground:Mesh;
    var mountain:Mesh;
    var platform:Mesh;
    var platformSlant:Mesh;

    var ground_texture:Image;
    var mountain_texture:Image;
    var pillar_texture:Image;
    var platform_texture:Image;

    var maxwidth:Float = 250;
    var maxItems:Int = 5;

    var assetCount:Int = 2;
    var doneLoading:Bool = false;
    var gr:G4Renderer;

    var frontProps:Array<Dynamic>;
    var middleProps:Array<Dynamic>;
    var backProps:Array<Dynamic>;

    public function new(){
        plane = new Node();
        frontLayer = new Node();
        frontLayer.setPosition(0,0,-5);
        midLayer = new Node();
        midLayer.setPosition(0,0,-10);
        backLayer = new Node();
        backLayer.setPosition(0,0,-49);
        backLayer = new Node();
        backLayer.setPosition(0,0,-70);
    }

    public function init(gr:G4Renderer): Void{
        this.gr = gr;
       // kha.Assets.loadImage("grass", onLoadedImg);
      //  kha.Assets.loadImage("mountaingrass", onLoadedImg);
      //  kha.Assets.loadImage("stone", onLoadedImg);
      //  kha.Assets.loadImage("brownstripe", onLoadedImg);

       // kha.Assets.loadBlob("ground_obj", onLoadedBlob);
      //  kha.Assets.loadBlob("pillar_obj", onLoadedBlob);
      //  kha.Assets.loadBlob("mountain_obj", onLoadedBlob);
      //  kha.Assets.loadBlob("platform_obj", onLoadedBlob);
      //  kha.Assets.loadBlob("platform_slant_obj", onLoadedBlob);
    }

    function onLoadedImg(i) : Void{
        assetCount--;
        if(assetCount == 0 && !doneLoading) 
        {
            doneLoading = true;
            setAssets();
        }
        
    }

    function onLoadedBlob(b) : Void{
        assetCount--;
        if(assetCount == 0 && !doneLoading) 
        {
            doneLoading = true;
            setAssets();
        }
    }

    function setAssets(){

        if(ground_texture != null) return;

        gr.addNode(plane);
        gr.addNode(frontLayer);
        gr.addNode(midLayer);
        gr.addNode(backLayer);

        ground_texture = kha.Assets.images.grass;
        //mountain_texture = kha.Assets.images.mountaingrass;
       // pillar_texture = kha.Assets.images.stone;
        //platform_texture = kha.Assets.images.brownstripe;
            

        ground = Meshparser.ObjToMesh(kha.Assets.blobs.ground_obj);
    //    pillar = Meshparser.ObjToMesh(kha.Assets.blobs.pillar_obj);
    //    mountain = Meshparser.ObjToMesh(kha.Assets.blobs.mountain_obj);
     //   platform = Meshparser.ObjToMesh(kha.Assets.blobs.platform_obj);
     //   platformSlant = Meshparser.ObjToMesh(kha.Assets.blobs.platform_slant_obj);

        frontProps = [platform, platform_texture, platformSlant, platform_texture];
        middleProps = [pillar, pillar_texture];
        backProps = [mountain, mountain_texture];

        generate();
    }

    public function generate(): Void{
        var node = new Node();
        node.texture = ground_texture;
        node.mesh = ground;
        node.setPosition(0,0,-100);
        frontLayer.addChild(node);
        //for(i in 0...maxItems){
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(0));
            //frontLayer.addChild(getProp(1));
            //frontLayer.addChild(getProp(2));
            //frontLayer.addChild(getProp(3));
            //frontLayer.addChild(getProp(3));
        //}
        trace("Generated");
    }

    function getProp(layer:Int) : Node{
        var n = new Node();
        var rand:Int = 0;
        switch(layer){
            case 0:
                var length =Std.int( frontProps.length/2 );
                rand = Std.int(Math.random() * length);
                n.mesh = frontProps[rand*length];
                n.texture = frontProps[rand*length+1];
                n.setLocalPosition(Math.random()*maxwidth-50,-Math.random(),Math.random());

             case 1:
                var scale = Math.random()*12+1;             
                var length =Std.int( middleProps.length/2 );
                rand = Std.int(Math.random() * length);
                n.mesh = middleProps[rand*length];
                n.texture = middleProps[rand*length+1];
                n.setScale(scale, scale, scale);
                n.setLocalPosition(Math.random()*maxwidth-50,0,Math.random());
            
            case 2:
                var length =Std.int( middleProps.length/2 );
                var scale = Math.random()*12+1;
                rand = Std.int(Math.random() * length);
                n.mesh = middleProps[rand*length];
                n.texture = middleProps[rand*length+1];
                n.setLocalPosition(Math.random()*maxwidth-50,-2,Math.random());
                //n.setScale(scale, scale, scale);

            case 3:
                var length =Std.int( backProps.length/2 );
                var scale = Math.random()*10+1;
                rand = Std.int(Math.random() * length);
                n.mesh = backProps[rand*length];
               n.setScale(scale, scale, scale);
                n.texture = backProps[rand*length+1];
                n.setLocalPosition(Math.random()*maxwidth*2-200,0,Math.random());
                
        }

        return n;
    }

}