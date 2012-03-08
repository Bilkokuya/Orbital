//	Copyright 2012 Gordon D Mckendrick©
//	Author: Gordon D Mckendrick
//
//	Main
//		Controls the timing of the game through events that are dispatched
//		Handles initialisation to do with new games etc

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
	import flash.utils.ObjectInput;
	import orbital.util.Resources;
	
	import orbital.entity.Planet;
	import orbital.util.Keys;
	import orbital.events.OrbitalEvent;
	import orbital.util.SoundManager;

	//	Class: main
	public class Main extends Sprite 
	{
		private var planet:Planet;
		private var bgStars:Shape;
		
		private var score:int;
		private var scoreOut:TextField;
		
		private var title:TextField;
		private var subtitle:TextField;
		private var intro:Sprite;
		private var format:TextFormat;
		
		private var tickCount:int;
		private var secondGame:Boolean;
		private var delayCount:int;
		
		
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
			intro = new Sprite();
			
			planet = new Planet();
			scoreOut = new TextField();
			title = new TextField();
			subtitle = new TextField();
			format = new TextFormat();
			bgStars = new Shape();
			
			score = 0;
			delayCount = 0;
			tickCount = 0;
			
			//	Font format for the majority of the game
			format.font = "Calibri";
			format.bold = true;
			format.color = 0xFFCC00;
			format.size = 30;
			
			//	Score text output
			scoreOut.x = 20;
			scoreOut.y = 20;
			scoreOut.setTextFormat(format);
			scoreOut.defaultTextFormat = format;
			scoreOut.autoSize = TextFieldAutoSize.LEFT;
			
			//	Main title text output
			format.size = 50;
			format.color = 0xFFFFFF;
			title.defaultTextFormat = format;
			title.setTextFormat(format);
			title.autoSize = TextFieldAutoSize.LEFT;
			
			//	Subtitle text output
			format.size = 13;
			subtitle.defaultTextFormat = format;
			subtitle.setTextFormat(format);
			subtitle.autoSize = TextFieldAutoSize.LEFT;
			
			//	Draw the starmap background
			bgStars.graphics.clear();
			//		Black Backdrop
			bgStars.graphics.beginFill(0x000000);
			bgStars.graphics.drawRect( -stage.stageWidth, -stage.stageHeight, stage.stageWidth*2, stage.stageHeight*2);
			bgStars.graphics.endFill();
			//		Randomly placed white "star" dots
			bgStars.graphics.beginFill(0xDDDDFF);
			for (var i:int = 0; i < 200; i++) {
				bgStars.graphics.drawCircle(((Math.random()-0.5) * stage.stageWidth*1.5), ((Math.random()-0.5) * stage.stageHeight*1.5), (Math.random()));
			}
			bgStars.graphics.endFill();
			//	Centered behind the planet for rotation
			bgStars.x = stage.stageWidth / 2;
			bgStars.y = stage.stageHeight / 2;
			
			
			addChild(bgStars);
			addChild(planet);
			addChild(scoreOut);
			addChild(intro);
			
			//	Initialise the static utilities
			SoundManager.init(stage);
			Keys.init(stage);
			initIntro();
			
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			addEventListener(Event.ENTER_FRAME, onTickIntro);
			stage.addEventListener(OrbitalEvent.HIT_BOMB, endGame);
			stage.addEventListener(OrbitalEvent.HIT_STAR, onStar);
		}
		
		//	Listener: onStar
		//	When the player picks up a star, increase their score
		private function onStar(e:OrbitalEvent):void
		{
			score += 76;
		}
		
		//	Listener: onTickIntro
		//	Runs each tick while the game is in the main intro-menu phase of it's logic
		private function onTickIntro(e:Event):void
		{
			scoreOut.text = "PRESS SPACE TO PLAY AGAIN!";
			
			//	If the player arrives here after losing already; add a delay to avoid them double hitting the key
			if (secondGame) {
				delayCount++;
				if (delayCount > 15) {
					if (Keys.isDown(Keys.SPACE)) {
						delayCount = 0;
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
			
			//	Dispatch the tick controll event
			stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.TICK_INTRO, tickCount));
		}
		
		//	Function: initIntro
		//	Initialises the intro once the game starts
		private function initIntro():void
		{
			//	Let all systems know the game has launched
			stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.START_INTRO));
			
			intro.addChild(title);
			
			title.text = "ORBITAL";
			title.x = 200;
			title.y = 50;
			
			bgStars.rotation = 0;
			
			intro.addChild(subtitle);
			subtitle.text = " by Gordon D Mckendrick \n With music by EcHo2K ('A Blondie on the Sofa') \n\n\nSpace to Jump/Double Jump. \n'S' to shrink and move down.";
			subtitle.x = 220;
			subtitle.y = 100;
			
			addChild(scoreOut);
			scoreOut.text = "PRESS SPACE TO PLAY...";
			scoreOut.x = stage.stageWidth / 2 - 150;
			scoreOut.y = stage.stageHeight / 2 + 25;
			
			planet.x = stage.stageWidth / 2 - 100;
			planet.y = stage.stageHeight;
			planet.scaleX = 1.5;
			planet.scaleY = 1.5;
			
		}
		
		//	Function: newGame
		//	Resets the positions and values of everything when the game restarts
		private function newGame():void 
		{
			//	Let all systems know the main game has started
			stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.START_MAIN));
			
			//	Seed the starting value of tickCount to avoid same game each time
			tickCount = Math.random() * 215;
			
			score = 0;
			
			planet.kill();
			planet = new Planet();
			addChild(planet);
			planet.x = stage.stageWidth / 2;
			planet.y = stage.stageHeight / 2;
			planet.rotation = 0;
			planet.scaleX = 1;
			planet.scaleY = 1;
			
			format.size = 60;
			scoreOut.setTextFormat(format);
			scoreOut.defaultTextFormat = format;
			scoreOut.x = 75;
			scoreOut.y = 75;
			scoreOut.text = score.toString();
		}
		
		//	Function: endGame
		//	Runs when the game is lost - positions the game over screen
		private function endGame(e:OrbitalEvent = null ):void
		{
			removeEventListener(Event.ENTER_FRAME, onTick);
			addEventListener(Event.ENTER_FRAME, onTickIntro);
			
			//	Let all systems know the game has ended
			stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.START_END));
			
			intro.visible = true;
			
			intro.addChild(title);
			
			title.visible = true;
			intro.addChild(title);
			format.size = 50;
			title.defaultTextFormat = format;
			title.setTextFormat(format);
			title.text = "GAME OVER";
			title.x = 100;
			title.y = 50;
			
			
			intro.addChild(subtitle);
			format.size = 20;
			subtitle.defaultTextFormat = format;
			subtitle.setTextFormat(format);
			subtitle.text = "You scored: " + score.toString() + " points.";
			subtitle.x = 100;
			subtitle.y = 100;

			format.size = 30;
			format.color = 0xFF6600;
			scoreOut.defaultTextFormat = format;
			scoreOut.setTextFormat(format);
			scoreOut.x = stage.stageWidth / 2 - 150;
			scoreOut.y = stage.stageHeight / 2 + 25;
			format.color = 0xFFFFFF;
			
			planet.kill();
			planet = new Planet();
			addChild(planet);
			planet.x = stage.stageWidth / 2 - 100;
			planet.y = stage.stageHeight;
			planet.scaleX = 1.5;
			planet.scaleY = 1.5;
			
			delayCount = 0;
			secondGame = true;
		}
		
		//	Listener: onTick
		//	Runs every tick while the game is running
		private function onTick(e:Event):void
		{
			//	The difficulty of the game depends entirely on the time spent so far
			//	Sends out the events for this logic section
			var difficulty:Number = (tickCount / 1200) + 1.5;
			stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.TICK_MAIN, tickCount, difficulty/2));
			
			//	Constantly rotate the star background
			bgStars.rotation += 0.1;
			
			//	Set the score output to the new score each time
			scoreOut.text = score.toString();
			//	Make the score pulse as an animation by scaling it in and out
			if ((tickCount % 23) < 3) {
				scoreOut.scaleX -= 0.02;
				scoreOut.scaleY -= 0.02;
			}else if ((tickCount % 23) < 20) {
			}else if ((tickCount % 23) < 23) {
				scoreOut.scaleX += 0.02;
				scoreOut.scaleY += 0.02;
			}
			
			tickCount++;
		}
		
		
		
	}
	
}