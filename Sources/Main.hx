package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;





class Main {
	static var simulation:Simulation;
	static function update(): Void {
		simulation.onEnterFrame();
	}

	static function render(framebuffer: Framebuffer): Void {
		simulation.onRender(framebuffer);
	}
	
	public static function main() {
		System.init({title: "Kode Project", width: 800, height: 600,samplesPerPixel:2}, function() {
            // Avoid passing update/render directly so replacing
            // them via code injection works
			simulation = new Simulation(Level);
        //var t=new G();
			Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
			System.notifyOnRender(function (framebuffer) { render(framebuffer); });
		});
	}
}