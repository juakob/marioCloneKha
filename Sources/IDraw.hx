package;
import kha.Canvas;

/**
 * @author Joaquin
 */
interface IDraw 
{
	public var parent:Layer;
	function render(aFrameBuffer:Canvas,translation:Point):Void;
}