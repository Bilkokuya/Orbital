//	Copyright 2012	Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	Satellite
//		An object that orbits the planet as a satellite.
//		Contains simple functionality for rotating around, and spinning on the spot.

package orbital.entity 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import orbital.events.TickEvent;
	
	//	Class: Satellite
	public class Satellite extends Sprite
	{
		//Types
		public static const BOMB:String = "BOMB";			//	Representing the type as a bomb that kills the player	
		public static const COLLECTABLE:String = "STAR";	//	Representing the type as a star that gives you points
		
		public var isAlive:Boolean;				//	True if the object is still live and collidable in the world
		public var radius:Number;				//	Radius from the center of the planet
		protected var bitmap:Bitmap;			//	Bitmap graphic of this entity
		protected var imageContainer:Sprite;	//	Contains the bitmap graphic, to allow easy (spin) rotation
		protected var type:String;				//	Whether it's a collectable star or a bomb
		
		protected var rotSpeed:Number;			//	Rotational speed around the planet as a whole (how fast it orbits the planet).
		protected var spinSpeed:Number;			//	Rotational speed of the image, relative to it's own center (how fast it spins around).
		protected var speed:Number;				//	Linear speed towards the planet
		
		
		//	Constructor: default
		public function Satellite() 
		{
			super();
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		//	Initialises the satellite once added to the stage
		private function onInit(e:Event = null):void
		{
			imageContainer = new Sprite();
			addChild(imageContainer);
			
			//	Ensure variables are initialised
			isAlive = true;
			radius = 0;
			rotSpeed = 0;
			spinSpeed = 2;
			speed = 0;
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			stage.addEventListener(TickEvent.PLANET_TICK, onTick);
		}
		
		//	Listener: onTick
		//	Updates position every tick
		private function onTick(e:TickEvent):void
		{
			//	Update Rotation speed from the difficulty given
			rotSpeed = -e.difficulty;
			
			//	Set the speed for getting the satellite into position
			//	If at the start of the rotation, move the satellite out to a radius
			if ((rotation < 0) && (rotation > -45) ) {
				speed = e.difficulty;
			
			//	If near the end of rotation, move the satellite to the centre
			}else if ((rotation > 15) && (rotation < 60)) {
				speed = -e.difficulty;
			
			//	If completely ended the rotation, kill it
			}else if ((rotation > 10) && (rotation < 15)) {
				isAlive = false;
				visible = false;
				
			//	Otherwise it's in between and moving towards the player
			}else {
				speed = 0;
			}
			
			//	Update the rotation and radius
			rotation += rotSpeed;
			radius += speed;
			
			//	Ensure radius doesn't go below the minimum planet size
			if (radius < 80) {
				radius = 80;
			}
			
			//	Update the position to the new radius, as long as it exists
			if (bitmap){
				imageContainer.x = -radius;
				imageContainer.rotation += spinSpeed;
			}
		}
	}

}