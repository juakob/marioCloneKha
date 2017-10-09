package;

/**
 * ...
 * @author Joaquin
 */
class BlockChunk extends Entity
{
	var collider:CollisionBox;
	var display:SpriteSheet;
	var life:Float;
	public function new() 
	{
		super();
		display = new SpriteSheet("tiles64", 64, 64, -1, 1);
		display.scaleX = display.scaleY = 0.5;
		display.frame = 75;
		collider = new CollisionBox();
		addChild(collider);
	}
	public function reset(aX:Float, aY:Float, velocityX:Float, velocityY:Float , aLayer:Layer) {
		collider.x = aX;
		collider.y = aY;
		collider.velocityX = velocityX;
		collider.velocityY = velocityY;
		collider.accelerationY = 2000;
		aLayer.add(display);
		life = 1;
	}
	override function onUpdate(aDt:Float):Void 
	{
		life-= aDt;
		if (life < 0) die();
	}
	override function limboStart():Void 
	{
		display.removeFromParent();
	}
	override function onRender():Void 
	{
		display.x = collider.x;
		display.y = collider.y;
		
	}
}