//	
//
//
//

package orbital.entity 
{
	import flash.events.Event;
	import orbital.util.Resources;

	//	Class: Bomb
	public class Bomb extends Satellite
	{
		//	Constructor: (Number)
		public function Bomb(radius:Number = 0) 
		{
			super(radius);
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		//	Listener: onInit
		//	Initialises the graphics for this bomb
		private function onInit(e:Event = null):void
		{
			//	Set up the bitmap graphic for this Bomb
			bitmap = new Resources.GRAPHIC_BOMB();
			bitmap.width = 25;
			bitmap.height = 25;
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
			
			imageContainer.addChild(bitmap);
			
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
	}

}