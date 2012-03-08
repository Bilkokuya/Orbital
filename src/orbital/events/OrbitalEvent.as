//	Copyright 2012 Gordon D Mckendrick©
//	Author: Gordon D Mckendrick
//
//	TickEvent
//		Thrown every tick to co-ordinate the different parts of game logic

package orbital.events
{
	import flash.events.Event;
	
	//	Class: TickEvent
	public class OrbitalEvent extends Event 
	{
		//	Event Types
		public static const TICK_MAIN:String 	= "TICK_MAIN";		//	Tick event for the main game logic
		public static const TICK_INTRO:String 	= "TICK_INTRO";		//	Tick event for the intro screen
		public static const TICK_END:String 	= "TICK_END";		//	Tick event for the game over screen
		public static const HIT_BOMB:String 	= "HIT_BOMB";		//	When the player hits a bomb
		public static const HIT_STAR:String 	= "HIT_STAR";		//	When the player hits a star
		public static const START_INTRO:String 	= "START_INTRO";	//	Signals the start of the intro
		public static const START_MAIN:String 	= "START_MAIN";		//	Signals the start of the game
		public static const START_END:String 	= "START_END";		//	Signals the start of the gameover screen
		public static const JUMP:String 		= "JUMP";			//	Signals that the player has jumped

		
		//	Event Data
		public var difficulty:Number;	//	The current difficulty level, that affects various spawn rates through the game
		public var tickCount:Number;	//	The number of ticks that have passed since the game started
		
		//	Constructor: (String, Number, Boolean, Boolean)
		public function OrbitalEvent(type:String, tickCount:int = 1, difficulty:Number = 1, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			this.difficulty = difficulty;
			this.tickCount = tickCount;
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