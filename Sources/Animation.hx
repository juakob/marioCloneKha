package;

/**
 * ...
 * @author Joaquin
 */
class Animation extends Entity
{
	var sprite:SpriteSheet;
	var animations:Array<String>;
	var frames:Array<Array<Int>>;
	var rates:Array<Float>;
	var loop:Array<Bool>;
	public var frameRate:Float;
	var playing:Bool;
	var frame:Int;
	var totalFrames:Int;
	var currentAnimation:Int;
	var elapsed:Float=0;
	var currentIsLooping:Bool;
	
	public function new(aSprite:SpriteSheet) 
	{
		super();
		sprite = aSprite;
		animations = new Array();
		frames = new Array();
		loop = new Array();
		rates = new Array();
		
	}
	public function addAnimation(aName:String, aFrames:Array<Int>,aRate:Float=1/30,aLoop:Bool=true)
	{
		animations.push(aName);
		frames.push(aFrames);
		loop.push(aLoop);
		rates.push(aRate);
	}
	public function addAnimation2(aName:String,aInitialFrame:Int,aFinalFrame:Int,aRate:Float=1/30,aLoop:Bool=true)
	{
		animations.push(aName);
		var myFrames:Array<Int> = new Array();
		for (i in aInitialFrame...(aFinalFrame+1)) 
		{
			myFrames.push(i);
		}
		frames.push(myFrames);
		loop.push(aLoop);
		rates.push(aRate);
	}
	public function play(aAnimation:String, aForce:Bool = false)
	{
		var index:Int = animations.indexOf(aAnimation);
		if (index ==-1) throw "animation seq " + aAnimation + " not found";
		if (index == currentAnimation && !aForce) return;
		
		currentAnimation = index;
		totalFrames = frames[index].length;
		currentIsLooping = loop[index];
		frameRate = rates[index];
		frame = 0;
		playing = true;
		sprite.frame = frames[currentAnimation][frame];
	}
	override function onUpdate(aDt:Float):Void 
	{
		if (playing) 
		{
			elapsed += aDt;
			if (elapsed >= frameRate)
			{
				var increment = Std.int(elapsed / frameRate);
				frame += increment;
				elapsed -= increment * frameRate;
				if (frame >= totalFrames) 
				{
					if (currentIsLooping)
					{
						frame= (frame-totalFrames)%totalFrames;
						
					}else {
						frame = totalFrames - 1;
						playing = false;
					}
				}
				sprite.frame = frames[currentAnimation][frame];
			}
		}
	}
	
	function get_display():IDraw 
	{
		return sprite;
	}
}