//	Copyright 2012	Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Collectable
//		Golden collectable coin for points!

package orbital.entity
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import orbital.util.Resources;
	
	import orbital.events.TickEvent;

	public class Collectable extends Sprite
	{
		public var starImage:Bitmap;
		public var radius:Number;
		public var alive:Boolean;
		
		//	Constructor: Default
		public function Collectable(radius:Number) 
		{
			super();
			this.radius = radius;
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(e:Event = null):void
		{
			starImage = new Resources.GRAPHIC_STAR();
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
			rotation -= e.difficulty;
			if ((rotation < 110) && (rotation > 0)) {
				radius -= e.difficulty;
			}
			if ((rotation < 0) && (rotation > -45) ) {
				radius += e.difficulty;
			}else if (radius < 105) {
				alive = false;
				visible = false;
			}
			
			starImage.y = -starImage.height / 2 + radius;
		}
		
	}

}