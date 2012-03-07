//	Copyright 2012 Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Planet
//		The main rotating planet

package orbital.entity
{
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import orbital.events.TickEvent;
	import orbital.util.Resources;

	//	Class: planet
	public class Planet extends Sprite
	{
		private var imageContainer:Sprite;	//	Container for the bitmap, for easy rotation
		private var bitmap:Bitmap;			//	The bitmap graphic of the planet itself
		public var speed:Number;			//	The current rotation speed of the planet
		
		public var bombs:Array;
		private var ticker:Number;
		
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
			bitmap = new Resources.GRAPHIC_PLANET();
			bombs = new Array();
			imageContainer = new Sprite();
			addChild(imageContainer);
			
			bitmap.width = 250;
			bitmap.height = 250;
			
			imageContainer.addChild(bitmap);
			
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			
			bitmap.alpha = 0.9;
			
			ticker = 0;
			
			speed = 1;
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			stage.addEventListener(TickEvent.PLANET_TICK, onTick);
		}
		
		
		//	Listener: onTick
		//	Rotates the planet every tick of the game
		private function onTick(e:TickEvent):void
		{
			imageContainer.rotation -= speed;
			ticker++;
			
			
			var random:int = (Math.random() - 0.5) * 20;
			var chance:int = (Math.random() * 100);
			
			//spawn bombs
			var times:int = 0;
			if (Math.abs(ticker % (5 / e.difficulty) + random) < 0.5) {
				if (chance < 1) {
					times = 3;
				}else if (chance < 5) {
					times = 2;
				}else if (chance < 70) {
					times = 1;
				}
				for (var i:int = 0; i < times; i++){
					var b:Bomb = new Bomb((Math.random()* 105));
					bombs.push(b);
					addChild(b);
					
					//	Force the main planet image to be infront of any new bombs
					if (numChildren > 1){
						swapChildrenAt(numChildren - 2, numChildren-1);
					}
				}
			}
		}
		
	}

}