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
	
	import orbital.events.OrbitalEvent;
	
	//	Class: SoundManager
	public class SoundManager
	{
		private static var stageRef:Stage;				//	Reference to the stage for event use
		
		private static const volume:Number = 0.5;			//	Volume to play sounds at
		
		private static var introSound:Sound;			//	Introductory noise when the game opens
		private static var loseSound:Sound;				//	"Awww" sound when you lose
		private static var starSound:Sound;				//	Star pickup sound
		private static var jumpSound:Sound;				//	Jump sound
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
			jumpSound = new Resources.AUDIO_JUMP();
			bgSound = new Resources.AUDIO_BGMUSIC();
			bgChannel = new SoundChannel();
			
			//	Basic sound effect listeners
			stage.addEventListener(OrbitalEvent.START_INTRO, onIntro);
			stage.addEventListener(OrbitalEvent.START_MAIN, onMain);
			stage.addEventListener(OrbitalEvent.HIT_BOMB, onLose);
			stage.addEventListener(OrbitalEvent.HIT_STAR, onStar);
			stage.addEventListener(OrbitalEvent.JUMP, onJump);

		}
		
		//	Listener: onIntro
		//	Plays the intro loading sound on startup
		private static function onIntro(e:OrbitalEvent):void
		{
			introSound.play(0, 0, new SoundTransform(1 * volume));
			
			bgChannel.stop();
			bgChannel = bgSound.play(0, 0, new SoundTransform(volume/2));
		}
		
		//	Listener: onMain
		//	Plays the intro loading sound on startup
		private static function onMain(e:OrbitalEvent):void
		{
			bgChannel.stop();
			bgChannel = bgSound.play(0, 0, new SoundTransform(1 * volume));
		}
		
		//	Listener: onLose
		//	Plays the gameover sound when you lose
		private static function onLose(e:OrbitalEvent):void
		{
			loseSound.play( 0, 0, new SoundTransform(volume) );
			bgChannel.soundTransform = new SoundTransform(volume / 2);
		}
		
		//	Listener: onJump
		//	Plays the star pickup sound
		private static function onStar(e:OrbitalEvent):void
		{
			starSound.play( 0, 0, new SoundTransform(volume) );
		}
		
		//	Listener: onJump
		//	Plays the jump sound
		private static function onJump(e:OrbitalEvent):void
		{
			//	Abusing the tickCount to hold if it's the first or second jump
			jumpSound.play( 0, 0, new SoundTransform(volume/(e.tickCount)) );
		}
	}

}