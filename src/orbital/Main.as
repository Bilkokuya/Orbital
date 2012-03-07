//	Copyright 2012 Gordon D Mckendrick©
//	Author: Gordon D Mckendrick
//
//	Main

package orbital
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import orbital.util.Resources;
	
	import orbital.entity.Player;
	import orbital.entity.Planet;
	import orbital.util.Keys;
	import orbital.entity.Bomb;
	import orbital.entity.Collectable;
	import orbital.events.TickEvent;

	//	Class: main
	public class Main extends Sprite 
	{
		private const volume:Number = 0;
		
		private var planet:Planet;
		private var player:Player;
		private var music:Sound;
		private var introSound:Sound;
		private var loseSound:Sound;
		private var starSound:Sound;
		
		private var stars:Array;
		private var bombs:Array;
		
		public var ticker:int;
		public var score:int;
		public var scoreOut:TextField;
		public var title:TextField;
		public var subtitle:TextField;
		public var intro:Sprite;
		public var format:TextFormat;
		public var bg:Shape;
		
		public var secondGame:Boolean;
		public var ticker2:int;
		
		public var musicChannel:SoundChannel;
		
		//	Constructor: default
		public function Main():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Function: onInit
		//	Initialises the game once the stage has been set up
		private function onInit(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			
			music = new Resources.AUDIO_BGMUSIC();
			
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			score = 0;
			
			Keys.init(stage);
			
			intro = new Sprite();
			player = new Player();
			planet = new Planet();
			stars = new Array();
			scoreOut = new TextField();
			title = new TextField();
			subtitle = new TextField();
			format = new TextFormat();
			bombs = new Array();
			bg = new Shape();
			
			introSound = new Resources.AUDIO_INTRO();
			loseSound = new Resources.AUDIO_LOSE();
			starSound = new Resources.AUDIO_STAR();
			musicChannel = new SoundChannel();
			
			scoreOut.x = 20;
			scoreOut.y = 20;
			
			format.font = "Calibri";
			format.bold = true;
			format.color = 0xFFCC00;
			format.size = 30;
			scoreOut.setTextFormat(format);
			scoreOut.defaultTextFormat = format;
			scoreOut.autoSize = TextFieldAutoSize.LEFT;
			
			format.size = 50;
			format.color = 0xFFFFFF;
			title.defaultTextFormat = format;
			title.setTextFormat(format);
			title.autoSize = TextFieldAutoSize.LEFT;
			
			format.size = 13;
			subtitle.defaultTextFormat = format;
			subtitle.setTextFormat(format);
			subtitle.autoSize = TextFieldAutoSize.LEFT;
			
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawCircle(0, 0, 1);
			bg.graphics.endFill();
			bg.x = stage.stageWidth / 2;
			bg.y = stage.stageHeight / 2;
			
			addChild(bg);
			addChild(player);
			addChild(planet);
			addChild(scoreOut);
			addChild(intro);
			
			ticker = 0;
			initIntro();
			addEventListener(Event.ENTER_FRAME, onTickIntro);
		}
		
		//	Listener: onTickIntro
		//	Runs each tick while the game is in the main intro-menu phase of it's logic
		private function onTickIntro(e:Event):void
		{
			if (secondGame) {
				ticker2++;
				if (ticker2 > 15) {
					if (Keys.isDown(Keys.SPACE)) {
						ticker2 = 0;
						intro.visible = false;
						addEventListener(Event.ENTER_FRAME, onTick);
						removeEventListener(Event.ENTER_FRAME, onTickIntro);
						newGame();
					}
				}
				
				
			}else if (Keys.isDown(Keys.SPACE)) {
				intro.visible = false;
				addEventListener(Event.ENTER_FRAME, onTick);
				removeEventListener(Event.ENTER_FRAME, onTickIntro);
				newGame();
			}
			
		}
		
		//	Function: initIntro
		//	Initialises the intro once the game starts
		private function initIntro():void
		{
			introSound.play(0, 0, new SoundTransform(1 * volume));
			
			intro.addChild(title);
			
			title.text = "ORBITAL";
			title.x = 200;
			title.y = 50;
			
			intro.addChild(subtitle);
			subtitle.text = " by Gordon D Mckendrick \n With music by EcHo2K ('A Blondie on the Sofa')";
			subtitle.x = 220;
			subtitle.y = 100;
			
			
			addChild(scoreOut);
			scoreOut.text = "PRESS SPACE TO PLAY...";
			scoreOut.x = stage.stageWidth / 2 - 150;
			scoreOut.y = stage.stageHeight / 2 + 25;
			
			intro.graphics.beginFill(0x000000);
			intro.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			intro.graphics.endFill();
			
			intro.graphics.beginFill(0xDDDDFF);
			for (var i:int = 0; i < 100; i++) {
				intro.graphics.drawCircle((Math.random() * stage.stageWidth), (Math.random() * stage.stageHeight), (Math.random()));
			}
			intro.graphics.endFill();
			planet.x = stage.stageWidth / 2 - 100;
			planet.y = stage.stageHeight;
			planet.scaleX = 1.5;
			planet.scaleY = 1.5;
			intro.addChild(planet);
			
		}
		
		//	Function: newGame
		//	Resets the positions and values of everything when the game restarts
		private function newGame():void
		{
			musicChannel.stop();
			musicChannel = music.play(0, 0, new SoundTransform(0.5 * volume));
			ticker = Math.random() * 215;
			score = 0;
			for (var i:int = 0; i < stars.length; i++) {
				var star:Collectable = stars.pop();
				star.radius = 0;
				removeChild(star);
			}
			for (var i:int = 0; i < bombs.length; i++) {
				var bomb:Bomb = bombs.pop();
				bomb.radius = 0;
				removeChild(bomb);
			}
			
			
			
			bg.graphics.beginFill(0xDDDDFF);
			for (var i:int = 0; i < 200; i++) {
				bg.graphics.drawCircle(((Math.random()-0.5) * stage.stageWidth*1.5), ((Math.random()-0.5) * stage.stageHeight*1.5), (Math.random()));
			}
			bg.graphics.endFill();
			bg.alpha = 0.2
			
			
			planet.x = stage.stageWidth / 2;
			planet.y = stage.stageHeight / 2;
			planet.rotation = 0;
			planet.scaleX = 1;
			planet.scaleY = 1;
			addChild(planet); 
			
			format.size = 60;
			scoreOut.setTextFormat(format);
			scoreOut.defaultTextFormat = format;
			scoreOut.x = 75;
			scoreOut.y = 75;
			scoreOut.text = score.toString();
		}
		
		//	Function: endGame
		//	Runs when the game is lost - positions the game over screen
		private function endGame():void
		{
			var transform:SoundTransform = new SoundTransform(0.5);
			musicChannel.soundTransform = transform;
			loseSound.play(0, 0, new SoundTransform(volume));
			
			removeEventListener(Event.ENTER_FRAME, onTick);
			addEventListener(Event.ENTER_FRAME, onTickIntro);
			intro.visible = true;
			
			for (var i:int = 0; i < stars.length; i++) {
				var star:Collectable = stars.pop();
				star.radius = 0;
				removeChild(star);
			}
			for (var i:int = 0; i < bombs.length; i++) {
				var bomb:Bomb = bombs.pop();
				bomb.radius = 0;
				removeChild(bomb);
			}
			
			intro.addChild(title);
			
			title.visible = true;
			intro.addChild(title);
			format.size = 50;
			title.defaultTextFormat = format;
			title.setTextFormat(format);
			title.text = "GAME OVER";
			title.x = 175;
			title.y = 50;
			
			
			intro.addChild(subtitle);
			format.size = 20;
			subtitle.defaultTextFormat = format;
			subtitle.setTextFormat(format);
			subtitle.text = "You scored: " + score.toString() + " points.";
			subtitle.x = 100;
			subtitle.y = 100;
			
			
			addChild(scoreOut);
			format.size = 30;
			scoreOut.defaultTextFormat = format;
			scoreOut.setTextFormat(format);
			scoreOut.text = "PRESS SPACE TO PLAY AGAIN!";
			scoreOut.x = stage.stageWidth / 2 - 150;
			scoreOut.y = stage.stageHeight / 2 + 25;
			
			intro.graphics.beginFill(0x000000);
			intro.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			intro.graphics.endFill();
			
			intro.graphics.beginFill(0xDDDDFF);
			for (var i:int = 0; i < 100; i++) {
				intro.graphics.drawCircle((Math.random() * stage.stageWidth), (Math.random() * stage.stageHeight), (Math.random()));
			}
			intro.graphics.endFill();
			planet.x = stage.stageWidth / 2 - 100;
			planet.y = stage.stageHeight;
			planet.scaleX = 1.5;
			planet.scaleY = 1.5;
			intro.addChild(planet);
			
			ticker2 = 0;
			secondGame = true;
		}
		
		//	Listener: onTick
		//	Runs every tick while the game is running
		private function onTick(e:Event):void
		{
			var difficulty:Number = (ticker / 1200) + 1.5;
			
			stage.dispatchEvent(new TickEvent(TickEvent.PLANET_TICK, difficulty/2));
			
			bg.rotation += 0.1;
			scoreOut.text = score.toString();
			if ((ticker % 23) < 3) {
				scoreOut.scaleX -= 0.02;
				scoreOut.scaleY -= 0.02;
			}else if ((ticker % 23) < 20) {
			}else if ((ticker % 23) < 23) {
				scoreOut.scaleX += 0.02;
				scoreOut.scaleY += 0.02;
			}
			
			
			var random:int = (Math.random() - 0.5) * 20;
			var chance:int = (Math.random() * 100);
			
			
			//spawn bombs
			var times:int = 0;
			
			//spawn collectibles 
			times = 0;
			if (Math.abs(ticker % (30 / difficulty) + 3*random) < 0.5 ) {
				if (chance < 1) {
					times = 5;
				}else if (chance < 5) {
					times = 2;
				}else if (chance < 70) {
					times = 1;
				}
				for (var i = 0; i < times; i++){
					var s:Collectable = new Collectable(((Math.random() - 0.5) * 50 + 125));
					stars.push(s);
					addChild(s);
					s.x = stage.stageWidth / 2;
					s.y = stage.stageHeight / 2;
				}
			}

			
			//	Run collision detection for each star
			//	Add points when one is hit
			for each (var star:Collectable in stars) {
				if (star.isAlive){
					if (player.height >= 30) {
						if ((star.rotation < -180 + 10*player.scaleX) || (star.rotation > 180 - 10*player.scaleX)) {
							if (Math.abs(star.radius - player.radius) < 10*player.scaleX){
								score += 76;
								star.isAlive = false;
								star.visible = false;
								starSound.play(0, 0, new SoundTransform(volume * 0.5));
							}
						}
						
					}
				}
			}
			
			//	Run collision detection for each bomb
			//	End the game if any of them have been hit
			for each (var bomb:Bomb in bombs) {
				if (bomb.isAlive){
					if (player.height >= 30) {
						if ((bomb.rotation < -180 + 10*player.scaleX) || (bomb.rotation > 180 - 10*player.scaleX)) {
							if (Math.abs(bomb.radius - player.radius) < 10*player.scaleX){
								bomb.isAlive = false;
								bomb.visible = false;
								endGame();
							}
						}
						
					}
				}
			}
			
			ticker++;
		}
		
		
		
	}
	
}