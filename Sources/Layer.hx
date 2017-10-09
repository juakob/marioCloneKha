package;
import kha.Canvas;

/**
 * ...
 * @author Joaquin
 */
class Layer implements IDraw
{
	public var x:Float = 0;
	public var y:Float = 0;
	var mChildren:Array<IDraw>;
	public var parent:Layer;
	public function new() 
	{
		mChildren = new Array();
	}
	
	public function add(aChild:IDraw)
	{
		mChildren.push(aChild);
		aChild.parent = this;
	}
	
	public function render(aFrameBuffer:Canvas,translation:Point):Void 
	{
		translation.x += x;
		translation.y += y;
		for (sprite in mChildren) 
		{
			sprite.render(aFrameBuffer,translation);
		}
		translation.x -= x;
		translation.y -= y;
	}
	
	public function remove(sprite:IDraw) 
	{
		mChildren.remove(sprite);
	}
	
}