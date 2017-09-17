package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	static function update(): Void {

	}

	static function render(framebuffer: Framebuffer): Void {

	}

	public static function main() {
		System.init({title: "Kode Project", width: 800, height: 600}, function() {
            // Avoid passing update/render directly so replacing
            // them via code injection works
			Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
			System.notifyOnRender(function () { render(); });
		});
	}
}
