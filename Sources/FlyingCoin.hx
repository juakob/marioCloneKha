package;

/**
 * ...
 * @author Joaquin
 */
class FlyingCoin extends Entity
{
	var collisionable:CollisionBox;
	var display:SpriteSheet;
	var timer:Float;
	var xInTiles:Int;
	var yInTiles:Int;
	var animation:Animation;
	public function new() 
	{
		super();
		collisionable = new CollisionBox();
		addChild(collisionable);
		display = new SpriteSheet("tiles64", 64, 64, -1, 1);
		display.scaleX = 0.5;
		display.scaleY = 0.5;
		animation = new Animation(display);
		addChild(animation);
		animation.addAnimation("spin", [80, 95, 110, 125, 140, 155],1/60);
		
	}
	public function reset(aXInTiles:Int, aYInTiles:Int, aLayer:Layer):Void
	{
		xInTiles = aXInTiles;
		yInTiles = aYInTiles;
		display.x=collisionable.x = aXInTiles*LevelData.map.tileWidth;
		display.y = collisionable.y = (aYInTiles-1)*LevelData.map.tileHeight;
		collisionable.y -= 10;
		collisionable.accelerationY = 100;
		collisionable.velocityY = -100;
		aLayer.add(display);
		animation.play("spin");
		timer = 0.5;
		
	}
	override function limboStart():Void 
	{
		display.removeFromParent();
	}
	override function onUpdate(aDt:Float):Void 
	{
		timer -= aDt;
		if (timer<0)
		{
			die();
		}
	}
	override function onRender():Void 
	{
		display.x = collisionable.x;
		display.y = collisionable.y;
	}
}