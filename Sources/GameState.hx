package ;
import kha.Canvas;

/**
 * ...
 * @author joaquin
 */
class GameState extends Entity 
{
    var g4Renderer:G4Renderer;
	var stage:Stage;
	var pos:Point;
	public function new() 
	{
        g4Renderer = new G4Renderer();
		stage = new Stage();
		pos = new Point();
		super();
	}
	public function load(aResources:Resources):Void{
		
	}
	public function init():Void {
		g4Renderer.setAssets();
	}
	public function changeState(state:GameState):Void{
		Simulation.i.changeState(state);
	}
	public function draw(aFramebuffer:Canvas):Void
	{
        g4Renderer.render(aFramebuffer);
		aFramebuffer.g2.begin(false,stage.backgroundColor);
        aFramebuffer.g2.imageScaleQuality = kha.graphics2.ImageScaleQuality.Low;
		stage.render(aFramebuffer,pos);
		aFramebuffer.g2.end();
	}
	
	public function onActivate() 
	{
		
	}
	
	public function onDesactivate() 
	{
		
	}
	
}