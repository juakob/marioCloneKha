package;

/**
 * ...
 * @author Joaquin
 */
class BounceBlock extends Entity
{
	var collisionable:CollisionBox;
	var display:SpriteSheet;
	var finishId:Int;
	var initialY:Float;
	var xInTiles:Int;
	var yInTiles:Int;
	var collisionParent:CollisionGroup;
	public function new() 
	{
		super();
		collisionable = new CollisionBox();
		addChild(collisionable);
		display = new SpriteSheet("tiles64", 64, 64, -1, 1);
		display.scaleX = 0.5;
		display.scaleY = 0.5;
		
	}
	public function reset(aXInTiles:Int, aYInTiles:Int, aMimicId:Int, aFinishId:Int, aLayer:Layer,aCollisionsGroup:CollisionGroup):Void
	{
		xInTiles = aXInTiles;
		yInTiles = aYInTiles;
		display.x=collisionable.x = aXInTiles*LevelData.map.tileWidth;
		display.y=initialY = collisionable.y = aYInTiles*LevelData.map.tileHeight;
		collisionable.y -= 10;
		collisionable.width = LevelData.map.tileWidth;
		collisionable.height = LevelData.map.tileHeight;
		collisionable.accelerationY = 1500;
		collisionable.velocityY = -125;
		aLayer.add(display);
		finishId = aFinishId;
		display.frame = aMimicId;
		aCollisionsGroup.add(collisionable);
	}
	override function limboStart():Void 
	{
		display.removeFromParent();
		collisionable.removeFromParent();
	}
	override function onUpdate(aDt:Float):Void 
	{
		if (collisionable.y >= initialY)
		{
			LevelData.map.changeTileId(xInTiles, yInTiles, finishId);
			die();
		}
	}
	override function onRender():Void 
	{
		display.x = collisionable.x;
		display.y = collisionable.y;
	}
}