//	Copyright 2012 Gordon D Mckendrick©
//	Author: Gordon D Mckendrick
//
//	TickEvent
//		Thrown every tick to co-ordinate the different parts of game logic

package orbital.events
{
	import flash.events.Event;
	
	//	Class: TickEvent
	public class TickEvent extends Event 
	{
		//	Event Types
		public static const PLANET_TICK:String = "PLANET_TICK";
		
		//	Event Data
		public var difficulty:Number;	//	The current difficulty level, that affects various spawn rates through the game
		
		
		//	Constructor: (String, Number, Boolean, Boolean)
		public function TickEvent(type:String, difficulty:Number, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			this.difficulty = difficulty;
			super(type, bubbles, cancelable);
		} 
		
		//	Function: clone (OVERRIDE)
		//	A more efficient clone constructor, that returns a reference to this instead of a new copy
		//		This makes the event less "safe", but the limited situations this event is used in avoid most possibility of the events data being hijacked.
		public override function clone():Event 
		{ 
			return this;
		} 
		
		//	Function: toString (OVERRIDE)
		//	Returns the string representation of this event
		public override function toString():String 
		{ 
			return formatToString("TickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}