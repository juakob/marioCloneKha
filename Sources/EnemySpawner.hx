package;

/**
 * ...
 * @author Joaquin
 */
class EnemySpawner extends Entity
{
	public var collisions:CollisionGroup;
	var events:Array<EnemySpawnPos>;
	var goombaPool:Entity;
	var layer:Layer;
	
	public function new(map:CollisionTileMap,aLayer:Layer) 
	{
		super();
		goombaPool = new Entity();
		goombaPool.pool = true;
		addChild(goombaPool);
		layer = aLayer;
		collisions = new CollisionGroup();
		events = new Array();
		//we create them in order of spawning
		for (x in 0...map.widthIntTiles) 
		{
			for (y in 0...map.heightInTiles)
			{
				if (map.getTileId(x,y) ==-49)
				{
					var event:EnemySpawnPos = new EnemySpawnPos();
					event.x = x * map.tileWidth;
					event.y = y * map.tileHeight;
					event.type = EnemyType.Goomba;
					events.push(event);
				}
			}
		}
		
	}
	override function onUpdate(aDt:Float):Void 
	{
		if (events.length > 0)
		{
			var event = events[0];
			if (LevelData.camera.isVisible(event.x, event.y))
			{
				createEnemy(event);
				events.shift();
			}
		}
	}
	
	function createEnemy(event:EnemySpawnPos) 
	{
		if (event.type == EnemyType.Goomba)
		{
			var goomba:Goomba = cast goombaPool.recycle(Goomba);
			goomba.reset(event.x, event.y, layer, collisions);
		}
	}
	
}