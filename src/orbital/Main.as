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
	import orbital.entity.Satellite;
	import orbital.util.Resources;
	
	import orbital.entity.Player;
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
		private var ticker2:int;
		
		
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
			ticker2 = 0;
			
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
			
			bgStars.graphics.beginFill(0xFFFFFF);
			bgStars.graphics.drawCircle(0, 0, 1);
			bgStars.graphics.endFill();
			bgStars.x = stage.stageWidth / 2;
			bgStars.y = stage.stageHeight / 2;
			
			addChild(bgStars);
			addChild(planet);
			addChild(scoreOut);
			addChild(intro);
			
			tickCount = 0;
			
			SoundManager.init(stage);
			Keys.init(stage);
			initIntro();
			
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
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
			tickCount = Math.random() * 215;
			score = 0;
			
			planet = new Planet();
			addChild(planet);
			
			//	Redraw the starmap background
			bgStars.graphics.clear();
			bgStars.graphics.beginFill(0xDDDDFF);
			for (var i:int = 0; i < 200; i++) {
				bgStars.graphics.drawCircle(((Math.random()-0.5) * stage.stageWidth*1.5), ((Math.random()-0.5) * stage.stageHeight*1.5), (Math.random()));
			}
			bgStars.graphics.endFill();			
			
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
			removeEventListener(Event.ENTER_FRAME, onTick);
			addEventListener(Event.ENTER_FRAME, onTickIntro);
			
			intro.visible = true;
			
			planet = new Planet();
			addChild(planet);
			
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
			//	The difficulty of the game depends entirely on the time spent so far
			//	Sends out the events for this logic section
			var difficulty:Number = (tickCount / 1200) + 1.5;
			stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.TICK_MAIN, difficulty/2));
			
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