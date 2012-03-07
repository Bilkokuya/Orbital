//	Copyright 2012 Gordon D Mckendrick
//	Author: Gordon D Mckendrick
//	
//	SoundHandler
//		Players the correct sound at the correct time

package orbital.util 
{
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	//	Class: SoundManager
	public class SoundManager
	{
		private static var stageRef:Stage;				//	Reference to the stage for event use
		
		private static const volume:Number = 0;		//	Volume to play sounds at
		
		private static var introSound:Sound;			//	Introductory noise when the game opens
		private static var loseSound:Sound;			//	"Awww" sound when you lose
		private static var starSound:Sound;			//	Star pickup sound
		private static var bgSound:Sound;				//	Background Music
		private static var bgChannel:SoundChannel;		//	Channel to allow stop/start of background music	
		
		
		//	Constructor: SoundManager DO NOT USE THIS
		public function SoundManager(stage:Stage);
		
		//	Function: init
		//	Initialise this utility without instantiating it
		public static function init(stage:Stage):void
		{
			stageRef = stage;
			
			introSound = new Resources.AUDIO_INTRO();
			loseSound = new Resources.AUDIO_LOSE();
			starSound = new Resources.AUDIO_STAR();
			bgSound = new Resources.AUDIO_BGMUSIC();
			bgChannel = new SoundChannel();
		}
		
		private function onIntro():void
		{
			introSound.play(0, 0, new SoundTransform(1 * volume));
		}
	}

}