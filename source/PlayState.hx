package;

import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl3.*;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;



#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public static var dad:Character;
	public static var dadAgain:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
	public static var boyfriendAgain:Boyfriend;
	public static var runningGoblin:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	private var zooming:Bool = true;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBarThingy:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;
	public static var noBlackShit:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	public static var videoDialogue:Int;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var goblinDeath:FlxSprite;
	var babaPopup:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var crib:FlxSprite;
	var floorSkew:FlxSkewedSprite;

	var chairummmm:FlxSprite;
	
	var chair2:FlxSprite;
	var table2:FlxSprite;
	var monitor:FlxSprite;
	var pot:FlxSprite;

	var bgevil:FlxSprite;
	var epiclight:FlxSprite;
	var windowpoppers:FlxSprite;

	var fleedgoblin:FlxSprite;
	var fleedbaby:FlxSprite;
	var coolshadergayshitlol:Bool = true;
	

	var blackUmm:FlxSprite;

	var timerLol:Float = 0;

	var fc:Bool = true;

	var start:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var healthLimit:Float = 2;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var goblinTurn:Bool = false;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Float> = [];

	private var executeModchart = false;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }
	var dadAgainSinging:Bool = false;
	var dadAgainExist:Bool = false;
	var dadSinging:Bool = true;
	var boyfriendAgainSinging:Bool = false;
	var boyfriendAgainExist:Bool = false;
	var runningGoblinSinging:Bool = false;
	var runningGoblinExist:Bool = false;
	var boyfriendSigning:Bool =true;

	var poopmario:FlxSprite;

	var filters:Array<BitmapFilter> = [];
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;


	override public function create()
	{
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + Conductor.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + FlxG.save.data.botplay);
	
		//dialogue shit

		//shader sus
		filterMap = [
			"Grain" => {
				var shader = new Grain();
				{
					filter: new ShaderFilter(shader),
					onUpdate: function()
					{
						#if (openfl >= "8.0.0")
						shader.uTime.value = [Lib.getTimer() / 1000];
						#else
						shader.uTime = Lib.getTimer() / 1000;
						#end
					}
				}
			}
		];

		
			
		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dad battle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'nap-time':
				dialogue = CoolUtil.coolTextFile(Paths.txt('nap-time/dialogue'));
			case 'kidz-bop':
				dialogue = CoolUtil.coolTextFile(Paths.txt('kidz-bop/dialogue'));
			case 'baby-blue':
				dialogue = CoolUtil.coolTextFile(Paths.txt('baby-blue/dialogue'));
			case 'babys-revenge':
				dialogue = CoolUtil.coolTextFile(Paths.txt('babys-revenge/dialogue'));
			case 'un-adieu':
				dialogue = CoolUtil.coolTextFile(Paths.txt('un-adieu/dialogue'));
			case 'temper-tantrum':
				dialogue = CoolUtil.coolTextFile(Paths.txt('temper-tantrum/dialogue'));
			case 'trackstar':
				dialogue = CoolUtil.coolTextFile(Paths.txt('trackstar/dialogue'));
			case 'baby-bob':
				dialogue = CoolUtil.coolTextFile(Paths.txt('baby-bob/dialogue'));
			case 'just-like-you':
				dialogue = CoolUtil.coolTextFile(Paths.txt('just-like-you/dialogue'));
				//retweet if your a child rapist :) BRUH WHAT
			case 'insignificance':
				if(videoDialogue == 1)
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('insignificance/1'));
				}
				//this is such a bandaid fix lol
				if(videoDialogue == 3)
				{
					dialogue = CoolUtil.coolTextFile(Paths.txt('insignificance/2'));
				}
			case 'babys-lullaby':
				dialogue = CoolUtil.coolTextFile(Paths.txt('babys-lullaby/dialogue'));
			case 'rebound':
				dialogue = CoolUtil.coolTextFile(Paths.txt('rebound/dialogue'));
			case 'four-eyes':
				trace(videoDialogue);
				videoDialogue += 1;
				if(videoDialogue == 1)
				{
					trace(videoDialogue);
					dialogue = CoolUtil.coolTextFile(Paths.txt('four-eyes/1'));
				}
				//this is such a bandaid fix lol
				else
				{
					trace(videoDialogue);
					dialogue = CoolUtil.coolTextFile(Paths.txt('four-eyes/2'));
				}
		}

		switch(SONG.stage)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = true;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = true;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			case 'crib':
				{
						curStage = 'crib';
						defaultCamZoom = 1;
						var bg:FlxSprite = new FlxSprite(-200, -540).loadGraphic(Paths.image('floor'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);
				}
			case 'crib2':
				{
						curStage = 'crib2';
						defaultCamZoom = 1;
						var bg:FlxSprite = new FlxSprite(-200, -540).loadGraphic(Paths.image('floor2'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);
				}			
			case 'street':
				{
						curStage = 'street';
						defaultCamZoom = 0.9;
						var bg:FlxSprite = new FlxSprite(-420, -188).loadGraphic(Paths.image('street'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);
				}		
			case 'crib3':
				{
						curStage = 'crib3';
						defaultCamZoom = 1;
						var hallowTex = Paths.getSparrowAtlas('brokencrib');

						halloweenBG = new FlxSprite(-275, -100);
						halloweenBG.scrollFactor.set(1, 1);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'brokenhouse');
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = true;
						add(halloweenBG);
				}
			case 'dream':
				{
						curStage = 'dream';
						defaultCamZoom = 1.1;

						var dreamyThing:FlxSprite = new FlxSprite(-170, -100).loadGraphic(Paths.image('dreambg'));
						dreamyThing.scrollFactor.set();
						add(dreamyThing);
						wiggleShit.effectType = WiggleEffectType.FLAG;
						wiggleShit.waveAmplitude = 0.1;
						wiggleShit.waveFrequency = 2;
						wiggleShit.waveSpeed = 1;
						dreamyThing.shader = wiggleShit.shader;

						var bg:FlxSprite = new FlxSprite(-120, -120).loadGraphic(Paths.image('flor'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						add(bg);

						var hallowTex = Paths.getSparrowAtlas('dreamtv');
						halloweenBG = new FlxSprite(135	, 125);
						halloweenBG.scrollFactor.set(0.9, 0.9);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'true');
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = true;
						add(halloweenBG);
						bobmadshake = new FlxSprite( -198, -118).loadGraphic(Paths.image('bobscreen', 'shared'));
						bobmadshake.scrollFactor.set(0, 0);
						bobmadshake.visible = false;
							
						bobsound = new FlxSound().loadEmbedded(Paths.sound('bobscreen'));
				}		
			case 'phlox':
				{
					curStage = 'phlox';
					defaultCamZoom = 1.0;

					var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('phloxbg'));
					bg.antialiasing = true;
					bg.scrollFactor.set();
					bg.active = false;
					add(bg);
					
					var phloxtweets:FlxSprite = new FlxSprite(-170, 120).loadGraphic(Paths.image('gayshit'));
					phloxtweets.antialiasing = true;
					phloxtweets.scrollFactor.set(0.6, 0.6);
					phloxtweets.active = false;
					add(phloxtweets);

					var ground:FlxSprite = new FlxSprite(-350, 780).loadGraphic(Paths.image('phloxground'));
					ground.setGraphicSize(Std.int(ground.width * 1.7));
					ground.antialiasing = true;
					ground.scrollFactor.set(0.8, 0.8);
					ground.active = false;
					add(ground);

					var phloxsign:FlxSprite = new FlxSprite(600, 430).loadGraphic(Paths.image('phloxsign'));
					phloxsign.antialiasing = true;
					phloxsign.scrollFactor.set(0.9, 0.9);
					phloxsign.active = false;
					add(phloxsign);

					var babaTex = Paths.getSparrowAtlas('BABA');
					babaPopup = new FlxSprite(-30, -30);
					babaPopup.frames = babaTex;
					babaPopup.animation.addByPrefix('baba', "BABA!", 23);
					babaPopup.antialiasing = true;
					babaPopup.scrollFactor.set(0, 0);
					babaPopup.visible = false;
				}
			case 'evilhospital':
			{
					curStage = 'evilhospital';

					defaultCamZoom = 0.9;

					var bg:FlxSprite = new FlxSprite(-320, -100).loadGraphic(Paths.image('evilhospital'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 1.1));
					bg.updateHitbox();
					add(bg);

					var hallowTex = Paths.getSparrowAtlas('windowbrocken');
					halloweenBG = new FlxSprite(-304, 138);
					halloweenBG.scrollFactor.set(0.9, 0.9);
					halloweenBG.scale.set(1.2, 1.2);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'evil window instance');
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = true;
					add(halloweenBG);

					chair2 = new FlxSprite(1149, 115).loadGraphic(Paths.image('evilchair'));
					chair2.antialiasing = true;
					chair2.scrollFactor.set(0.9, 0.9);
					chair2.active = false;
					chair2.visible = false;
					chair2.setGraphicSize(Std.int(chair2.width * 1.1));
					chair2.updateHitbox();

					table2 = new FlxSprite(902, 350).loadGraphic(Paths.image('eviltable'));
					table2.antialiasing = true;
					table2.scrollFactor.set(0.9, 0.9);
					table2.active = false;
					table2.visible = false;
					table2.setGraphicSize(Std.int(table2.width * 1.1));
					table2.updateHitbox();
			
					
					monitor = new FlxSprite(437, 37).loadGraphic(Paths.image('evilmonitor'));
					monitor.antialiasing = true;
					monitor.scrollFactor.set(0.9, 0.9);
					monitor.active = false;

					monitor.visible = false;
					monitor.setGraphicSize(Std.int(monitor.width * 1.25));
					monitor.updateHitbox();
			
					pot = new FlxSprite(1052, 175).loadGraphic(Paths.image('potfloater'));
					pot.antialiasing = true;
					pot.scrollFactor.set(0.9, 0.9);
					pot.active = false;
					pot.visible = false;
					pot.setGraphicSize(Std.int(pot.width * 1.2));
					pot.updateHitbox();
					
					//THIS IS SO WHEN NEW CHARACTERS COME IN IT DOESNT EXPLODE
					var v1:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('characters/glassbaby'));
					v1.antialiasing = true;
					v1.scrollFactor.set();
					v1.active = false;
					v1.updateHitbox();
					v1.alpha = 0;
					add(v1);

					var v2:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('characters/glassgoblin'));
					v2.antialiasing = true;
					v2.scrollFactor.set();
					v2.active = false;
					v2.updateHitbox();
					v2.alpha = 0;
					add(v2);

					var v3:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('characters/micbf'));
					v3.antialiasing = true;
					v3.scrollFactor.set();
					v3.active = false;
					v3.updateHitbox();
					v3.alpha = 0;
					add(v3);
					//ugly fat shit poop
					bgevil = new FlxSprite(-826, -383).loadGraphic(Paths.image('windowbgpng'));
					bgevil.scrollFactor.set(1, 1);
					bgevil.active = false;
					bgevil.updateHitbox();
					bgevil.antialiasing = true;
					add(bgevil);

					var windowTex = Paths.getSparrowAtlas('windowpoppers');
					windowpoppers = new FlxSprite(63, 112);
					windowpoppers.scrollFactor.set(1, 1);
					windowpoppers.frames = windowTex;
					windowpoppers.animation.addByPrefix('idle', 'windowpoppers');
					windowpoppers.animation.play('idle');
					windowpoppers.visible = false;
					windowpoppers.antialiasing = true;
					add(windowpoppers);

					epiclight = new FlxSprite(-167, -65).loadGraphic(Paths.image('epiclight'));
					epiclight.scrollFactor.set(1, 1);
					epiclight.active = false;
					epiclight.updateHitbox();
					epiclight.antialiasing = true;

					var goblintexturruru = Paths.getSparrowAtlas('freedgoblin');
	
					fleedgoblin = new FlxSprite(1070, 580);
					fleedgoblin.frames = goblintexturruru;
					fleedgoblin.animation.addByPrefix('idle', "freedgoblin", 24);
					fleedgoblin.antialiasing = true;
					fleedgoblin.visible = false;
					//add(fleedgoblin);
					fleedgoblin.animation.play('idle');

					var babybluefuckhead = Paths.getSparrowAtlas('babyfreedirl');
	
					fleedbaby = new FlxSprite(1150, 600);
					fleedbaby.frames = babybluefuckhead;
					fleedbaby.animation.addByPrefix('idle', "babyfreedirl", 24);
					fleedbaby.antialiasing = true;
					fleedbaby.visible = false;
					//add(fleedbaby);
					fleedbaby.animation.play('idle');
					
			}

			case 'hospital':
				{
						curStage = 'hospital';
	
						defaultCamZoom = 0.9;
	
						var bg:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('hospitalBack'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 1.1));
						bg.updateHitbox();
						add(bg);
	
						chairummmm = new FlxSprite(-500, -100).loadGraphic(Paths.image('chairLOL'));
						chairummmm.antialiasing = true;
						chairummmm.scrollFactor.set(0.9, 0.9);
						chairummmm.active = false;
						chairummmm.setGraphicSize(Std.int(chairummmm.width * 1.1));
						chairummmm.updateHitbox();

						poopmario = new FlxSprite(20, -540).loadGraphic(Paths.image('floor'));
						poopmario.antialiasing = true;
						poopmario.scrollFactor.set(1, 1);
						poopmario.active = false;
						poopmario.visible = false;
						add(poopmario);
				}

			case 'bathroom':
				{
					curStage = 'bathroom';
					defaultCamZoom = 0.65;

					var bg:FlxSprite = new FlxSprite(-320, -220).loadGraphic(Paths.image('brfloor'));
					bg.antialiasing = true;
					bg.scrollFactor.set();
					bg.active = false;
					add(bg);
				}
			case 'testshitlol':
				{
					floorSkew = new FlxSkewedSprite(100, -50,Paths.image('dreambg'));
					floorSkew.scrollFactor.set(1,1);
					add(floorSkew);
					//floorSkew.skew.x = camPos.x;
				}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = true;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}

		if (curSong.toLowerCase() == 'babys-lullaby')
		{

			crib = new FlxSprite(-100, -540).loadGraphic(Paths.image('floor'));
			crib.antialiasing = true;
			crib.scrollFactor.set(1, 1);
			crib.visible = false;
			add(crib);
		}
		if (curSong.toLowerCase() == 'four-eyes')
		{
			//var lol:String = filterMap.get("Grain");
			//filters.push(filterMap.get(lol));

			//ITS NOT WOOOOORKING!!!!!!!!
		}

		var gfVersion:String = 'gf';

		switch (SONG.gfVersion)
		{
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
			case 'gf-goblin':
				gfVersion = 'gf-goblin';
			case 'baby-bopper':
				gfVersion = 'baby-bopper';
			default:
				gfVersion = 'gf';
		}

		gf = new Character(400, 130, gfVersion);

		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);
		dadAgain = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'baby':
				camPos.x += 600;
				camPos.y += 300;
				dad.y += 440;
				dad.x += 120;
			case 'miku':
				dad.y += 100;
			case 'tinky':
				dad.y += 100;
				dad.x += 120;
			case 'pewdiepie':
				dad.y += 300;
				dad.x += 120;
			case 'freddy':
				dad.y += 150;
				dad.x += 120;
			case 'scout':
				dad.y += 150;
				dad.x -= 120;
			case 'homer':
				camPos.x -= 600;
				dad.y += 150;
				dad.x -= 150;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'running-goblin':
				dad.y += 430;
				dad.x += 110;
			case 'evil-baby':
				dad.y += 350;
				dad.x += 125;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 300);
			case 'gametoons':
				dad.y += 370;
				dad.x += 200;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'alien':
				dad.y += 230;
				dad.x += 0;
			case 'bob':	
				dad.y += 290;
			case 'bob-ron':	
				dad.y += 290;
			case 'ron':
				dad.y += 268;
				dad.x -= 27;
			case 'bobcreature':
				dad.y += 278;
				dad.x -= 70;
			case 'happy-baby':
				dad.y += 440;
				dad.x += 120;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y - 50);
			case 'kitty':
				dad.y += 440;
				dad.x += 120;
			case 'myth':
				dad.y -= 75;
				dad.x += 200;
			case 'window-watcher':
				//erm
				dad.x += 75;
				dad.y += 280;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y + 40);
				FlxTween.tween(dad, {x: 260}, 2, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
				FlxTween.tween(dad, {y: 180}, 6, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		boyfriendAgain = new Boyfriend(770, 450, SONG.player1);
		runningGoblin = new Boyfriend(770, 450, SONG.player1);
		//marios brotehr = new boyfriend(420,69,poop);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'street':
				boyfriend.x += 240;
				dad.x += 160;
				dad.y += 17;
			case 'dream':
				dad.y -= 37;
				dad.x -= 80;
				boyfriend.y -= 37;
				boyfriend.x -= 3;
			case 'hospital':
				boyfriend.x += 240;
				gf.y += 350;
				gf.x += 300;
				dad.x += 100;
			case 'bathroom':
				boyfriend.x += 1000;
				dad.x += 0; //who did this FUCK YOU.
				dad.x -= 0;
				dad.y += 500;
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 700;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				if(FlxG.save.data.distractions)
				{
					var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
					add(evilTrail);
				}


				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		// hi vomic 
		//FAT
		//what why no stop
		if (curStage == 'stage' || curStage == 'hospital')
			add(gf);

		if (curStage == 'hospital')
		{
			add(chairummmm);
		}
		else if (curStage == 'evilhospital')
		{
			add(chair2);
			add(table2);
			add(monitor);
			add(pot);
		}
		//boi
		//simple as that loser.
		add(dad);
		add(boyfriend);

		if (curStage == 'evilhospital')
		{
			add(epiclight);
			add(fleedgoblin);
			add(fleedbaby);
			
			var grain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('grain'));
			grain.antialiasing = true;
			grain.scrollFactor.set();
			grain.alpha = .5;
			add(grain);
			grain.cameras = [camHUD];
		}
		if(curStage == 'bathroom')
		{
			var grain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('grain2'));
			grain.antialiasing = true;
			add(grain);
			grain.cameras = [camHUD];
			blackUmm = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			add(blackUmm);
			blackUmm.cameras = [camHUD];
		}
		
		//SONG NAMES
		start = new FlxSprite(800, 0);
		start.frames = Paths.getSparrowAtlas('Songs/songstart');
		start.animation.addByPrefix('tutorial', 'Tutorial', 0);
		start.animation.addByPrefix('nap-time', 'nap-time', 0);
		start.animation.addByPrefix('kidz-bop', 'kidz-bop', 0);
		start.animation.addByPrefix('baby-blue', 'baby-blue', 0);
		start.animation.addByPrefix('temper-tantrum', 'temper-tantrum', 0);
		start.animation.addByPrefix('babys-revenge', 'babys-revenge', 0);
		start.animation.addByPrefix('un-adieu', 'un-adieu', 0);
		start.animation.addByPrefix('trackstar', 'trackstar', 0);
		start.animation.addByPrefix('gametoons', 'gametoons', 0);
		start.animation.addByPrefix('baby-bob', 'baby-bob', 0);
		start.animation.addByPrefix('just-like-you', 'just-like-you', 0);
		start.animation.addByPrefix('insignificance', 'insignificance', 0);
		start.animation.addByPrefix('kitty', 'kitty', 0);
		start.animation.addByPrefix('flower', 'flower', 0);
		start.animation.addByPrefix('babys-lullaby', 'babys-lullaby', 0);
		start.animation.addByPrefix('rebound', 'rebound', 0);
		start.animation.addByPrefix('myth', 'myth', 0);
		start.antialiasing = true;
		start.screenCenter(Y);
		start.updateHitbox();
		add(start);
		start.visible = false;
		//sorry i had to do this genox, i dont want to make this work in time :(
		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			
			FlxG.save.data.botplay = true;
			FlxG.save.data.scrollSpeed = rep.replay.noteSpeed;
			FlxG.save.data.downscroll = rep.replay.isDownscroll;
			// FlxG.watch.addQuick('Queued',inputsQueued);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				//add(songName); WHY TF WOULD YOU DO THIS FAT UGLY DUMB BITCH WTF IS UR PROBLEM
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.fromString(Character.dadHealthColor), FlxColor.fromString(Character.bfHealthColor));
		// healthBar

		healthBarThingy = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar2'));
		if (FlxG.save.data.downscroll)
			healthBarThingy.y = 50;
		healthBarThingy.screenCenter(X);
		healthBarThingy.scrollFactor.set();

		add(healthBar);
		add(healthBarThingy);
		add(healthBarBG);


		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - KE " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;


		//totally didn't steal this code from fnf plus nuh uh
		scoreTxt = new FlxText(healthBarBG.x - 105, (FlxG.height * 0.9) + 36, 800, "", 22);
		if (FlxG.save.data.downscroll)
			scoreTxt.y = FlxG.height * 0.1 + 25;
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("funkin.otf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 2;
		

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "this is a feature i guess", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		
		if(FlxG.save.data.botplay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		switch(curSong.toLowerCase())
		{
			case 'just-like-you':
				iconP1.animation.play('bf-baby');
			case 'insignificance':
				iconP1.animation.play('bf-baby');
			default:
				iconP1.animation.play(SONG.player1);
		}
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		add(scoreTxt);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healthBarThingy.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		start.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'nap-time':
					funnyIntro(doof);
				case 'kidz-bop':
					funnyIntro(doof);
				case 'baby-blue':
					funnyIntro(doof);
				case 'babys-revenge':
					funnyIntro(doof);
				case 'un-adieu':
					var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
					black.scrollFactor.set();
					add(black);
					funnyIntro(doof);
				case 'temper-tantrum':
					funnyIntro(doof);
				case 'trackstar':
					funnyIntro(doof);
				case 'kitty':
					startCountdown();
				case 'baby-bob':
					funnyIntro(doof);
				case 'just-like-you':
					dadAgain.x -= 165;
					dadAgain.y += 350;
					dadAgain = new Character(dadAgain.x, dadAgain.y, 'ron');
					add(dadAgain);
					dadAgainExist = true;
					boyfriendAgain.x += 165;
					boyfriendAgain.y += 100;
					boyfriendAgain = new Boyfriend(boyfriendAgain.x, boyfriendAgain.y, 'player-baby');
					add(boyfriendAgain);
					boyfriendAgainExist = true;
					funnyIntro(doof);
				case 'insignificance':
					if (videoDialogue == 1)
						{
							var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
							black.scrollFactor.set();
							add(black);
							healthBar.visible = false;
							healthBarBG.visible = false;
							healthBarThingy.visible = false;
							iconP1.visible = false;
							iconP2.visible = false;
							scoreTxt.visible = false;
							funnyIntro(doof);
						}
					else
						{
							boyfriendAgain.x += 165;
							boyfriendAgain.y += 100;
							boyfriendAgain = new Boyfriend(boyfriendAgain.x, boyfriendAgain.y, 'player-baby');
							add(boyfriendAgain);
							boyfriendAgainExist = true;
							var grain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('grain'));
							grain.antialiasing = true;
							grain.scrollFactor.set();
							grain.active = false;
							add(grain);
							funnyIntro(doof);
						}
				case 'baby-blue-new':
					var blackScreen:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('wowCrazy'));
						add(blackScreen);
						blackScreen.scale.set(1.15, 1.15);
						blackScreen.scrollFactor.set();
						camHUD.visible = false;
						FlxG.sound.play(Paths.sound('leak'));
						
						new FlxTimer().start(14.44, function(tmr:FlxTimer)
						{
							Sys.exit(0);
						});
				case "babys-lullaby":
					funnyIntro(doof);
				case 'rebound':
					funnyIntro(doof);
				case 'four-eyes':
					if (videoDialogue == 5)
					{
						if(FlxG.save.data.shaders)
						{
							FlxG.camera.setFilters([ShadersHandler.chromaticAberration, ShadersHandler.radialBlur]);
							camHUD.setFilters([ShadersHandler.chromaticAberration]);
						}
						startCountdown();
					}
					else if (videoDialogue == 4)
					{
						var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
						black.scrollFactor.set();
						add(black);
						healthBar.visible = false;
						healthBarBG.visible = false;
						healthBarThingy.visible = false;
						iconP1.visible = false;
						iconP2.visible = false;
						scoreTxt.visible = false;
						if(FlxG.save.data.shaders)
							{
								FlxG.camera.setFilters([ShadersHandler.chromaticAberration, ShadersHandler.radialBlur]);
								camHUD.setFilters([ShadersHandler.chromaticAberration]);
							}
						funnyIntro(doof);
					}
					else if (videoDialogue == 1)
					{
						var bg:FlxSprite = new FlxSprite(-250, -100).loadGraphic(Paths.image('hospitalBack'));
						bg.antialiasing = true;
						bg.scrollFactor.set(1, 1);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 1.1));
						bg.updateHitbox();
						add(bg);
	
						chairummmm = new FlxSprite(-500, -100).loadGraphic(Paths.image('chairLOL'));
						chairummmm.antialiasing = true;
						chairummmm.scrollFactor.set(0.9, 0.9);
						chairummmm.active = false;
						chairummmm.setGraphicSize(Std.int(chairummmm.width * 1.1));
						chairummmm.updateHitbox();
						add(chairummmm);
						remove(dad);
						remove(gf);
						gf = new Character(400, 130, "baby-bopper");
						dad = new Character(100, 100, "running-goblin");
						gf.visible = true;
						remove(boyfriend);
						boyfriend = new Boyfriend(770, 450, SONG.player1);
						boyfriend.x += 240;
						gf.y += 350;
						gf.x += 300;
						dad.x += 100;
						add(gf);
						add(dad);
						//add(boyfriend);

						//FUCK MY LIFE :/
						healthBar.visible = false;
						healthBarBG.visible = false;
						healthBarThingy.visible = false;
						iconP1.visible = false;
						iconP2.visible = false;
						scoreTxt.visible = false;
						epiclight.visible = false;
						bgevil.visible = false;
						funnyIntro(doof);
					}
					else
					{
						if(FlxG.save.data.shaders)
						{
							FlxG.camera.setFilters([ShadersHandler.chromaticAberration, ShadersHandler.radialBlur]);
							camHUD.setFilters([ShadersHandler.chromaticAberration]);
						}
						startCountdown();
					}
				//	funnyIntro(doof);
					//healthLimit = 1;
					//startCountdown();
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				case 'baby-bob':
					//dream
					startCountdown();
				case 'just-like-you':
					dadAgain.x -= 165;
					dadAgain.y += 350;
					dadAgain = new Character(dadAgain.x, dadAgain.y, 'ron');
					add(dadAgain);
					dadAgainExist = true;
					boyfriendAgain.x += 165;
					boyfriendAgain.y += 100;
					boyfriendAgain = new Boyfriend(boyfriendAgain.x, boyfriendAgain.y, 'player-baby');
					add(boyfriendAgain);
					boyfriendAgainExist = true;
					startCountdown();
				case 'insignificance':
					boyfriendAgain.x += 165;
					boyfriendAgain.y += 100;
					boyfriendAgain = new Boyfriend(boyfriendAgain.x, boyfriendAgain.y, 'player-baby');
					add(boyfriendAgain);
					boyfriendAgainExist = true;
					var grain:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('grain'));
					grain.antialiasing = true;
					grain.scrollFactor.set();
					grain.active = false;
					add(grain);
					startCountdown();
				case 'baby-blue-new':
							var blackScreen:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('wowCrazy'));
							add(blackScreen);
								blackScreen.scale.set(1.15, 1.15);
								blackScreen.scrollFactor.set();
								camHUD.visible = false;
								FlxG.sound.play(Paths.sound('leak'));
		
								new FlxTimer().start(14.44, function(tmr:FlxTimer)
								{
									Sys.exit(0);
								});
				case 'four-eyes':
					/*
					if (videoDialogue == 5)
						{
							startCountdown();
						}
						else
						{
							funnyIntro(doof);
						}
					*/
					if(FlxG.save.data.shaders)
					{
						FlxG.camera.setFilters([ShadersHandler.chromaticAberration, ShadersHandler.radialBlur]);
						camHUD.setFilters([ShadersHandler.chromaticAberration]);
					}
					startCountdown();
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		switch (curStage)
		{
			case 'dream':
				add(bobmadshake);
			case 'phlox':
				add(babaPopup);
		}

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function funnyIntro(?dialogueBox:DialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			add(black);
	
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();
	
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
			{
				black.alpha -= 0.15;
	
				if (black.alpha > 0)
				{
					tmr.reset(0.3);
				}
				else
				{
					if (dialogueBox != null)
					{
						inCutscene = true;
						add(dialogueBox);
					}
					else
						startCountdown();
	
					remove(black);
				}
			});
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	function startCountdown():Void
	{
		inCutscene = false;

		start.animation.play(curSong.toLowerCase());

		FlxTween.tween(start, {alpha: 1, x: 800}, 0.5, {ease: FlxEase.quartInOut,startDelay: 0.2});
		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			FlxTween.tween(start,{alpha:0,x:start.x + 900},0.5,{ease:FlxEase.quartInOut,
				onComplete:function(twn:FlxTween){
					remove(start);
				}
			});
		});

		generateStaticArrows(0);
		generateStaticArrows(1);


		#if windows
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[PlayState.SONG.song]);
		}
		#end

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');
			if(dadAgainExist)
				{
					dadAgain.dance();
				}

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		if (SONG.song.toLowerCase() == 'four-eyes')//BOYLE
			FlxG.sound.music.volume = 1;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("funkin.otf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		if (curSong == 'un-adieu')
			{	
				var dreamyThing:FlxSprite = new FlxSprite(-150, -100).loadGraphic(Paths.image('napSleep'));
				dreamyThing.scrollFactor.set();
				add(dreamyThing);
				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.1;
				wiggleShit.waveFrequency = 2;
				wiggleShit.waveSpeed = 1;
				dreamyThing.shader = wiggleShit.shader;
				camera.flash(FlxColor.BLACK, 21);
			}
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.noteStyle)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				
				case 'normal':
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
	
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.save.data.botplay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;

		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		#end

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}	
		wiggleShit.update(elapsed);

		timerLol += .025;
		
		if(curStage == 'testshitlol')
		{
			//btw i dont know how to get the camera's x value rn it just shows up as zero lol
			floorSkew.skew.x = camGame.x;
		}
		
		if(SONG.player2 == ("glassgoblin"))
		{
			dad.x = (Math.sin((timerLol)) * 125) + 260;
			dad.y = (Math.cos((timerLol)) * 100) + 350;
		}
		else if (SONG.player2 == ("glassbaby"))
		{
			dad.x = 125;
			dad.y = (Math.cos((timerLol)) * 40) + 350;
		}
		
		super.update(elapsed);
		if(curStage == "evilhospital" && coolshadergayshitlol)
		{
			if(FlxG.save.data.shaders)
			{
				ShadersHandler.setChrome(FlxG.random.int(3,4)/2000);
				ShadersHandler.setRadialBlur(640, 360, 0.006);
			}
		}
		else if(curStage == "evilhospital" && !coolshadergayshitlol)
		{
			if(FlxG.save.data.shaders)
			{
				ShadersHandler.setChrome(FlxG.random.int(3,4)/2000);
				ShadersHandler.setRadialBlur(640, 360, 0.006);
			}
		}

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.text = "Score: " + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
				persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			if (SONG.song.toLowerCase() == "four-eyes")
				SONG.player2 = ("window-watcher");
			FlxG.switchState(new ChartingState());
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > healthLimit)
			health = healthLimit;
		if (healthBar.percent < 30)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 90)
			switch(SONG.player2)
			{
				case 'bobcreature':
					iconP2.animation.play('bobdead');
				default:
					iconP2.animation.curAnim.curFrame = 1;
			}
		else
			switch(SONG.player2)
			{
				case 'bobcreature':
					iconP2.animation.play('bobcreature');
				default:
					iconP2.animation.curAnim.curFrame = 0;
			}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			#end

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerTwoTurn', []);
				#end
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'myth':
						camFollow.x = dad.getMidpoint().x - 83;
						camFollow.y = dad.getMidpoint().y - 380;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'running-goblin':
						camFollow.y = dad.getMidpoint().y - 65;
					case 'gametoons':
						camFollow.y = dad.getMidpoint().y + 30;
					case 'evil-baby':
						camFollow.y = dad.getMidpoint().y - 20;
					case 'bob-ron':
						camFollow.x = dad.getMidpoint().x - 100;
						camFollow.y = dad.getMidpoint().y + 7;
					case 'window-watcher':
						camFollow.y = dad.getMidpoint().y + 4;
				}

				//wtf is this
				if (dad.curCharacter == 'mom')
					vocals.volume = 1;
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100 && !goblinTurn)
			{
				var offsetX = 0;
				var offsetY = 0;
				#if windows
				if (luaModchart != null)
				{
					offsetX = luaModchart.getVar("followXOffset", "float");
					offsetY = luaModchart.getVar("followYOffset", "float");
				}
				#end
				camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);

				#if windows
				if (luaModchart != null)
					luaModchart.executeState('playerOneTurn', []);
				#end

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'dream':
						camFollow.x = boyfriend.getMidpoint().x - 220;
						camFollow.y = boyfriend.getMidpoint().y - 15;
					case 'phlox':
						camFollow.y = boyfriend.getMidpoint().y - 15;
				}
			}
		}
		camHUD.y = FlxMath.lerp(0, camHUD.y, 0.95);
		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		FlxG.watch.addQuick("DAD X", dad.x);
		FlxG.watch.addQuick("DAD Y", dad.y);
		FlxG.watch.addQuick("DAD BUT AGAIN X", dadAgain.x);
		FlxG.watch.addQuick("DAD BUT AGAIN Y", dadAgain.y);
		FlxG.watch.addQuick("BF X", boyfriend.x);
		FlxG.watch.addQuick("BF Y", boyfriend.y);
		FlxG.watch.addQuick("BF BUT AGAIN X", boyfriendAgain.x);
		FlxG.watch.addQuick("BF BUT AGAIN Y", boyfriendAgain.y);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}



		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			if (SONG.song.toLowerCase() == "four-eyes")
				SONG.player2 = ("window-watcher");

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if(!FlxG.save.data.botplay)
									{
										if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
	
											daNote.clipRect = swagRect;
										}
									}else {
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							if (zooming)
								camZooming = true;

						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
	
						switch (Math.abs(daNote.noteData))
						{
							//multiple dad singing code thing
							case 2:
								if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
								{
									FlxG.camera.targetOffset.y = -20;
									FlxG.camera.targetOffset.x = 0;
								}
								if (dadSinging && !daNote.isSustainNote)
									dad.playAnim('singUP' + altAnim, true);
								if (dadAgainSinging && !daNote.isSustainNote)
									dadAgain.playAnim('singUP' + altAnim, true);
								if (curSong.toLowerCase() == "insignificance")
									{
										health -= 0.008;
									}
								
							case 3:
								if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
								{
									FlxG.camera.targetOffset.y = 0;
									FlxG.camera.targetOffset.x = 20;
								}
								if (dadSinging && !daNote.isSustainNote)
									dad.playAnim('singRIGHT' + altAnim, true);
								if (dadAgainSinging && !daNote.isSustainNote)
									dadAgain.playAnim('singRIGHT' + altAnim, true);
								if (curSong.toLowerCase() == "insignificance")
									{
										health -= 0.008;
									}
							case 1:
								if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
									{
										FlxG.camera.targetOffset.y = 20;
										FlxG.camera.targetOffset.x = 0;
									}
								if (dadSinging && !daNote.isSustainNote)
									dad.playAnim('singDOWN' + altAnim, true);
								if (dadAgainSinging && !daNote.isSustainNote)
									dadAgain.playAnim('singDOWN' + altAnim, true);
								if (curSong.toLowerCase() == "insignificance")
									{
										health -= 0.008;
									}
							case 0:
								if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
									{
										FlxG.camera.targetOffset.y = 0;
										FlxG.camera.targetOffset.x = -20;
									}
								if (dadSinging && !daNote.isSustainNote)
									dad.playAnim('singLEFT' + altAnim, true);
								if (dadAgainSinging && !daNote.isSustainNote)
									dadAgain.playAnim('singLEFT' + altAnim, true);
								if (curSong.toLowerCase() == "insignificance")
									{
										health -= 0.008;
									}
						}
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;
								if (theFunne)
									noteMiss(daNote.noteData, daNote);
							}
		
							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
					
				});
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay(saveNotes);
		else
		{
			FlxG.save.data.botplay = false;
			FlxG.save.data.scrollSpeed = 1;
			FlxG.save.data.downscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('menu_music_1'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					if (curSong.toLowerCase() == "trackstar")
					{
						FlxG.switchState(new EndState());
					}
					if (curSong.toLowerCase() == "four-eyes")
					{
						FlxG.switchState(new EndEndState());
					}
					if (curSong.toLowerCase() == "insignificance")
						{
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('bobcut4'), new StoryMenuState()));
						}
					else
					{
						FlxG.sound.playMusic(Paths.music('menu_music_1'));

						transIn = FlxTransitionableState.defaultTransIn;
						transOut = FlxTransitionableState.defaultTransOut;

						FlxG.switchState(new StoryMenuState());

						// if ()
					}
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
			    else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

                    var tempSong:String = SONG.song.toLowerCase();

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					switch(tempSong)
					{
						case "babys-revenge":
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('babycut2'), new PlayState()));
						case "baby-bob":
							LoadingState.loadAndSwitchState(new VideoState(Paths.video('bobcut2'), new PlayState()));
						default:
							LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				FlxG.switchState(new FreeplayState());
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 25);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					score = -300;
					combo = 0;
					misses++;
					health -= 0.1;
					ss = false;
					shits++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.25;
				case 'bad':
					daRating = 'bad';
					score = 0;
					health -= 0.06;
					ss = false;
					bads++;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.50;
				case 'good':
					daRating = 'good';
					score = 200;
					ss = false;
					goods++;
					if (health < healthLimit)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 0.75;
				case 'sick':
					if (health < healthLimit)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0)
						totalNotesHit += 1;
					sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(FlxG.save.data.botplay) msTiming = 0;							   

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.visible = false;
				case 'good':
					currentTimingShown.visible = false;
				case 'sick':
					currentTimingShown.visible = false;
			}
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = "lol";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!FlxG.save.data.botplay) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!FlxG.save.data.botplay) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (comboSplit.length == 2)
				seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
				var pressArray:Array<Bool> = [
					controls.LEFT_P,
					controls.DOWN_P,
					controls.UP_P,
					controls.RIGHT_P
				];
				var releaseArray:Array<Bool> = [
					controls.LEFT_R,
					controls.DOWN_R,
					controls.UP_R,
					controls.RIGHT_R
				];
				#if windows
				if (luaModchart != null){
				if (controls.LEFT_P){luaModchart.executeState('keyPressed',["left"]);};
				if (controls.DOWN_P){luaModchart.executeState('keyPressed',["down"]);};
				if (controls.UP_P){luaModchart.executeState('keyPressed',["up"]);};
				if (controls.RIGHT_P){luaModchart.executeState('keyPressed',["right"]);};
				};
				#end
		 
				// Prevent player input if botplay is on
				if(FlxG.save.data.botplay)
				{
					holdArray = [false, false, false, false];
					pressArray = [false, false, false, false];
					releaseArray = [false, false, false, false];
				} 
				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				}
		 
				// PRESSES, check for note hits
				if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					boyfriend.holdTimer = 0;
		 
					var possibleNotes:Array<Note> = []; // notes that can be hit
					var directionList:Array<Int> = []; // directions that can be hit
					var dumbNotes:Array<Note> = []; // notes to kill later
		 
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (directionList.contains(daNote.noteData))
							{
								for (coolNote in possibleNotes)
								{
									if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
									{ // if it's the same note twice at < 10ms distance, just delete it
										// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
										dumbNotes.push(daNote);
										break;
									}
									else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
									{ // if daNote is earlier than existing note (coolNote), replace
										possibleNotes.remove(coolNote);
										possibleNotes.push(daNote);
										break;
									}
								}
							}
							else
							{
								possibleNotes.push(daNote);
								directionList.push(daNote.noteData);
							}
						}
					});
		 
					for (note in dumbNotes)
					{
						FlxG.log.add("killing dumb ass note at " + note.strumTime);
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
		 
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
		 
					var dontCheck = false;

					for (i in 0...pressArray.length)
					{
						if (pressArray[i] && !directionList.contains(i))
							dontCheck = true;
					}

					if (perfectMode)
						goodNoteHit(possibleNotes[0]);
					else if (possibleNotes.length > 0 && !dontCheck)
					{
						if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								{ // if a direction is hit that shouldn't be
									if (pressArray[shit] && !directionList.contains(shit))
										noteMiss(shit, null);
								}
						}
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
							{
								if (mashViolations != 0)
									mashViolations--;
								scoreTxt.color = FlxColor.WHITE;
								goodNoteHit(coolNote);
							}
						}
					}
					else if (!FlxG.save.data.ghost)
						{
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
									noteMiss(shit, null);
						}

					if(dontCheck && possibleNotes.length > 0 && FlxG.save.data.ghost && !FlxG.save.data.botplay)
					{
						if (mashViolations > 8)
						{
							trace('mash violations ' + mashViolations);
							scoreTxt.color = FlxColor.RED;
							noteMiss(0,null);
						}
						else
							mashViolations++;
					}

				}
				
				notes.forEachAlive(function(daNote:Note)
				{
					if(FlxG.save.data.downscroll && daNote.y > strumLine.y ||
					!FlxG.save.data.downscroll && daNote.y < strumLine.y)
					{
						// Force good note hit regardless if it's too late to hit it or not as a fail safe
						if(FlxG.save.data.botplay && daNote.canBeHit && daNote.mustPress ||
						FlxG.save.data.botplay && daNote.tooLate && daNote.mustPress)
						{
							if(loadRep)
							{
								//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
								if(rep.replay.songNotes.contains(HelperFunctions.truncateFloat(daNote.strumTime, 2)))
								{
									goodNoteHit(daNote);
									boyfriend.holdTimer = daNote.sustainLength;
								}
							}else {
								goodNoteHit(daNote);
								boyfriend.holdTimer = daNote.sustainLength;
							}
						}
					}
				});
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || FlxG.save.data.botplay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						FlxG.camera.targetOffset.x = 0;
						FlxG.camera.targetOffset.y = 0;
						boyfriend.playAnim('idle');
						if(boyfriendSigning && !boyfriendAgainSinging)
							boyfriendAgain.playAnim('idle');
						runningGoblin.playAnim('idle');
						
					
				}
		 
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!holdArray[spr.ID])
						spr.animation.play('static');
		 
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
			}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					if(boyfriendSigning)
						boyfriend.playAnim('singLEFTmiss', true);
					if(boyfriendAgainSinging && boyfriendAgainExist)
						boyfriendAgain.playAnim('singLEFTmiss', true);
					if(runningGoblinSinging)
						runningGoblin.playAnim('singLEFTmiss', true);
				case 1:
					if(boyfriendSigning)
						boyfriend.playAnim('singDOWNmiss', true);
					if(boyfriendAgainSinging && boyfriendAgainExist)
						boyfriendAgain.playAnim('singDOWNmiss', true);
					if(runningGoblinSinging)
						runningGoblin.playAnim('singDOWNmiss', true);
				case 2:
					if(boyfriendSigning)
						boyfriend.playAnim('singUPmiss', true);
					if(boyfriendAgainSinging && boyfriendAgainExist)
						boyfriendAgain.playAnim('singUPmiss', true);
					if(runningGoblinSinging)
						runningGoblin.playAnim('singUPmiss', true);
				case 3:
					if(boyfriendSigning)
						boyfriend.playAnim('singRIGHTmiss', true);
					if(boyfriendAgainSinging && boyfriendAgainExist)
						boyfriendAgain.playAnim('singRIGHTmiss', true);
					if(runningGoblinSinging)
						runningGoblin.playAnim('singRIGHTmiss', true);

			}

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff);

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	

					switch (note.noteData)
					{
						case 2:
							if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
							{
								FlxG.camera.targetOffset.y = -20;
								FlxG.camera.targetOffset.x = 0;
							}
							if(FlxG.save.data.botplay) {
								if(boyfriendSigning)
									boyfriend.playAnim('singUP', true);
							} else {
								if(boyfriendSigning && !note.isSustainNote)
									boyfriend.playAnim('singUP', true);
							}
								if(boyfriendAgainSinging && !note.isSustainNote)
									boyfriendAgain.playAnim('singUP', true);
								if(runningGoblinSinging && !note.isSustainNote)
									runningGoblin.playAnim('singUP', true);
						case 3:
							if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
							{
								FlxG.camera.targetOffset.y = 0;
								FlxG.camera.targetOffset.x = 20;
							}
							if(FlxG.save.data.botplay) {
								if(boyfriendSigning)
									boyfriend.playAnim('singRIGHT', true);
							} else {
								if(boyfriendSigning && !note.isSustainNote)
									boyfriend.playAnim('singRIGHT', true);
							}
							if(boyfriendAgainSinging && !note.isSustainNote)
								boyfriendAgain.playAnim('singRIGHT', true);
							if(runningGoblinSinging && !note.isSustainNote)
								runningGoblin.playAnim('singRIGHT', true);
						case 1:
							if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
							{
								FlxG.camera.targetOffset.y = 20;
								FlxG.camera.targetOffset.x = 0;
							}
							if(FlxG.save.data.botplay) {
								if(boyfriendSigning)
									boyfriend.playAnim('singDOWN', true);
							} else {
								if(boyfriendSigning && !note.isSustainNote)
									boyfriend.playAnim('singDOWN', true);
							}
							if(boyfriendAgainSinging && !note.isSustainNote)
								boyfriendAgain.playAnim('singDOWN', true);
							if(runningGoblinSinging && !note.isSustainNote)
								runningGoblin.playAnim('singDOWN', true);
						case 0:
							if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && FlxG.save.data.cameraeffect)
							{
								FlxG.camera.targetOffset.y = 0;
								FlxG.camera.targetOffset.x = -20;
							}
							if(FlxG.save.data.botplay) {
								if(boyfriendSigning)
									boyfriend.playAnim('singLEFT', true);
							} else {
								if(boyfriendSigning && !note.isSustainNote)
									boyfriend.playAnim('singLEFT', true);
							}
							if(boyfriendAgainSinging && !note.isSustainNote)
								boyfriendAgain.playAnim('singLEFT', true);
							if(runningGoblinSinging && !note.isSustainNote)
								runningGoblin.playAnim('singLEFT', true);
					}
		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end


					if(!loadRep && note.mustPress)
						saveNotes.push(HelperFunctions.truncateFloat(note.strumTime, 2));
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}
	var isbobmad:Bool = true;
	var appearscreen:Bool = true;
	function shakescreen()
		{
			camera.shake(0.02,0.5);
		}
	function resetBobismad():Void
		{
			for (babyArrow in playerStrums)
				{
					babyArrow.alpha = 1;
				}
			for (babyArrow in strumLineNotes)
				{
					babyArrow.alpha = 1;
				}
			bobsound.pause();
			bobmadshake.visible = false;
			bobsound.volume = 0;
			isbobmad = true;
		}
	function Bobismad()
		{
			for (babyArrow in playerStrums)
				{
					babyArrow.alpha = 0.05;
				}
			for (babyArrow in strumLineNotes)
				{
					babyArrow.alpha = 0.05;
				}
			bobmadshake.visible = true;
			bobmadshake.alpha = 0.95;
			bobsound.play();
			bobsound.volume = 1;
			isbobmad = false;
			shakescreen();
			new FlxTimer().start(0.5 , function(tmr:FlxTimer)
			{
				resetBobismad();
			});
		}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	/*
	function redFlashing():Void
	{
		//ready to see amazing coding skills
		var waitTime:Int = 1;
		var flashTime:Int = 0.6;
		camera.flash(FlxColor.RED, .6);
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
				camera.flash(FlxColor.RED, .6);

		});
	}
	*/

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}
	
	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}
	function changeDaddy(id:String)
		{
			var olddadx = dad.x;
			var olddady = dad.y;
			remove(dad);
			dad = new Character(olddadx, olddady, id);
			add(dad);
			iconP2.animation.play(id);
			trace('did it work, just maybe, just maybe');
		}
	function changeBf(id:String)
			{                
				var olddadx = boyfriend.x;
				var olddady = boyfriend.y;
				remove(boyfriend);
				boyfriend = new Boyfriend(olddadx, olddady, id);
				add(boyfriend);
			}
	function babaFrontPopup():Void
	{
		babaPopup.visible = true;
		babaPopup.animation.play('baba');
		new FlxTimer().start(1 , function(tmr:FlxTimer)
		{
			babaPopup.destroy();
		});
	}
	var danced:Bool = false;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end
		//THIS IS THE WORST CODE EVER WHY DID I DO THIS
		//baby blue character changing
		if (curStep == 888 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == -150;
            dad.x == 150;
			changeDaddy('homer');
		}
		if (curStep == 1040 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 150;
            dad.x == 120;
			changeDaddy('freddy');
		}
		if (curStep == 1205 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 150;
            dad.x == -120;
			changeDaddy('scout');
		}
		if (curStep == 1365 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 100;
            dad.x == 120;
			changeDaddy('tinky');
		}
		if (curStep == 1536 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 180;
            dad.x == 120;
			changeDaddy('miku');
		}
		if (curStep == 1679 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 440;
            dad.x == 120;
			changeDaddy('baby');
		}
		if (curStep >= 2111 && curStep <= 2128 && curSong.toLowerCase() == 'baby-blue')
			{
				//used to spam on 1.4.2 OOPS!!!
				health += 0.4;
			}
		if (curStep == 2250 && curSong.toLowerCase() == 'baby-blue')
		{
			changeDaddy('monstershit');
		}
		if (curStep == 2448 && curSong.toLowerCase() == 'baby-blue')
		{
			changeDaddy('baby');
		}
		if (curStep == 3226 && curSong.toLowerCase() == 'baby-blue')
		{
			changeDaddy('pewdiepie');
		}
		if (curStep == 3407 && curSong.toLowerCase() == 'baby-blue')
		{
			dad.y == 440;
            dad.x == 120;
			changeDaddy('baby');
		}
		//gametoons lol
		if (curStep == 278 && curSong.toLowerCase() == 'gametoons')
			{
				changeDaddy('screamer');
			}
		// FOUR EYES
	
		//trackstar lol
		if (FlxG.save.data.cameraeffect)
		{
			if (curStep == 96 && curSong.toLowerCase() == 'trackstar')
				{
					trace('it worked');
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 102 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 112 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 160 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 166 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 176 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 224 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 230 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 240 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 288 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 294 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 304 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 352 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 358 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 368 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 415 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 422 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 432 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 480 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 486 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 496 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 544 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 550 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 560 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 608 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 614 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 624 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 672 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 678 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 688 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 736 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 742 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 752 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 800 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 806 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 816 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1248 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1254 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1264 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1312 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1318 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1328 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1376 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1382 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1391 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1439 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1446 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
			if (curStep == 1455 && curSong.toLowerCase() == 'trackstar')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
		}
		if (curStep == 1599 && curSong.toLowerCase() == 'trackstar')
				{
					dad.visible = false;
					var goblinDeathTex = Paths.getSparrowAtlas('goblindeath');
	
					goblinDeath = new FlxSprite(-960, 270);
					goblinDeath.frames = goblinDeathTex;
					goblinDeath.animation.addByPrefix('drive', "goblin death", 24);
					goblinDeath.antialiasing = true;
					add(goblinDeath);
					goblinDeath.animation.play('drive');
					FlxG.sound.play(Paths.sound('baba'));
				}
		//un adieu, i actucally added this on acident but it turned out good
		if (FlxG.save.data.cameraeffect)
		{
			if (curStep == 184 && curSong.toLowerCase() == 'un-adieu')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}
		}
		if (curStep == 704 && curSong.toLowerCase() == 'un-adieu')
			{
				FlxG.camera.fade(FlxColor.BLACK, 13, false);
			}
		//poop revenge
		if (FlxG.save.data.cameraeffect)
		{
			if (curStep == 40 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}
			if (curStep == 41 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 42 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 43 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 44 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}		
			if (curStep == 45 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}		
			if (curStep == 46 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}		
			if (curStep == 47 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}		
			if (curStep == 56 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 57 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 58 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 59 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}	
			if (curStep == 60 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 61 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 62 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 63 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}
			if (curStep == 64 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.1;
					camHUD.zoom += 0.1;
				}

			if (curStep == 768 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}

			if (curStep == 784 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}

			if (curStep == 788 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
				}

			if (curStep == 792 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
					}

			if (curStep == 800 && curSong.toLowerCase() == 'babys-revenge')
				{
					FlxG.camera.zoom += 0.3;
					camHUD.zoom += 0.1;
					}

		}
		//kitty test (testing other dad)
		if (curStage == 'crib' && curSong.toLowerCase() == 'kitty')
				{
					switch (curStep)
					{
						case 1:
							dadAgainSinging = true;
						case 32:
							dadAgainSinging = true;
						
					}
				}
				//turns in just like you
		if (curStage == 'phlox' && curSong.toLowerCase() == 'just-like-you')
				{
					switch (curStep)
					{
						case 128:
							dadSinging = false;
							dadAgainSinging = true;
						case 256:
							dadSinging = true;
							dadAgainSinging = false;
						case 384:
							dadSinging = true;
							dadAgainSinging = true;
						case 640:
							dadAgainSinging = false;
						case 656:
							dadSinging = false;
							dadAgainSinging = true;
						case 704:
							dadSinging = true;
							dadAgainSinging = false;
						case 712:
							dadSinging = false;
							dadAgainSinging = true;
						case 768:
							dadSinging = true;
							dadAgainSinging = true;
					}
				}
		if (curStage == 'phlox' && curSong.toLowerCase() == 'just-like-you')
				{
					switch (curStep)
					{
						case 191:
							boyfriendSigning = false;
							boyfriendAgainSinging = true;
						case 319:
							boyfriendSigning = true;
							boyfriendAgainSinging = false;
						case 447:
							boyfriendSigning = true;
							boyfriendAgainSinging = true;
						case 671:
							boyfriendSigning = true;
							boyfriendAgainSinging = false;
						case 688:
							boyfriendSigning = false;
							boyfriendAgainSinging = true;
						case 719:
							boyfriendSigning = true;
							boyfriendAgainSinging = false;
						case 727:
							boyfriendSigning = false;
							boyfriendAgainSinging = true;
						case 831:
							boyfriendSigning = true;
							boyfriendAgainSinging = true;
					}
				}
				//trace(FlxG.camera.x);
				//baby bob hardcoded in eyeballs
		if (curStage == 'dream' && curSong.toLowerCase() == 'baby-bob')
				{
					switch (curStep)
					{
							case 12:
								Bobismad();
							case 44:
								Bobismad();
							case 76:
								Bobismad();
							case 108:
								Bobismad();
							case 160:
								Bobismad();
							case 224:
								Bobismad();
							case 272:
								Bobismad();
							case 336:
								Bobismad();
							case 382:
								Bobismad();
							case 392:
								Bobismad();
							case 432:
								Bobismad();
							case 456:
								Bobismad();
							case 496:
								Bobismad();
							case 576:
								Bobismad();
							case 620:
								Bobismad();
							case 656:
								Bobismad();
							case 836:
								Bobismad();
							case 908:
								Bobismad();
							case 928:
								Bobismad();
					}
				}
		if (curSong.toLowerCase() == 'insignificance')
			{
				switch (curStep)
				{
					case 1174:
						babaFrontPopup();
				}
			}		
		if (curSong.toLowerCase() == 'insignificance')
			{
				switch (curStep)
				{
					case 10:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 543:
						boyfriendSigning = true;
						boyfriendAgainSinging = false;
					case 575:
						boyfriendSigning = false;
						boyfriendAgainSinging = true;
					case 607:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 671:
						boyfriendSigning = true;
						boyfriendAgainSinging = false;
					case 735:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 799:
						boyfriendSigning = false;
						boyfriendAgainSinging = true;
					case 928:
						if (FlxG.save.data.cameraeffect)
							{
								defaultCamZoom = 1.45;
								camera.flash(FlxColor.BLACK, 6.0);
							}
					case 948:
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 1048:
						if (FlxG.save.data.cameraeffect)
						{
							camera.shake(0.03,0.7);
							defaultCamZoom = 1.05;
						}
					case 1178:
						runningGoblin.x -= 200;
						runningGoblin.y += 170;
						runningGoblin = new Boyfriend(runningGoblin.x, runningGoblin.y, 'player-goblin');
						add(runningGoblin);
						runningGoblinExist = true;
						iconP1.animation.play('bf-baby-goblin');
					case 1183:
						//goblins turn
						boyfriendSigning = false;
						boyfriendAgainSinging = false;
						runningGoblinSinging = true;
						boyfriend.playAnim('idle');
						boyfriendAgain.playAnim('idle');
						defaultCamZoom = 1.10;
						//look at all this code that is useless :|
						camFollow.setPosition(runningGoblin.getMidpoint().x, runningGoblin.getMidpoint().y);
					case 1439:
						FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
						camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
						defaultCamZoom = 1.05;
						boyfriendSigning = true;
						boyfriendAgainSinging = true;
					case 1583:
						changeBf('alien');
						
				}
			}

			if (curSong.toLowerCase() == 'babys-lullaby')
				{
					switch (curStep)
					{
						case 384:
							if (FlxG.save.data.cameraeffect)
								{
									defaultCamZoom = 1.45;
									camera.flash(FlxColor.WHITE, 5.0);
									chairummmm.visible = false;
									poopmario.visible = true;
									//crib.visible = true;

								}
						case 640:
							if (FlxG.save.data.cameraeffect)
								{
									defaultCamZoom = 0.9;
									camera.flash(FlxColor.WHITE, 5.0);
									chairummmm.visible = true;
									poopmario.visible = false;
									//crib.visible = false;
												
								}
						case 1216:
							if (FlxG.save.data.cameraeffect)
								{
									defaultCamZoom = 1.1;
								}
					}
				}
			
			if (curSong.toLowerCase() == 'four-eyes')
			{
				switch(curStep)
				{
					case 1:
						defaultCamZoom = 1.05;
					case 1184:
						//Window Watcher P1 Ends
						
					case 1209:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - 0.025}, 0.5, {
							ease: FlxEase.quadInOut
						});
						FlxTween.tween(FlxG.camera, {alpha: .3}, 0.5, {
							ease: FlxEase.quadInOut
						});
					case 1217:
						//Running Goblin Starts

					case 1824:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1826:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1840:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1841:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1842:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1843:	
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1888:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1890:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1904:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1905:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1906:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1907:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1952:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1954:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 1968:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1969:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1970:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 1971:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2016:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2018:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2032:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2033:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2034:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2035:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2080:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2082:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2096:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2097:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2098:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2099:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2144:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2146:
						FlxG.camera.zoom += 0.1;
						camHUD.zoom += 0.05;
					case 2160:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2161:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2162:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2163:
						FlxG.camera.zoom += 0.3;
						camHUD.zoom += 0.1;
					case 2561:
						//Baby Blue Part Starts
					case 4347:
						dad.playAnim('bye');
					case 4415:
						//Window Watcher Starts
				}
			}
			
			
			/*
			if (curSong.toLowerCase() == 'tutorial-2')
				{
					switch (curStep)
					{
						//BIGSHIT
						case 131:
						redFlashing();
					}
				}
			}
			*/


		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}
	



	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (curBeat % 2 == 1)
		{
			iconP1.setGraphicSize(Std.int(iconP1.width * 1.2));
			iconP2.setGraphicSize(Std.int(iconP2.width * 1.2));
		}
		if (curBeat % 2 == 0)
		{
			iconP1.setGraphicSize(Std.int(iconP1.width * 1.2));
			iconP2.setGraphicSize(Std.int(iconP2.width * 1.2));
		}

		FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quartOut});
		FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quartOut});

		// HARDCODING FOR MILF ZOOMS!
		
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curSong.toLowerCase() == 'trackstar' && curBeat >= 208 && curBeat < 304)
			{
				FlxG.camera.zoom += 0.10;
				camHUD.zoom += 0.02;
			}
		if (curSong.toLowerCase() == 'four-eyes' && curBeat >= 1024 && curBeat <= 1088)
			{
				FlxG.camera.zoom += 0.10;
				camHUD.zoom += 0.025;
			}
		if (curSong.toLowerCase() == 'four-eyes' && curBeat >= 1328 && curBeat <= 1423)
				{
					FlxG.camera.zoom += 0.07;
					camHUD.zoom += 0.025;
				}
		if (curSong.toLowerCase() == 'rebound')
			{
				switch(curBeat)
				{
					case 2:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.4}, 2.49, {
							ease: FlxEase.quadInOut
						});
					case 6:
						defaultCamZoom = 1.3;
					case 8:
						defaultCamZoom = 1;
					case 72:
						defaultCamZoom = 0.9;
					case 84:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.2}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 88:
						defaultCamZoom = 1;
					case 152:
						defaultCamZoom = 1.25;
					case 168:
						defaultCamZoom = 1;
					case 228:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.1}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 292:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.1}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 356:
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.2}, 1.66, {
							ease: FlxEase.quadInOut
						});
					case 360:
						defaultCamZoom = 0.9;
				}
			}


		if (curSong.toLowerCase() == 'rebound' && curBeat >= 8 && curBeat < 72)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
				//FlxTween.tween(camHUD, {y: 0}, 0.5, {
				//	ease: FlxEase.quartOut
				//});

			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 88 && curBeat < 152)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;


			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 168 && curBeat < 228)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 232 && curBeat < 292)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
			}
		if (curSong.toLowerCase() == 'rebound' && curBeat >= 296 && curBeat < 360)
			{
				FlxG.camera.zoom += 0.07;
				camHUD.zoom += 0.025;
				camHUD.y -= 30;
			}




		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curSong.toLowerCase() == 'babys-revenge' && curBeat == 48)
			{
				camZooming = true;
			}

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
			if(boyfriendAgainExist)
				boyfriendAgain.playAnim('idle');
			if(runningGoblinExist)
				runningGoblin.playAnim('idle');
		}

		if (!dad.animation.curAnim.name.startsWith("sing") && !dad.animation.curAnim.name.startsWith("hi") && !dad.animation.curAnim.name.startsWith("bye"))
		{
			if(curSong == 'myth' && (curBeat > 353 || curBeat < 28)) {
				dad.playAnim('gone', true);
			} else {
				dad.dance();
			}
			FlxG.camera.targetOffset.y = 0;
			FlxG.camera.targetOffset.x = 0;
			if (dadAgainExist)
				dadAgain.dance();
		}

		if (curSong == 'myth')
		{
			switch(curBeat)
			{
				case 2:
					//at 2 because haxeflixel lags at beat 0 and dont plays the thing LOL
					blackUmm.visible = false;
				case 28:
					dad.playAnim('hi', true);
				case 353:
					dad.playAnim('bye', true);
			}
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 47 && curSong == 'trackstar')
		{
			dad.playAnim('hey', true);
		}

		if (curBeat == 79 && curSong == 'trackstar')
		{
			dad.playAnim('hey', true);
		}

		//rebound shit
		if (curBeat == 23 && curSong == 'Rebound')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 39 && curSong == 'Rebound')
		{
			dad.playAnim('hey', true);
		}

		if (curBeat == 247 && curSong == 'Rebound')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat == 263 && curSong == 'Rebound')
		{
			dad.playAnim('hey', true);
		}

		if (curBeat == 295 && curSong == 'Rebound')
			{
				boyfriend.playAnim('hey', true);
			}

			if (curBeat > 294 && curBeat < 296 && curSong == 'Rebound')
				{
					FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.4}, 0.2, {
						ease: FlxEase.quadInOut
					});
				}

		if (curBeat == 327 && curSong == 'Rebound')
			{
				dad.playAnim('hey', true);
			}

		if (curSong.toLowerCase() == 'four-eyes')
				{
					switch(curBeat)
					{
						case 0:
							//
						case 16:
							defaultCamZoom = 1.1;
						case 30:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - 0.3}, 1.8, {
								ease: FlxEase.quadInOut
							});
						case 36:
							defaultCamZoom = 2;
						case 40:
							defaultCamZoom = 0.9;
						case 294:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.5}, 0.7, {
								ease: FlxEase.quadIn
							});
						case 296:
							//end of windowwathcers part
							coolshadergayshitlol = false;
							health -= .75;
							camHUD.visible = false;
							camGame.alpha = 0;
							epiclight.visible = false;
							bgevil.visible = false;
							//windowpoppers.visible = false;
							/*
							chairummmm.visible = true;
							chair2.visible = true;
							table2.visible = true;
							monitor.visible = true;
							*/
							//pot.visible = true;
						case 304:
							coolshadergayshitlol = true;
							defaultCamZoom = 1.25;
							camGame.alpha = 1;
							camHUD.visible = true;
							changeDaddy('glassgoblin');
							SONG.player2 = ("glassgoblin");
						case 320:
							defaultCamZoom = 1.05;
						case 558:
							defaultCamZoom = 1.3;
						case 624:
							coolshadergayshitlol = false;
							SONG.player2 = ("window-watcher");
							health -= 1;
							dad.playAnim('bye');
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.2}, 1.6, {
								ease: FlxEase.quadInOut
							});
						case 625:
							FlxTween.tween(camGame, {alpha: 0}, 1.4, {
								ease: FlxEase.quadInOut
							});
							FlxTween.tween(camHUD, {alpha: 0}, 1.4, {
								ease: FlxEase.quadInOut
							});
						case 629:
							camHUD.alpha = 0;
							camGame.alpha = 0;
							defaultCamZoom = 1.05;
						case 640:
							coolshadergayshitlol = true;
							fleedgoblin.visible = true;
							camHUD.alpha = 1;
							camGame.alpha = 1;
							FlxG.camera.zoom += 0.3;
							camHUD.zoom += 0.1;
							SONG.player2 = ("glassbaby");
							changeDaddy('glassbaby');
						case 800:
							defaultCamZoom = 1.15;
						case 926:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - 0.25}, 1.6, {
								ease: FlxEase.quadInOut
							});
						case 930:
							defaultCamZoom = 0.9;
						case 943:
							//defaultCamZoom = 1.05;
						case 992:
							defaultCamZoom = 1.25;
						case 1088:
							health -= 1.25;
						case 1095:
							//camGame.x += 300;AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
							defaultCamZoom = 5;
						case 1099:
							defaultCamZoom = 0.9;
							//health -= 1;
							fleedbaby.visible = true;
							//camGame.x -= 300;
							changeBf('micbf');
							SONG.player2 = ("window-watcher");
							changeDaddy('window-watcher');
							FlxTween.tween(dad, {x: 260}, 2, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
							FlxTween.tween(dad, {y: 180}, 6, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut});
						case 1178:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1194:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1210:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1226:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1306:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1322:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom + 0.25}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1324:
							defaultCamZoom = 1.15;
						case 1328:
							FlxG.camera.zoom += 0.3;
							camHUD.zoom += 0.1;
							defaultCamZoom = 1;
						case 1426:
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom - .7}, 0.665, {
								ease: FlxEase.quadOut
							});
						case 1428:
							defaultCamZoom = 1.1;
						case 1460:
							camGame.visible = false;
						case 1464:
							FlxG.camera.zoom += 0.3;
							camHUD.zoom += 0.1;
							camGame.visible = true;
						case 1560:
							defaultCamZoom = 1;
						case 1624:
							FlxG.camera.fade(FlxColor.WHITE, 1.33, false);
					}
				}



		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}
			case 'evilhospital':
				if (curBeat % 2 == 0)
				{
					windowpoppers.animation.play('idle', true);
					fleedbaby.animation.play('idle', true);
					fleedgoblin.animation.play('idle', true);
				}
					
			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
