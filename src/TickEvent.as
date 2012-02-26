package  
{
	import flash.events.Event;
	
	public class TickEvent extends Event 
	{
		
		public static const PLANET_TICK:String = "PLANET_TICK";
		
		public var difficulty:Number;
		
		public function TickEvent(type:String, difficulty:Number, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			this.difficulty = difficulty;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return this;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}