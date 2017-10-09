package ;

import kha.Blob;
import kha.Scheduler;
import kha.graphics4.*;

class Meshparser{
    
    
    public static function ObjToMesh(o:Blob) : Mesh{
        var obj = new ObjLoader(o.toString());
        var data = obj.data;
        var indices = obj.indices;
        
        var m:Mesh = new Mesh();
        
        m.vertices = new VertexBuffer(Std.int(data.length / 8),G4Renderer.defaultStructure,Usage.StaticUsage);
        m.indices = new IndexBuffer(indices.length, Usage.StaticUsage);
        
               
        var vbData = m.vertices.lock();
        for (i in 0...vbData.length) {
             vbData.set(i,data[i]);
        }
        m.vertices.unlock();

        
        var iData = m.indices.lock();
        for (i in 0...iData.length) {
            iData[i] = indices[i];
        }
        m.indices.unlock();
            
        return m;
    }

    
}