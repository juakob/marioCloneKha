package;
import kha.Color;
import kha.Framebuffer;

/**
 * ...
 * @author Joaquin
 */
class Level extends GameState
{
	var player1:Player;
	var layer:Layer = new Layer();
	var ground:CollisionBox;
	var tileMap:CollisionTileMap;
	var camera:Camera;
	var tilesheetDisplay:TileSheet;
	var blockManager:BlockManager;
	var items:ItemFactory;
	var enemies:EnemySpawner;
	
	public function new() 
	{
		super();
		
	}
	override public function load(aResources:Resources):Void 
	{
		aResources.addImage("mario3d");
		aResources.addImage("tiles64");
		aResources.addImage("goomba");
	}
	override public function init():Void 
	{
		stage.backgroundColor = 0xff6b88ff;
		player1 = new Player(stage);
		player1.collision.x = 32 * 3;
		player1.collision.y = 32*5;
		addChild(player1);
		
		var itemLayer:Layer = new Layer();
		stage.add(itemLayer);
		items=LevelData.items = new ItemFactory(itemLayer);
		addChild(items);
		LevelData.camera=camera = new Camera(800, 600);
		camera.limits(32, 212 * 32, 0, 600);
		addChild(camera);
		
		ground = new CollisionBox();
		ground.Static = true;
		ground.y = 600;
		ground.width = 800;
		ground.height = 100;
		var map:Array<Int> = negateTiles(Maps.map1(), [34, 7, 49]);//positions of items and enemies
		LevelData.map=tileMap = new CollisionTileMap(map, 32, 32, 214, 19);
		tilesheetDisplay = new TileSheet(map, "tiles64", 64, 64, 214, 19, 1, 0.5);
		stage.add(tilesheetDisplay);
		
		enemies = new EnemySpawner(tileMap, stage);
		addChild(enemies);
		
		
		blockManager = new BlockManager(tileMap, tilesheetDisplay,stage);
		addChild(blockManager);
	}
	
	function negateTiles(map1:Array<Int>, specialTiles:Array<Int>) :Array<Int>
	{
		for (i in 0...map1.length) 
		{
			for (tile in specialTiles) 
			{
				if (map1[i] == tile)
				{
					map1[i] *=-1;
				}
			}
		}
		return map1;
	}
	override function onUpdate(aDt:Float):Void 
	{
		//warning the callback return order is not granted in all cases yet
		tileMap.overlap(player1.collision,blocksVsPlayer );
		tileMap.collide(player1.collision);
		items.collisions.collide(tileMap);
		enemies.collisions.collide(enemies.collisions);
		enemies.collisions.collide(tileMap);	
		blockManager.blockBounce.overlap(enemies.collisions, enemyHitUnder);
		enemies.collisions.overlap(player1.collision, goombaVsMario);
		blockManager.blockBounce.overlap(items.collisions, itemVsBounceBlock);
		items.collisions.overlap(player1.collision, player1.onOverlapItem);
		camera.setTarget(player1.collision.x, player1.collision.y);
		if(player1.isDead())
        {
        changeState(new Level());
        }
	}
	
	function blocksVsPlayer(aBlock:ICollider,aPlayer:ICollider ) 
	{
	
		var block:CollisionBox = cast aBlock;
		var player:CollisionBox = cast aPlayer;
		var borderType:Int = tileMap.edgeType2(block.x, block.y);
		var deltaY:Float =  block.height+player.height-(Math.abs(block.y - player.y) + Math.abs(block.bottom() - player.bottom()));
		var deltaX:Float = block.width+player.width-(Math.abs(block.x - player.x) + Math.abs(block.right() - player.right()));
		if (player.y>block.y&&deltaY>0&&( deltaY<deltaX||deltaX<0))
		{
			
			if (player.topMiddle()<block.x && ((borderType&Sides.LEFT)>0))
			{
				cast (player.userData).pushLeft();
			}else
			if (player.topMiddle()>block.right() && ((borderType&Sides.RIGHT)>0))
			{
				cast (player.userData).pushRight();
			}else {
				if (player.topMiddle() > block.x && player.topMiddle() < block.right()){
				blockManager.hitBlock(block, player);
				}
			}
		}
		
	}
	
	function itemVsBounceBlock(aBlock:ICollider, aItem:ICollider ) 
	{
		
		var block:CollisionBox = cast aBlock;
		var item:CollisionBox = cast aItem;
		if (item.right() < (block.x + block.width* (1/4)))
		{
			cast item.userData.jumpLeft();
		}else
		if (item.x > (block.x + block.width* (3/4)))
		{
			cast item.userData.jumpRight();
		}
		cast item.userData.jump();
	}
	
	function enemyHitUnder(aBlock:ICollider, aGoomba:ICollider ) 
	{
		cast( aGoomba.userData).killFromBelow();
	}
	
	function goombaVsMario(aGoomba:ICollider, aPlayer:ICollider ) 
	{
		var goomba:Goomba = cast (cast aGoomba).userData;
		if (goomba.dyingStomp) return;
		var player:Player = cast (cast aPlayer).userData;
		if (player.collision.velocityY > 0||(player.collision.bottom()+20<goomba.collisions.bottom()&&player.invulnerableTime<0))
		{
			goomba.stomp();
			player.stompSomething();
		}else {
			player.damage();
		}
	}
	override function render():Void 
	{
		stage.x =-camera.screenToWorldX(0);
		stage.y =-camera.screenToWorldY(0);
		tilesheetDisplay.setViewArea( -stage.x, -stage.y,-stage.x+ 800,-stage.y+ 600);
		super.render();
	}
	override function onDestroy():Void 
	{
		LevelData.clear();
	}
	
	
}