package ;

import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;

class Input
{
	public static var i(default, null):Input = null;
	public static var inst(get, null): Input = null;
	public static function get_inst():Input
	{
		return i;
	}
	public static function init():Void
	{
		i = new Input();
		i.subscibeInput();
	}
	
	private var mMouseIsDown:Bool;
	private var mMousePressed:Bool;
	private var mMouseReleased:Bool;
	
	private var mKeysDown:Array<Int>;
	private var mKeysPressed:Array<Int>;
	private var mKeysReleased:Array<Int>;
	
	private var mTouchPos:Array <Int>;
	private var mTouchActive:Array <Bool>;
	public var activeTouchSpots(default,null):Int;
	
	
	private var mMousePosition:Point;
	static public  var TOUCH_MAX:Int = 6;
	
	public var screenScale(default, null):Point;
	
	public function new() 
	{
		screenScale = new Point(1,1);
		
		mMouseIsDown = false;
		mMousePressed = false;
		mMouseReleased = false;
		
		mKeysDown = new Array();
		mKeysPressed = new Array();
		mKeysReleased = new Array();
		
		activeTouchSpots = 0;
		mTouchActive = new Array();
		mTouchPos = new Array();
		for (i in 0...TOUCH_MAX)
		{
			mTouchPos.push(0);
			mTouchPos.push(0);
			mTouchActive.push(false);
		}
		
		mMousePosition = new Point();
	}
	
	private function subscibeInput() 
	{
		Keyboard.get().notify(onKeyDown, onKeyUp);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
		var surface = Surface.get();
		if (surface != null)
		{
		surface.notify(onTouchStart, onTouchEnd, onTouchMove);
		}
	}
	
	function onTouchMove(id:Int,x:Int,y:Int) 
	{
		mTouchPos[id * 2] = x;
		mTouchPos[id*2+1] = y;
	}
	
	function onTouchEnd(id:Int,x:Int,y:Int) 
	{
		mTouchActive[id] = false;
		--activeTouchSpots;
	}
	
	function onTouchStart(id:Int,x:Int,y:Int) 
	{
		++activeTouchSpots;
		mTouchActive[id] = true;
		mTouchPos[id * 2] = x;
		mTouchPos[id*2+1] = y;
	}
	
	function onMouseMove(x:Int,y:Int,speedX:Int,speedY:Int):Void 
	{
		mMousePosition.x = x;
		mMousePosition.y = y;
	}
	
	function onMouseUp(aButton:Int,x:Int,y:Int):Void 
	{
		mMousePosition.x = x;
		mMousePosition.y = y;
		mMouseReleased =  (aButton == 0);
		mMouseIsDown = !(aButton == 0);
	}
	
	function onMouseDown(aButton:Int,x:Int,y:Int):Void 
	{
		mMousePosition.x = x;
		mMousePosition.y = y;
		mMousePressed = mMouseIsDown = (aButton == 0);
	}
	
	function onKeyDown(aKey:KeyCode):Void
	{	
		if ( mKeysDown.indexOf(cast aKey) == -1) {
			mKeysDown.push(cast aKey);
			mKeysPressed.push(cast aKey);
		}
	}
	
	function onKeyUp(aKey:KeyCode):Void
	{
		var vIndex:Int = mKeysDown.indexOf(cast aKey);
		if ( vIndex != -1 ) {
			mKeysDown.splice(vIndex, 1);
		}
		mKeysReleased.push(cast aKey);
	}
	
	public function update():Void 
	{
		mMousePressed  = false;
		mMouseReleased = false;
		
		mKeysPressed.splice(0,mKeysPressed.length);
		mKeysReleased.splice(0, mKeysReleased.length);
		
	}
		/// Keyboard functions that operate on strings of length 1
	public function isKeyDown(aCharacter:String):Bool {
		var vKey:Int = aCharacter.charCodeAt(0);
		return mKeysDown.indexOf(vKey) != -1;
	}
	public function isKeyPressed(aCharacter:String):Bool {
		var vKey:Int = aCharacter.charCodeAt(0);
		return mKeysPressed.indexOf(vKey) != -1;
	}
	public function isKeyReleased(aCharacter:String):Bool {
		var vKey:Int = aCharacter.charCodeAt(0);
		return mKeysReleased.indexOf(vKey) != -1;
	}
	
	/// Keyboard functions that operate on KeyCodes from Keyboard class.
	public function isKeyCodeDown(aKeyCode:KeyCode):Bool {
		return mKeysDown.indexOf(cast aKeyCode) != -1;
	}
	public function isKeyCodePressed(aKeyCode:KeyCode):Bool {
		return mKeysPressed.indexOf(cast aKeyCode) != -1;
	}
	public function isKeyCodeReleased(aKeyCode:KeyCode):Bool {
		return mKeysReleased.indexOf(cast aKeyCode) != -1;
	}
	
	/// Mouse functions
	public function isMouseDown():Bool {
		return mMouseIsDown;
	}
	public function isMousePressed():Bool {
		return mMousePressed;
	}
	public function isMouseReleased():Bool {
		return mMouseReleased;
	}
	public  function getMouseX():Float {
		return mMousePosition.x*screenScale.x;
	}
	public  function getMouseY():Float {
		return mMousePosition.y*screenScale.y;
	}
	
	
	// Touch functions

	public  function touchX(id:Int):Float
	{
		return mTouchPos[id * 2] * screenScale.x;
	}
	public  function touchY(id:Int):Float
	{
		return mTouchPos[id * 2+1] * screenScale.y;
	}
	public  function touchActive(id:Int):Bool
	{
		return mTouchActive[id];
	}

}