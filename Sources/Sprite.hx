package;
import kha.Assets;
import kha.Canvas;
import kha.Image;
import kha.graphics2.Graphics;

/**
 * ...
 * @author Joaquin
 */
class Sprite implements IDraw
{
	public var x:Float=0;
	public var y:Float = 0;
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var scaleX:Float=1;
	public var scaleY:Float = 1;
	public var offsetX:Float=0;
	public var offsetY:Float = 0;
	var mWidth:Float = 0;
	var mHeight:Float = 0;
	public var parent:Layer;
	
	var image:Image;
	
	public function new(aImageName:String) 
	{
		image = Reflect.field(kha.Assets.images, aImageName);
        if(image==null) throw "image "+aImageName+" not loaded";
		mWidth = image.width;
		mHeight = image.height;
	}
	public function render(aFrameBuffer:Canvas,translation:Point):Void
	{
		aFrameBuffer.g2.drawScaledImage(image, x+offsetX+translation.x, y+offsetY,mWidth*scaleX+translation.y,mHeight*scaleY);
	}
	
	function get_width():Float 
	{
		return mWidth*scaleX;
	}
	
	function get_height():Float 
	{
		return mHeight*scaleY;
	}
	public function removeFromParent() 
	{
		if (parent != null) parent.remove(this);
	}
	
}