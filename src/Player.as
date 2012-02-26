//	Copyright 2012 Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Player
//		The player object

package  
{

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	//	Class: Player
	public class Player extends Sprite 
	{
		[Embed(source = "../resources/bloop.mp3")]
		private var SOUND_JUMP:Class;
		
		[Embed(source = "../resources/player.png")]
		private var IMAGE_PLAYER:Class;
		
		public var radius:Number;
		public var speed:Number;
		public var jumping:int;		//	0 none, 1 first jump, 2 second jump
		public var timer:int;
		public var jumpSound:Sound;
		public var playerImage:Bitmap;
		public var animtimer:Number;
		
		//	Constructor: default
		public function Player() 
		{
			super();
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		private function onInit(e:Event = null):void
		{
			
			jumpSound = new SOUND_JUMP();
			playerImage = new IMAGE_PLAYER();
			
			addChild(playerImage);
			playerImage.width = 50;
			playerImage.height = 50;
			radius = 115;
			
			playerImage.x = -playerImage.width / 2;
			playerImage.y = -playerImage.height / 2;
			
			
			timer = 0;
			jumping = 0;
			speed = 0;
			animtimer = 0;
			y = stage.stageHeight / 2 - radius;
			x = stage.stageWidth / 2;
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			stage.addEventListener(TickEvent.PLANET_TICK, onTick);
		}
		
		//	Listener: onTick
		private function onTick(e:Event):void
		{
			animtimer++;
			
			//	take inputs
			processInputs();
			
			if (--timer < 0) timer = 0;
			
			//	main speed control
			speed -= 1;
			radius += speed;
			if (radius < 115) {
				speed = 0;
				radius =  115;
				jumping = 0;
			}
			
			
			if (animtimer < 2) {
				rotation += 0.5;
			}else if (animtimer < 5){
				rotation += 1;
			}else if (animtimer < 15) {
				rotation += 8.2;
			}else if (animtimer < 15) {
				rotation += 1;
			}else if (animtimer < 17) {
				rotation += 0.5;
			}else {
				animtimer = 0;
			}
				
				
			if (jumping > 1) {
				rotation++;
			}
			
			var rand:Number = Math.random() * 100;
			if ((rand % 30) < 1) {
				if (jumping < 1) {
					speed = 4;
				}
			}
			
			y = stage.stageHeight / 2 - radius;
		}
		
		//	Function: jump
		public function jump():void
		{
			if ((jumping < 1)){
				speed = 12;
				jumping = 1;
				timer = 5;
				jumpSound.play(0, 0, new SoundTransform(0.7));
			}else if ((jumping < 2) && timer==0){
				speed = 15;
				jumping = 2;
				jumpSound.play(0, 0, new SoundTransform(0.5));
			}
		}
		
		//	Function: processInputs
		private function processInputs():void
		{
			if (Keys.isDown(Keys.SPACE)) {
					jump();
			}
			if (Keys.isDown(Keys.S)) {
					speed -= 3;
					height = 25;
			}else {
				height = 50;
			}
			
		}
		
		
	}

}