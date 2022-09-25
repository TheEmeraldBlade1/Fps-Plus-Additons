package title;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

import lime.app.Application;
using StringTools;

class TitleVideo extends FlxState
{
	var oldFPS:Int = VideoHandler.MAX_FPS;
	var video:VideoHandler;
	var titleState = new TitleScreen();

	override public function create():Void
	{
		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end
		super.create();

		FlxG.sound.cache(Paths.music("klaskiiLoop"));

		if(!Main.novid){

			VideoHandler.MAX_FPS = 60;

			video = new VideoHandler();

			video.playMP4(Paths.video('klaskiiTitle'), function(){
				next();
				#if web
					VideoHandler.MAX_FPS = oldFPS;
				#end
			}, false, true);

			add(video);
			
		}
		else{
			next();
		}
	}

	override public function update(elapsed:Float){

		super.update(elapsed);

	}

	function next():Void{

		FlxG.camera.flash(FlxColor.WHITE, 60);
		FlxG.sound.playMusic(Paths.music("klaskiiLoop"), 0.75);
		Conductor.changeBPM(158);
		FlxG.switchState(titleState);

	}
	
}
