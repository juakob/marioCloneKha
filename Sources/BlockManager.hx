package;

/**
 * ...
 * @author Joaquin
 */
class BlockManager extends Entity
{
	public var blockBounce:CollisionGroup;
	private var mapCollisions:CollisionTileMap;
	private var mapGraphics:TileSheet;
	private var chuncks:Entity;
	private var bouncBlocks:Entity;
	private var coins:Entity;
	
	private var layer:Layer;
	
	public function new(aMapCollision:CollisionTileMap,aMapDisplay:TileSheet,aLayer:Layer) 
	{
		super();
		blockBounce = new CollisionGroup();
		mapCollisions = aMapCollision;
		mapGraphics = aMapDisplay;
		
		chuncks = new Entity();
		chuncks.pool = true;
		addChild(chuncks);
		
		bouncBlocks = new Entity();
		bouncBlocks.pool = true;
		addChild(bouncBlocks);
		
		coins = new Entity();
		coins.pool = true;
		addChild(coins);
		
		layer = aLayer;

	}
	
	public function onOverlapRegular( aBlock:ICollider,aPlayer:ICollider)
	{
		var player:Player = cast (cast aPlayer).userData;
		
	//	if (player.collision.velocityY < 0) 
	{
			var block:CollisionBox = cast aBlock;
			var xTileId:Int = Std.int(block.x / mapCollisions.tileWidth);
			var yTileId:Int = Std.int(block.y / mapCollisions.tileHeight);
			if(player.canBreak()){	
				
				mapCollisions.changeTileId(xTileId, yTileId, -1);
				var bouncAnimation:BounceBlock = cast bouncBlocks.recycle(BounceBlock);
				bouncAnimation.reset(xTileId, yTileId, 0, -1, layer, blockBounce);//kill enemies when tile is broken
				
				player.hitBlock();
				createChunck(xTileId*mapCollisions.tileWidth , yTileId*mapCollisions.tileHeight , 0.5, -0.8);
				createChunck(xTileId*mapCollisions.tileWidth , yTileId*mapCollisions.tileHeight , -0.5, -0.8);
				createChunck(xTileId*mapCollisions.tileWidth , yTileId*mapCollisions.tileHeight , 0.5, -0.45);
				createChunck(xTileId*mapCollisions.tileWidth , yTileId*mapCollisions.tileHeight , -0.5, -0.45);
			}else {
				mapCollisions.changeTileId(xTileId, yTileId, 18);//empty image
				
				var bouncAnimation:BounceBlock = cast bouncBlocks.recycle(BounceBlock);
				bouncAnimation.reset(xTileId, yTileId, 1, 1, layer,blockBounce);
			}	
		}
		
	}
	public function onOverlapPrize( aBlock:ICollider,aPlayer:ICollider)
	{
		var player:Player = cast (cast aPlayer).userData;
		//if(player.collision.velocityY<0)
		{
			var block:CollisionBox = cast aBlock;
			var xTileId:Int = Std.int(block.x / mapCollisions.tileWidth);
			var yTileId:Int = Std.int(block.y / mapCollisions.tileHeight);
			mapCollisions.changeTileId(xTileId, yTileId, 18);//empty image
			var bouncAnimation:BounceBlock = cast bouncBlocks.recycle(BounceBlock);
			bouncAnimation.reset(xTileId, yTileId, 2, 5, layer,blockBounce);
			
			player.hitBlock();
			var id = mapCollisions.getTileId(xTileId, yTileId - 1);
			if ( id==-34)
			{
				trace("create mushroom");
				LevelData.items.createMushroom(xTileId * mapCollisions.tileWidth, yTileId * mapCollisions.tileHeight);
			}else
			if(id==-7){
				var coin:FlyingCoin = cast coins.recycle(FlyingCoin);
				coin.reset(xTileId, yTileId, layer);
			}
		}
	}
	
	public function hitBlock( aBlock:CollisionBox,aPlayer:CollisionBox) 
	{
		var tileId:Int = mapCollisions.getTileId2(aBlock.x, aBlock.y);
		
		if (tileId == 1 ) {
			onOverlapRegular(aBlock, aPlayer);
		}else
		if (tileId == 2 ) {
			onOverlapPrize(aBlock, aPlayer);
		}
	}
	function createChunck(aX:Float, aY:Float, dirX:Float, dirY:Float ):Void
	{
		var chunck:BlockChunk = cast chuncks.recycle(BlockChunk);
		chunck.reset(aX, aY, dirX * 250, dirY* 800+Math.random()*300,layer);
	}
	
}