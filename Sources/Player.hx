package;
import kha.input.KeyCode;

class Player extends Entity
{
	var animation:Animation;
	var sprite:SpriteSheet;
    var scale:Float = 0.85;
	public var collision:CollisionBox;
	var jumpTimer:Float=0;
	var maxJumpTime:Float = 0.2;
	var jumping:Bool;
	var state:String;
	var offsetX:Int =-20;
	
	var offsetYBig:Int =-22;
	var offsetYSmall:Int =-26 * 2;
	public var invulnerableTime:Float = 0;
	
	var pushed:Bool;
	var lastYVelocity:Float;
	var gravity:Float = 2000;
    public function new(aLayer:Layer )
	{	
		state = "Small";
		super();
		sprite = new SpriteSheet("mario3d", 80, 108, 35);
		animation = new Animation(sprite);
		
		animation.addAnimation("idleBig", [43],1/30, false);
		animation.addAnimation2("walkBig", 0,15, 1 / 30, true);
		animation.addAnimation2("runBig", 17,33,1/30, true);
		animation.addAnimation("jumpBig", [37,38],1/30, false);
		animation.addAnimation("fallBig", [44],1/30, false);
		animation.addAnimation("slideBig",[35],1/30, false);
		animation.addAnimation2("duckBig", 39,42,1/30, false);
		animation.addAnimation("lookUpBig", [10], 1 / 30, false);
		
		var offset:Int = 48;
		animation.addAnimation("idleSmall", [43+offset],1/30, false);
		animation.addAnimation2("walkSmall", 0+offset,15+offset, 1 / 30, true);
		animation.addAnimation2("runSmall", 17+offset,33+offset,1/30, true);
		animation.addAnimation("jumpSmall", [37+offset,38+offset],1/30, false);
		animation.addAnimation("fallSmall", [44+offset],1/30, false);
		animation.addAnimation("slideSmall",[35+offset],1/30, false);
		animation.addAnimation2("duckSmall", 39+offset,42+offset,1/30, false);
		animation.addAnimation("lookUpSmall", [10+offset],1/30, false);
		
		addChild(animation);
		aLayer.add(sprite);
		sprite.scaleY = scale;
		sprite.scaleX = scale;
		sprite.offsetX = offsetX;
		sprite.offsetY = offsetYSmall;
		
		collision = new CollisionBox();
		collision.width = 27;
		collision.height = 64/2;
		collision.maxVelocityX = 300;
		collision.accelerationY = gravity;
		collision.dragX = 0.95;
		collision.maxVelocityY = 700;
		addChild(collision);
		collision.userData = this;
		
		
		
		
    }
	public function pushLeft():Void
	{
		pushed = true;
		collision.velocityY = lastYVelocity;
		collision.velocityX =-200;
	}
	public function pushRight():Void
	{
		pushed = true;
		collision.velocityY = lastYVelocity;
		collision.velocityX =200;
	}
	override public function update(aDt:Float):Void 
	{
		invulnerableTime-= aDt;
		collision.accelerationX =  0;
        if (Input.i.isKeyCodeDown(KeyCode.Left)&&!pushed)
		{
			collision.accelerationX = -1000;
			sprite.scaleX =-scale;
			sprite.offsetX = -sprite.width+offsetX;
		}
		 if (Input.i.isKeyCodeDown(KeyCode.Right)&&!pushed)
		{
			collision.accelerationX = 1000;
			sprite.scaleX = scale;
			sprite.offsetX = offsetX;

		}
       
		if (!pushed) jumpTimer += aDt;
		
		 if (Input.i.isKeyCodePressed(KeyCode.Space)&&collision.isTouching(Sides.BOTTOM))
		{
			collision.velocityY = -475;
			jumping = true;
			jumpTimer = 0;
            if(Input.i.isKeyCodeDown(KeyCode.Down)&&collision.velocityX!=0)
                {
                    if(collision.velocityX>0){
                        collision.velocityX=collision.maxVelocityX;
                    }else{
                        collision.velocityX=-collision.maxVelocityX;
                    }
                }
		}
		if (jumping && Input.i.isKeyCodeDown(KeyCode.Space)&&jumpTimer<=maxJumpTime&&(!collision.isTouching(Sides.TOP)||pushed)) {
			collision.velocityY = -475;
		}else {
			
		jumping = false;	
		}
		
		if (pushed)
		{
			collision.accelerationY = 0;
		}
		lastYVelocity = collision.velocityY;
		super.update(aDt);
		if (pushed)
		{
			collision.velocityX = 0;
		}
		
		collision.accelerationY = gravity;
		pushed = false;
    }
	
	public function hitBlock() 
	{
		jumping = false;
		collision.velocityY = 0;
	}
	
	function playAnimation():Void 
	{
		if(collision.velocityY==0){
			if (collision.velocityX == 0) {
				
				if (Input.i.isKeyCodeDown(KeyCode.Up))
				{
					animation.play("lookUp"+state);
				}else
				 if (Input.i.isKeyCodeDown(KeyCode.Down))
				{
					animation.play("duck"+state);
				}else {
					animation.play("idle"+state);	
				}
			}else {
				if ( collision.velocityX * collision.accelerationX < 0)
				{
					animation.play("slide"+state);
				}else
				if (collision.accelerationX == 0 && Input.i.isKeyCodeDown(KeyCode.Down))
				{
					animation.play("duck"+state);
				}else {
					var s = Math.abs(collision.velocityX) / collision.maxVelocityX;
					animation.frameRate = (1 / 60) * s + (1 - s) * (1 / 30) ;	
					if(s>0.5){
					animation.play("run" + state);
					}else {
					animation.play("walk" + state);	
					}
				}
			}
		}else{
			if (collision.velocityY > 0) {
				animation.play("fall"+state);
			}
			if (collision.velocityY < 0) {
				animation.play("jump"+state);
			}
		}
	
	}
	public function canBreak():Bool
	{
		return state == "Big";
	}
	
	public function onOverlapItem(item:ICollider,player:ICollider) 
	{
		if (Std.is(item.userData, Mushroom)) {
			(cast item.userData).die();
			if(state!="Big"){
				state = "Big";
				sprite.offsetY = offsetYBig;
				collision.height *= 2;
				collision.y -= collision.height / 2;
			}
		}
	}
	
	public function damage() 
	{
		if (invulnerableTime > 0) return;
		if (state == "Big") {
			state = "Small";
			
			collision.height /= 2;
			sprite.offsetY = offsetYSmall;
			collision.y += collision.height;
			invulnerableTime = 1;
		}else {
		die();	
		}
	}
	public function stompSomething()
	{
		collision.velocityY =-400;
	}
	override function onRender():Void 
	{
		playAnimation();
		sprite.x = collision.x;
		sprite.y = collision.y;
	}
}