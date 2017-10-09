package;

/**
 * ...
 * @author Joaquin
 */
class Goomba extends Entity
{
	public var collisions:CollisionBox;
	var display:SpriteSheet;
	var speedX = 100;
	var animation:Animation;
	var collisionParent:CollisionGroup;
	public var dyingStomp:Bool;
	var timer:Float;
	public function new() 
	{
		super();
		display = new SpriteSheet("goomba", 40, 54);
		
		
		display.scaleX = display.scaleY = 1;
		collisions = new CollisionBox();
		collisions.width = 32;
		collisions.height = 32;
		display.offsetY =-19;
		collisions.accelerationY = 2000;
		collisions.userData = this;
		addChild(collisions);
		
		animation = new Animation(display);
		animation.addAnimation2("walk", 0, 11, 1 / 30);
		animation.addAnimation2("stomp", 13, 16, 1 / 30, false);
		addChild(animation);
		
	}
	override function limboStart():Void 
	{
		display.removeFromParent();
		collisionParent.remove(collisions);
		collisionParent = null;
	}
	public function reset(aX:Float, aY:Float, aLayer:Layer, aCollisions:CollisionGroup)
	{
		dyingStomp = false;
		collisions.x = aX;
		collisions.y = aY;
		aCollisions.add(collisions);
		aLayer.add(display);
		collisions.velocityX = -speedX;
		animation.play("walk");
		collisionParent = aCollisions;
		display.scaleX = 1;
		display.scaleY = 1;
		display.offsetX = 0;
		display.offsetY =-19;
	}
	override public function update(aDt:Float):Void 
	{
		if (dyingStomp)
		{
			collisions.velocityX = 0;
			timer -= aDt;
			if (timer < 0) die();
		}
		if (collisions.y > 820) die();
		if (collisions.isTouching(Sides.RIGHT))
			{
				collisions.velocityX =-speedX;
				display.scaleX = 1;
				display.offsetX = 0;
			}else
			if (collisions.isTouching(Sides.LEFT))
			{
				collisions.velocityX = speedX;
				display.scaleX =-1;
				display.offsetX =-display.width;
				
			}
		super.update(aDt);
	}
	public function killFromBelow()
	{
		display.scaleY =-1;
		collisions.velocityY =-300;
		collisions.removeFromParent();
		display.offsetY -=display.height;
	}
	public function stomp() 
	{
		collisions.velocityX = 0;
		dyingStomp = true;
		animation.play("stomp");
		timer = 0.5;
	}
	override function onRender():Void 
	{
		display.x = collisions.x;
		display.y = collisions.y;
	}
}