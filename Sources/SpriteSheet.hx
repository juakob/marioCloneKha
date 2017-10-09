package;
import kha.Canvas;
import kha.Framebuffer;

/**
 * ...
 * @author Joaquin
 */
class SpriteSheet extends Sprite
{
	public var totalFrames(default, null):Int;
	public var frame:Int=0;
	var subX:Float=0;
	var subY:Float = 0;
	var rows:Int = 1;
	var columns:Int = 1;
	var separation:Int = 0;
	
	public function new(aImageName:String,aWidth:Float,aHeight:Float,aTotalFrames:Int=-1,aSeparation:Int=0) 
	{
		super(aImageName);
		mWidth = aWidth;
		mHeight = aHeight;
		rows = Std.int(image.height / (aHeight+aSeparation*2));
		columns = Std.int(image.width / (aWidth + aSeparation * 2));
		trace((aWidth + separation * 2));
		totalFrames = aTotalFrames;
		if (aTotalFrames < 0)
		{
			aTotalFrames = rows * columns;
		}
		separation = aSeparation;
		
	}
	override public function render(aFrameBuffer:Canvas,translation:Point):Void 
	{
		subX = (mWidth+separation*2) * (frame %columns);
		subY = (mHeight+separation*2) * Std.int(frame / columns);
		aFrameBuffer.g2.drawScaledSubImage(image,subX+separation,subY+separation,mWidth,mHeight, x+offsetX + translation.x, y+offsetY+translation.y,mWidth*scaleX,mHeight*scaleY);
	}
	
	
}