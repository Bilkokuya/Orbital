//	Copyright 2012	Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Collidable

package orbital.entity 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import orbital.events.TickEvent;
	
	//	Class: Collidable
	public class Collidable extends Sprite
	{
		public var isAlive:Boolean;		//	True if the object is still live and collidable in the world
		public var radius:Number;		//	Radius from the center of the planet
		private var bitmap:Bitmap;		//	Bitmap graphic of this entity
		
		private var rotSpeed:Number;	//	Rotational speed around the planet as a whole (how fast it orbits the planet).
		private var spinSpeed:Number;	//	Rotational speed of the image, relative to it's own center (how fast it spins around).
		private var speed:Number;		//	Linear speed towards the planet
		
		//	Constructor: default
		public function Collidable() 
		{
			super();
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		
		//	Listener: onInit
		//	Initialises the collidable once added to the stage
		public function onInit(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			stage.addEventListener(TickEvent.PLANET_TICK, onTick);
		}
		
		//	Listener: onTick
		//	Updates position every tick
		public function onTick(e:TickEvent):void
		{
			//	Update the rotation and radius
			rotation += rotSpeed;
			bitmap.rotation += spinSpeed;
			radius += speed;
			
			//	Ensure radius doesn't go below the minimum planet size
			if (radius < 100) {
				radius = 100;
			}
			
			//	Update the position to the new radius
			bitmap.y = radius;
		}
	}

}