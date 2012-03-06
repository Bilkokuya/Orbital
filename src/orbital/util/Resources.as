//	Copyright 2012 Gordon D Mckendrick©
//	Author: Gordon D Mckendrick
//
//	Resources
//		A utility of static variables for each of the embedded assets.
//		Avoids problems with changing paths, when embedding is struin through classes.

package orbital.util 
{

	//	Class: Resources
	public final class Resources 
	{
		//	The "bomb" that kills you when you hit it
		[Embed(source="../../../resources/graphics/bomb.png")]
		public static const GRAPHIC_BOMB:Class;
		
		//	The main planet you bounce around
		[Embed(source = "../../../resources/graphics/planet.png")]
		public static const GRAPHIC_PLANET:Class;
		
		//	The player that you control, jumping on top of the planet
		[Embed(source = "../../../resources/graphics/player.png")]
		public static const GRAPHIC_PLAYER:Class;
		
		//	The stars you collect to gain points
		[Embed(source = "../../../resources/graphics/star.png")]
		public static const GRAPHIC_STAR:Class;
		
		//	The background music for the entire game
		[Embed(source = "../../../resources/audio/bgmusic.mp3")]
		public static const AUDIO_BGMUSIC:Class;
		
		//	The intro sound when you first load the game
		[Embed(source = "../../../resources/audio/intro.mp3")]
		public static const AUDIO_INTRO:Class;
		
		//	The jump sound when the player jumps
		[Embed(source = "../../../resources/audio/jump.mp3")]
		public static const AUDIO_JUMP:Class;
		
		//	The "awww" sound that players when you lose
		[Embed(source = "../../../resources/audio/lose.mp3")]
		public static const AUDIO_LOSE:Class;
		
		//	The sound that plays when you collect a star
		[Embed(source = "../../../resources/audio/star.mp3")]
		public static const AUDIO_STAR:Class;
		
		
		//	Constructor: default and NOT TO BE USED
		public function Resources();
		
	}

}