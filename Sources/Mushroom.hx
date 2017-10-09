package;

/**
 * ...
 * @author Joaquin
 */
class Mushroom extends Entity
{
	var collisions:CollisionBox;
	var display:SpriteSheet;
	var collisionParent:CollisionGroup;
	var targetY:Float;
	var popingUp:Bool;
	var speed:Float = 175;
	var wait:Float;
	public function new() 
	{
		super();
		collisions = new CollisionBox();
		addChild(collisions);
		display = new SpriteSheet("tiles64", 64, 64, -1, 1);
		display.frame = 34;
		display.scaleX = display.scaleY = 0.5;
		collisions.width = 32;
		collisions.height = 32;
	}
	override function limboStart():Void 
	{
		display.removeFromParent();
		collisionParent.remove(collisions);
	}
	public function reset(aX:Float, aY:Float, aLayer:Layer, aCollisionParent:CollisionGroup)
	{
		collisions.x = aX;
		collisions.y = aY-20;
		collisions.userData = this;
		aLayer.add(display);
		collisionParent = aCollisionParent;
		popingUp = true;
		targetY = aY - display.height;
		collisions.velocityY =-75;
		collisions.velocityX = 0;
		collisions.accelerationY = 0;
		wait = 0.15;
	}
	override public function update(aDt:Float):Void 
	{
		if (popingUp)
		{
			if (collisions.y <= targetY) {
				wait -= aDt;
				collisions.velocityY = 0;
				if(wait<0){
					popingUp = false;
					collisions.accelerationY = 1500;
					collisions.velocityX = speed;
					collisions.velocityY =-155;
					collisionParent.add(collisions);
				}
			}
		}else {
			if (collisions.isTouching(Sides.RIGHT))
			{
				collisions.velocityX=-speed;
			}else
			if (collisions.isTouching(Sides.LEFT))
			{
				collisions.velocityX=speed;
			}
		}
		super.update(aDt);
	}
	override function onRender():Void 
	{
		display.x = collisions.x;
		display.y = collisions.y;
	}
	public function jumpLeft()
	{
		collisions.velocityY =-200;
		collisions.velocityX = -speed;
	}
	public function jumpRight()
	{
		collisions.velocityY =-200;
		collisions.velocityX = speed;
	}
	public function jump()
	{
		collisions.velocityY =-200;
	}
}