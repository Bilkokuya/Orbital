//	Copyright 2012 Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Planet
//		The main rotating planet

package orbital.entity
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import orbital.util.Resources;

	//	Class: planet
	public class Planet extends Sprite
	{
		private var image:Bitmap;	//	The bitmap graphic of the planet itself
		public var speed:Number;	//	The current rotation speed of the planet
		
		//	Constructor: default
		public function Planet() 
		{
			super();
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		//	Initialises the planet once it's been setup on the stage
		private function onInit(e:Event = null):void
		{
			image = new Resources.GRAPHIC_PLANET();
			
			addChild(image);
			
			image.width = 250;
			image.height = 250;
			image.x = -width/2;
			image.y = -height/2;
			
			speed = 1;
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			addEventListener(Event.ENTER_FRAME, onTick);
		}
		
		//	Listener: onTick
		//	Rotates the planet every tick of the game
		private function onTick(e:Event):void
		{
			rotation -= speed;
		}
		
	}

}