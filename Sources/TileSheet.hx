package;
import kha.Assets;
import kha.Canvas;
import kha.Color;
import kha.Image;

/**
 * ...
 * @author Joaquin
 */
class TileSheet  implements IDraw
{
	
	var tiles:Array<Int>;
	var tileWidth:Float;
	var tileHeight:Float;
	var widthInTiles:Int;
	var heightInTiles:Int;
	var imageHelper:SpriteSheet;
	
	var minViewX:Int = 0;
	var minViewY:Int = 0;
	
	var maxViewX:Int = 0;
	var maxViewY:Int = 0;
	var scale:Float;
	public var parent:Layer;
	
	public function new(aTiles:Array<Int>,imageName:String, aTileWidth:Float, aTileHeight:Float,aWidthIntTiles:Int,aHeightInTiles:Int,separation:Int=0,aScale:Float=1 ) 
	{
		tiles = aTiles;
		tileWidth = aTileWidth;
		tileHeight = aTileHeight;
		widthInTiles =maxViewX= aWidthIntTiles;
		heightInTiles =maxViewY= aHeightInTiles;
		imageHelper = new SpriteSheet(imageName, aTileWidth, aTileHeight, -1,separation);
		imageHelper.scaleX = imageHelper.scaleY = aScale;
		scale = aScale;
	}
	public function setViewArea(minX:Float, minY:Float, maxX:Float, maxY:Float)
	{
		minViewX = Std.int(minX/(tileWidth*scale))-1;
		minViewY = Std.int(minY / (tileHeight * scale)) - 1;
		maxViewX = Std.int(maxX / (tileWidth * scale)) + 1;
		maxViewY = Std.int(maxY / (tileHeight * scale)) + 1;
		
		minViewX = (0>minViewX)?0:minViewX;
		minViewY = (0<minViewY)?0:minViewY;
		maxViewX = ((widthInTiles )< maxViewX)?widthInTiles:maxViewX;
		maxViewY = ((heightInTiles)< maxViewY)?heightInTiles:maxViewY;
	}
	
	/* INTERFACE IDraw */
	
	public function render(aFrameBuffer:Canvas,translation:Point):Void 
	{
		for (y in minViewY...maxViewY){
			for(x in minViewX...maxViewX)
			{
				var i:Int = tiles[x + y * widthInTiles];
				if (i > 0)
				{
					imageHelper.x =x* tileWidth*imageHelper.scaleX;
					imageHelper.y = y* tileHeight*imageHelper.scaleX;
					imageHelper.frame = i;
					imageHelper.render(aFrameBuffer,translation);
				}
			}
		}
		
	}
	
}