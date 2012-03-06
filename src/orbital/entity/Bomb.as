//	Copyright 2012	Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Bomb
//		Kills you if you hit it!

package orbital.entity
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import orbital.util.Resources;
	
	import orbital.events.TickEvent;

	public class Bomb extends Sprite
	{
		public var starImage:Bitmap;
		public var radius:Number;
		public var isAlive:Boolean;
		
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
			starImage = new Resources.GRAPHIC_BOMB();
			starImage.width = 25;
			starImage.height = 25;
			
			addChild(starImage);
			
			isAlive = true;
			
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
				isAlive = false;
				visible = false;
			}
			
			starImage.y = -starImage.height / 2 + radius;
		}
		
	}

}