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
	import orbital.events.OrbitalEvent;
	import orbital.util.Resources;

	//	Class: planet
	public class Planet extends Sprite
	{
		private var imageContainer:Sprite;	//	Container for the bitmap, for easy rotation
		private var bitmap:Bitmap;			//	The bitmap graphic of the planet itself
		private var rotSpeed:Number;		//	The current rotation speed of the planet
		
		public var satellites:Array;		//	Array of Satellites, keeps track of all the orbitting satellites
		private var player:Player;			//	The player object
		
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
			satellites = new Array();
			imageContainer = new Sprite();
			
			//	Initialise the bitmap graphic
			addChild(imageContainer);
			bitmap.width = 250;
			bitmap.height = 250;
			imageContainer.addChild(bitmap);
			bitmap.x = -bitmap.width/2;
			bitmap.y = -bitmap.height/2;
			
			//	Set the initial speed and position
			rotSpeed = 1;
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			stage.addEventListener(OrbitalEvent.TICK_MAIN, onTick);
			stage.addEventListener(OrbitalEvent.TICK_END, onTick);
			stage.addEventListener(OrbitalEvent.TICK_INTRO, onTick);
		}
		
		
		//	Listener: onTick
		//	Rotates the planet every tick of the game
		private function onTick(e:OrbitalEvent):void
		{
			//	Spawns something every second, with a random factor (at difficulty 1)
			var random:int = (Math.random() - 0.5) * 20;
			if (Math.abs(e.tickCount % (30 / e.difficulty) + random) < 0.5) {
				spawnSatellite();
			}
			
			//	Update the rotation of the image
			imageContainer.rotation -= rotSpeed;
		}
		
		
		//	Function: spawnSatellite
		//	Spawns a new satellite as child of this planet
		private function spawnSatellite():void
		{	
			var chance:int = (Math.random() * 100);
			
			//	Determine how many to be spawned
			var spawnCount:int = 0;
			if (chance < 1) {
				spawnCount = 3;
			}else if (chance < 5) {
				spawnCount = 2;
			}else if (chance < 70) {
				spawnCount = 1;
			}
			
			//	Spawn each new satellite
			for (var i:int = 0; i < spawnCount; i++) {
				var satellite:Satellite = new Satellite(Math.random() * 50 + 60);	//	Minimum radius is 60 + 45(implicit)
				
				//	Determine if it's a "bomb" or "star"
				if (Math.random() < (1/3)) {
					satellite.type = Satellite.BOMB;
				}else {
					satellite.type = Satellite.STAR;
				}
				satellites.push(satellite);
				addChild(satellite);
				
				//	Force the main planet image to be infront of any new satellites
				if (numChildren > 1){
					swapChildrenAt(numChildren - 2, numChildren-1);
				}
			}
			
		}
		
		private function checkCollisions():void
		{
			//	Run collision detection for each satellite
			//	dispatch events when the player hits things
			for each (var satellite:Satellite in satellites) {
				if (satellite.isAlive) {
					
					//	If the player and satellite are at the same rotation position
					if ((satellite.rotation < -180 + 10*player.scaleX) || (satellite.rotation > 180 - 10*player.scaleX)) {
						
						//	Check if they are at the same radius from the planet (a collision)
						if (Math.abs(satellite.radius - player.radius) < 10 * player.scaleX) {
							if (satellite.type == Satellite.STAR) {
								stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.HIT_STAR));
							}else {
								stage.dispatchEvent(new OrbitalEvent(OrbitalEvent.HIT_BOMB));
							}
							satellite.isAlive = false;
							satellite.visible = false;
							removeChild(satellite);
						}
					}
				}
			}
			
		}
		
		
	}

}