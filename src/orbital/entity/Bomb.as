//	Copyright 2012	Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Bomb
//		Kills you if you hit it!

package orbital.entity
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import orbital.util.Resources;
	
	import orbital.events.TickEvent;
	
	//	Class: Bomb
	public class Bomb extends Satellite
	{
		//	Constructor: Default
		public function Bomb(radius:Number) 
		{
			super();
			
			this.radius = radius;
			
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		//	Initialises the bomb once the stage exists
		private function onInit(e:Event = null):void
		{
			//	Initialise the bitmap image
			bitmap = new Resources.GRAPHIC_BOMB();
			bitmap.width = 25;
			bitmap.height = 25;
			
			imageContainer.addChild(bitmap);
			bitmap.y = -bitmap.width / 2;
			bitmap.x = -bitmap.width / 2;

			imageContainer.x = -radius;
			
			stage.addEventListener(TickEvent.PLANET_TICK, onTick);
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onTick
		//	Runs every main game tick
		private function onTick(e:TickEvent):void
		{
			rotSpeed = -e.difficulty;
			
			if ((rotation > 15) && (rotation < 60)) {
				speed = -e.difficulty;
			
			}else if ((rotation < 0) && (rotation > -45) ) {
				speed = e.difficulty;
				
			}else {
				speed = 0;
			}
		}
		
	}

}