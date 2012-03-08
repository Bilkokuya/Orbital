//	Copyright 2012 Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Player
//		The player object

package orbital.entity
{

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import orbital.util.Resources;
	
	import orbital.util.Keys;
	import orbital.events.OrbitalEvent;
	
	//	Class: Player
	public class Player extends Sprite 
	{
		public var radius:Number;
		public var speed:Number;
		public var jumps:int;			//	0 none, 1 first jump, 2 second jump
		
		public var jumpSound:Sound;
		public var bitmap:Bitmap;
		
		private var jumpTimer:int;
		private var animTimer:Number;
		
		//	Constructor: default
		public function Player() 
		{
			super();
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		//	Initialises the Player after being added to the stage
		private function onInit(e:Event = null):void
		{
			
			jumpSound = new Resources.AUDIO_JUMP();
			bitmap = new Resources.GRAPHIC_PLAYER();
			
			addChild(bitmap);
			bitmap.width = 50;
			bitmap.height = 50;
			radius = 115;
			
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
			
			
			jumpTimer = 0;
			jumps = 0;
			speed = 0;
			animTimer = 0;
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			stage.addEventListener(OrbitalEvent.TICK_MAIN, onTick);
		}
		
		//	Listener: onTick
		//	Updates the player position and animation each frame
		private function onTick(e:OrbitalEvent):void
		{
			animTimer++;
			
			//	take inputs
			processInputs();
			
			if (--jumpTimer < 0) jumpTimer = 0;
			
			//	main speed control
			speed -= 1;
			radius += speed;
			if (radius < 115) {
				speed = 0;
				radius =  115;
				jumps = 0;
			}
			
			//	rotate in a more "square" pattern for visual interest
			if (animTimer < 2) {
				rotation += 0.5;
			}else if (animTimer < 5){
				rotation += 1;
			}else if (animTimer < 15) {
				rotation += 8.2;
			}else if (animTimer < 15) {
				rotation += 1;
			}else if (animTimer < 17) {
				rotation += 0.5;
			}else {
				animTimer = 0;
			}
				
				
			if (jumps > 1) {
				rotation++;
			}
			
			var rand:Number = Math.random() * 100;
			if ((rand % 30) < 1) {
				if (jumps < 1) {
					speed = 4;
				}
			}
			
			//	Update y position so it  balances on top of the world
			y =15*(1-scaleX) - radius;
		}
		
		//	Function: jump
		//	Jumps the player up, if they are not already beyond their second jump
		public function jump():void
		{
			if ((jumps < 1)){
				speed = 12;
				jumps = 1;
				jumpTimer = 5;
				stage.dispatchEvent(new OrbitalEvent( OrbitalEvent.JUMP, 1));
				
			}else if ((jumps < 2) && jumpTimer==0){
				speed = 15;
				jumps = 2;
				stage.dispatchEvent(new OrbitalEvent( OrbitalEvent.JUMP, 2));
			}
		}
		
		//	Function: processInputs
		//	Helper function that alters the player movement based on the keys pressed; run each frame by onTick
		private function processInputs():void
		{
			//	Jump when space is pressed
			if (Keys.isDown(Keys.SPACE)) {
					jump();
			}
			//	Go down and shrink if S is pressed
			if (Keys.isDown(Keys.S)) {
					speed -= 3;
					scaleX = 0.5;
					scaleY = 0.5;
			//	Otherwise ensure the player returns to the usual size (not shrunk)
			}else {
				scaleX = 1;
				scaleY = 1;
			}
			
		}
		
		//	Function: kill
		//	Kills all listeners for this object
		public function kill():void
		{
			if(stage){
				stage.removeEventListener(OrbitalEvent.TICK_MAIN, onTick);
				visible = false;
			}
		}
		
		
	}

}