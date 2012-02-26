//	Copyright 2012	Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Bomb
//		Kills you if you hit it!

package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Bomb extends Sprite
	{
		[Embed(source="../resources/bomb.png")]
		private var IMAGE_STAR:Class;
		
		public var starImage:Bitmap;
		public var radius:Number;
		public var alive:Boolean;
		
		//	Constructor: Default
		public function Bomb(radius:Number) 
		{
			super();
			this.radius = radius;
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event = null):void
		{
			starImage = new IMAGE_STAR();
			starImage.width = 25;
			starImage.height = 25;
			
			addChild(starImage);
			
			alive = true;
			
			starImage.x = -starImage.width / 2;
			starImage.y = -starImage.height / 2 + radius;
			
			stage.addEventListener(TickEvent.PLANET_TICK, onTick);
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onTick(e:TickEvent):void
		{
			rotation -= 1 * e.difficulty;
			if ((rotation < 110) && (rotation > 0)) {
				radius -= 1 * e.difficulty;
			}
			if ((rotation < 0) && (rotation > -45) ) {
				radius += 1 * e.difficulty;
			}else if (radius < 105) {
				alive = false;
				visible = false;
			}
			
			starImage.y = -starImage.height / 2 + radius;
		}
		
	}

}