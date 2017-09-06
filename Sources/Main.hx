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
			Scheduler.addTimeTask(update, 0, 1 / 60);
			System.notifyOnRender(render);
		});
	}
}
