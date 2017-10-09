package ;

import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexStructure;

class Mesh{
   
    public var indices:IndexBuffer;
    public var vertices:VertexBuffer;
    public var vertexStructur:VertexStructure;
    
    public var count(get,null) : Int;
    
    public function new(){}
    
    function get_count() : Int{
        return vertices.count();
    }
}