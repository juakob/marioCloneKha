package;

/**
 * ...
 * @author Joaquin
 */
class ItemFactory extends Entity
{
	private var mushrooms:Entity;
	private var itemLayer:Layer;
	public var collisions:CollisionGroup;
	public function new(aLayer:Layer) 
	{
		super();
		mushrooms = new Entity();
		mushrooms.pool = true;
		addChild(mushrooms);
		collisions = new CollisionGroup();
		itemLayer = aLayer;
	}
	public function createMushroom(aX:Float,aY:Float):Void
	{
		var mushroom:Mushroom = cast mushrooms.recycle(Mushroom);
		mushroom.reset(aX, aY, itemLayer, collisions);
	}
	
}