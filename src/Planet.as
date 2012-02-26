//	Copyright 2012 Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Planet
//		The main rotating planet

package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	//	Class: planet
	public class Planet extends Sprite
	{
		[Embed(source = "../resources/planet.png")]
		private var IMG_PLANET:Class;
		
		private var image:Bitmap;
		public var speed:Number;
		
		//	Constructor: default
		public function Planet() 
		{
			super();
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		private function onInit(e:Event = null):void
		{
			image = new IMG_PLANET();
			
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
		private function onTick(e:Event):void
		{
			rotation -= speed;
		}
		
	}

}