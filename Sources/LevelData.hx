package;

/**
 * ...
 * @author Joaquin
 */
class LevelData
{

	public static var map:CollisionTileMap;
	public static var items:ItemFactory;
	public static var camera:Camera;
	public static function clear() {
		map = null;
		items = null;
		camera = null;
	}
	
}