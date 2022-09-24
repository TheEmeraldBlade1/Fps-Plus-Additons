package config;

import transition.data.*;
import transition.*;

import flixel.FlxState;
import openfl.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class ConfigMenu extends MusicBeatState
{

	public static var startSong = true;

	public static var exitTo:Class<Dynamic>;

	var configText:FlxText;
	var descText:FlxText;
	var tabDisplay:FlxText;
	var configSelected:Int = 0;
	
	var offsetValue:Float;
	var accuracyType:String;
	var accuracyTypeInt:Int;
	var accuracyTypes:Array<String> = ["none", "simple", "complex"];
	var healthValue:Int;
	var healthDrainValue:Int;
	var comboValue:Int;
	var comboTypes:Array<String> = ["world", "hud", "off"];
	var downValue:Bool;
	var scrollValue:Bool;
	var glowValue:Bool;
	var randomTapValue:Int;
	var randomTapTypes:Array<String> = ["never", "not singing", "always"];
	var noCapValue:Bool;
	var scheme:Int;
	var dimValue:Int;

	var tabKeys:Array<String> = [];
	
	var canChangeItems:Bool = true;

	var leftRightCount:Int = 0;

	final genericOnOff:Array<String> = ["on", "off"];
	
	final settingText:Array<String> = [
									"NOTE OFFSET", 
									"ACCURACY DISPLAY", 
									"UNCAPPED FRAMERATE",
									"NEW INPUT WHEN?",
									"HP GAIN MULTIPLIER",
									"HP DRAIN MULTIPLIER",
									"DOWNSCROLL",
									"NOTE GLOW",
									"COMBO DISPLAY",
									"BACKGROUND DIM",
									"[CACHE SETTINGS]",
									"CONTROLLER SCHEME",
									"[EDIT KEY BINDS]",
									"HIGH SCROLL SPEED"
									];
		
	//Any descriptions that say TEMP are replaced with a changing description based on the current config setting.
	final settingDesc:Array<String> = [
									"\nAdjust note timings.\nPress \"ENTER\" to start the offset calibration." + (FlxG.save.data.ee1?"\nHold \"SHIFT\" to force the pixel calibration.\nHold \"CTRL\" to force the normal calibration.":""), 
									"\nWhat type of accuracy calculation you want to use. Simple is just notes hit / total notes and fps plus rating system. Complex also factors in how early or late a note was.", 
									#if desktop "\nUncaps the framerate during gameplay." #else "Disabled on Web builds." #end,
									"\nTEMP",
									"\nModifies how much Health you gain when hitting a note.",
									"\nModifies how much Health you lose when missing a note.",
									"\nMakes notes appear from the top instead the bottom.",
									"\nMakes note arrows glow if they are able to be hit.",
									"\nTEMP",
									"\nAdjusts how dark the background is.\nIt is recommended that you use the HUD combo display with a high background dim.",
									"\nChange what assets the game keeps cached.",
									"\nTEMP",
									"\nChange key binds.",
									"\nForce songs to have high scroll speed"
									];

	final ghostTapDesc:Array<String> = [
									"\nAny key press that isn't for a valid note will cause you to miss.", 
									"\nYou can only  miss while you need to sing.", 
									"\nYou cannot miss unless you do not hit a note.\n[Note that this makes the game very easy and can remove a lot of the challenge.]"
									];					

	final comboDisplayDesc:Array<String> = [
									"\nRatings and combo count are a part of the world and move around with the camera.", 
									"\nRatings and combo count are a part of the hud and stay in a static position.", 
									"\nRatings and combo count are hidden."
									];

	final controlSchemes:Array<String> = [
									"\nDEFAULT", 
									"\nALT 1", 
									"\nALT 2",
									"\n[CUSTOM]"
									];

	final controlSchemesDesc:Array<String> = [
									"\nLEFT: DPAD LEFT / X (SQUARE) / LEFT TRIGGER\nDOWN: DPAD DOWN / X (CROSS) / LEFT BUMPER\nUP: DPAD UP / Y (TRIANGLE) / RIGHT BUMPER\nRIGHT: DPAD RIGHT / B (CIRCLE) / RIGHT TRIGGER", 
									"\nLEFT: DPAD LEFT / DPAD DOWN / LEFT TRIGGER\nDOWN: DPAD UP / DPAD RIGHT / LEFT BUMPER\nUP: X (SQUARE) / Y (TRIANGLE) / RIGHT BUMPER\nRIGHT: A (CROSS) / B (CIRCLE) / RIGHT TRIGGER", 
									"\nLEFT: ALL DPAD DIRECTIONS\nDOWN: LEFT BUMPER / LEFT TRIGGER\nUP: RIGHT BUMPER / RIGHT TRIGGER\nRIGHT: ALL FACE BUTTONS",
									"\nPress A (CROSS) to change controller binds."
									];

									


	override function create()
	{	

		openfl.Lib.application.window.title = "Friday Night Funkin' FPS Plus - Option";
		openfl.Lib.current.stage.frameRate = 144;

		if(exitTo == null){
			exitTo = MainMenuState;
		}

		if(startSong)
			FlxG.sound.playMusic(Paths.music('configurator'));
		else
			startSong = true;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFF5C6CA5;
		add(bg);
		
		Config.reload();
		
		offsetValue = Config.offset;
		accuracyType = Config.accuracy;
		accuracyTypeInt = accuracyTypes.indexOf(Config.accuracy);
		healthValue = Std.int(Config.healthMultiplier * 10);
		healthDrainValue = Std.int(Config.healthDrainMultiplier * 10);
		comboValue = Config.comboType;
		downValue = Config.downscroll;
		scrollValue = Config.HighSpeed;
		glowValue = Config.noteGlow;
		randomTapValue = Config.ghostTapType;
		noCapValue = Config.noFpsCap;
		scheme = Config.controllerScheme;
		dimValue = Config.bgDim;
		
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		var optionTitle:FlxSprite = new FlxSprite(0, 55);
		optionTitle.frames = tex;
		optionTitle.animation.addByPrefix('selected', "options white", 24);
		optionTitle.animation.play('selected');
		optionTitle.scrollFactor.set();
		optionTitle.antialiasing = true;
		optionTitle.updateHitbox();
		optionTitle.screenCenter(X);
			
		add(optionTitle);
			
		
		configText = new FlxText(0, 215, 1280, "", 42);
		configText.scrollFactor.set(0, 0);
		configText.setFormat(Paths.font("Funkin-Bold", "otf"), 42, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		configText.borderSize = 3;
		configText.borderQuality = 1;
		
		descText = new FlxText(320, 638, 640, "", 20);
		descText.scrollFactor.set(0, 0);
		descText.setFormat(Paths.font("vcr"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//descText.borderSize = 3;
		descText.borderQuality = 1;

		tabDisplay = new FlxText(5, FlxG.height - 53, 0, Std.string(tabKeys), 16);
		tabDisplay.scrollFactor.set();
		tabDisplay.visible = false;
		tabDisplay.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		var backText = new FlxText(5, FlxG.height - 37, 0, "ESCAPE - Back to Menu\nR - Reset to Defaults\n", 16);
		backText.scrollFactor.set();
		backText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(configText);
		add(descText);
		add(tabDisplay);
		add(backText);

		textUpdate();

		customTransIn = new WeirdBounceIn(0.6);
		customTransOut = new WeirdBounceOut(0.6);

		super.create();

	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{

		
	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(canChangeItems && !FlxG.keys.pressed.TAB){
			if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}

				if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
				
				switch(configSelected){
					case 0: //Offset
						if (controls.RIGHT_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							offsetValue += 1;
						}
						
						if (controls.LEFT_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							offsetValue -= 1;
						}
						
						if (controls.RIGHT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64) {
								offsetValue += 1;
								textUpdate();
							}
						}
						
						if (controls.LEFT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64) {
								offsetValue -= 1;
								textUpdate();
							}
						}
						
						if(!controls.RIGHT && !controls.LEFT)
						{
							leftRightCount = 0;
						}

						if(FlxG.keys.justPressed.ENTER){
							canChangeItems = false;
							FlxG.sound.music.fadeOut(0.3);
							writeToConfig();
							AutoOffsetState.forceEasterEgg = FlxG.keys.pressed.SHIFT ? 1 : (FlxG.keys.pressed.CONTROL ? -1 : 0);
							switchState(new AutoOffsetState());
						}
						
					case 1: //Accuracy
						if (controls.RIGHT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								accuracyTypeInt += 1;
							}
							
							if (controls.LEFT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								accuracyTypeInt -= 1;
							}
							
							if (accuracyTypeInt > 2)
								accuracyTypeInt = 0;
							if (accuracyTypeInt < 0)
								accuracyTypeInt = 2;
								
							accuracyType = accuracyTypes[accuracyTypeInt];
					case 2: //FPS Cap
						#if desktop
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							noCapValue = !noCapValue;
						}
						#end
					case 3: //Random Tap 
						if (controls.RIGHT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								randomTapValue += 1;
							}
							
							if (controls.LEFT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								randomTapValue -= 1;
							}
							
							if (randomTapValue > 2)
								randomTapValue = 0;
							if (randomTapValue < 0)
								randomTapValue = 2;
					case 4: //Health Multiplier
						if (controls.RIGHT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								healthValue += 1;
							}
							
							if (controls.LEFT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								healthValue -= 1;
							}
							
							if (healthValue > 1000)
								healthValue = 0;
							if (healthValue < 0)
								healthValue = 1000;
								
						if (controls.RIGHT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64 && leftRightCount % 10 == 0) {
								healthValue += 1;
								textUpdate();
							}
						}
						
						if (controls.LEFT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64 && leftRightCount % 10 == 0) {
								healthValue -= 1;
								textUpdate();
							}
						}
						
						if(!controls.RIGHT && !controls.LEFT)
						{
							leftRightCount = 0;
						}
						
						if(!controls.RIGHT && !controls.LEFT)
						{
							leftRightCount = 0;
						}				
					case 5: //Health Drain Multiplier
						if (controls.RIGHT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								healthDrainValue += 1;
							}
							
							if (controls.LEFT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								healthDrainValue -= 1;
							}
							
							if (healthDrainValue > 1000)
								healthDrainValue = 0;
							if (healthDrainValue < 0)
								healthDrainValue = 1000;
								
						if (controls.RIGHT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64 && leftRightCount % 10 == 0) {
								healthDrainValue += 1;
								textUpdate();
							}
						}
						
						if (controls.LEFT)
						{
							leftRightCount++;
							
							if(leftRightCount > 64 && leftRightCount % 10 == 0) {
								healthDrainValue -= 1;
								textUpdate();
							}
						}
						
						if(!controls.RIGHT && !controls.LEFT)
						{
							leftRightCount = 0;
						}
					case 6: //Downscroll
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							downValue = !downValue;
						}
					case 7: //Note Glow
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							glowValue = !glowValue;
						}
					case 8: //Combo Display
						if (controls.RIGHT_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							comboValue += 1;
						}
						
						if (controls.LEFT_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							comboValue -= 1;
						}
						
						if (comboValue >= comboTypes.length)
							comboValue = 0;
						if (comboValue < 0)
							comboValue = comboTypes.length - 1;
					case 9: //BG Dim
						if (controls.RIGHT_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							dimValue += 1;
						}
						
						if (controls.LEFT_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							dimValue -= 1;
						}
						
						if (dimValue > 10)
							dimValue = 0;
						if (dimValue < 0)
							dimValue = 10;

					case 10: //Preload settings
						if (controls.ACCEPT) {
							#if desktop
							FlxG.sound.play(Paths.sound('scrollMenu'));
							canChangeItems = false;
							writeToConfig();
							switchState(new CacheSettings());
							CacheSettings.returnLoc = new ConfigMenu();
							#end
						}
					
					case 11: //Controller Stuff
						if (controls.RIGHT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								scheme += 1;
							}
							
							if (controls.LEFT_P)
							{
								FlxG.sound.play(Paths.sound('scrollMenu'));
								scheme -= 1;
							}
							
							if (scheme >= controlSchemes.length)
								scheme = 0;
							if (scheme < 0)
								scheme = controlSchemes.length - 1;

							if (controls.ACCEPT && scheme == controlSchemes.length - 1) {
								FlxG.sound.play(Paths.sound('scrollMenu'));
								canChangeItems = false;
								writeToConfig();
								switchState(new KeyBindMenuController());
							}

					case 12: //Binds
						if (controls.ACCEPT) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							canChangeItems = false;
							writeToConfig();
							switchState(new KeyBindMenu());
						}
						case 13: //scroll speed high
						if (controls.RIGHT_P || controls.LEFT_P || controls.ACCEPT) {
							FlxG.sound.play(Paths.sound('scrollMenu'));
							scrollValue = !scrollValue;
						}
					
			}
		}
		else if(FlxG.keys.pressed.TAB){
			if(FlxG.keys.justPressed.ANY){
				if(FlxG.keys.getIsDown()[0].ID.toString() != "TAB"){
					tabKeys.push(FlxG.keys.getIsDown()[0].ID.toString());
				}		
			}
		}

		if(FlxG.keys.justPressed.TAB){
			tabDisplay.visible = true;
		}

		if(FlxG.keys.justReleased.TAB){
			secretPresetTest(tabKeys);
			tabKeys = [];
			tabDisplay.visible = false;
		}

		if (controls.BACK && canChangeItems)
		{
			writeToConfig();
			exit();
		}

		if (FlxG.keys.justPressed.R && canChangeItems)
		{
			Config.resetSettings();
			FlxG.save.data.ee1 = false;
			exit();
		}

		super.update(elapsed);
		
		if(controls.LEFT_P || controls.RIGHT_P || controls.UP_P || controls.DOWN_P || controls.ACCEPT || FlxG.keys.justPressed.ANY)
			textUpdate();
		
	}

	function changeItem(huh:Int = 0)
	{
		configSelected += huh;
			
		if (configSelected > settingText.length - 1)
			configSelected = 0;
		if (configSelected < 0)
			configSelected = settingText.length - 1;
			
	}

	function textUpdate(){

        configText.clearFormats();
        configText.text = "";

        for(i in 0...settingText.length){

            var sectionStart = configText.text.length;
            configText.text += settingText[i] + getSetting(i) + "\n";
			var sectionEnd = configText.text.length - 1;

            if(i == configSelected){
				//Might change to applyMarkup later.
                configText.addFormat(new FlxTextFormat(0xFFFFFF00), sectionStart, sectionEnd);
            }

        }

		switch(configSelected){

			case 3:
				descText.text = ghostTapDesc[randomTapValue];
				
			case 8:
				descText.text = comboDisplayDesc[comboValue];

			case 10:
				descText.text = settingDesc[configSelected];
				#if web
				descText.text = "Disabled.";
				#end
				
			case 11:
				descText.text = controlSchemesDesc[scheme];

			default:
				descText.text = settingDesc[configSelected];

		}

		tabDisplay.text = Std.string(tabKeys);

    }

	function getSetting(r:Int):String{

		switch(r){

			case 0: return ": " + offsetValue;
			case 1: return ": " + accuracyType;
			case 2: #if desktop return ": " + genericOnOff[noCapValue?0:1]; #else return ": disabled"; #end
			case 3: return ": " + randomTapTypes[randomTapValue];
			case 4: return ": " + healthValue / 10.0;
			case 5: return ": " + healthDrainValue / 10.0;
			case 6: return ": " + genericOnOff[downValue?0:1];
			case 7: return ": " + genericOnOff[glowValue?0:1];
			case 8: return ": " + comboTypes[comboValue];
			case 9: return ": " + (dimValue * 10) + "%";
			case 11: return ": " + controlSchemes[scheme];

		}

		return "";

	}

	function exit(){
		canChangeItems = false;
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('cancelMenu'));
		switchState(Type.createInstance(exitTo, []));
		exitTo = null;
	}

	function secretPresetTest(_combo:Array<String>):Void{

		var combo:String = "";

		for(x in _combo){
			combo += x;
		}

		switch(combo){

			case "KADE":
				System.exit(0); //I am very funny.
			case "ROZE":
				System.exit(0); //I am very funny.
			case "CVAL":
				System.exit(0); //I am very funny.
			case "GOTOHELLORSOMETHING":
				System.exit(0); //I am very funny.

		}

	}

	function writeToConfig(){
		Config.write(offsetValue, accuracyType, healthValue / 10.0, healthDrainValue / 10.0, comboValue, downValue, scrollValue, glowValue, randomTapValue, noCapValue, scheme, dimValue);
	}

}
