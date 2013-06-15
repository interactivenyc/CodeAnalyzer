package com.speakaboos.ipad.events
{
	import flash.events.Event;
	
	public class VideoEvents extends Event
	{
		public static var FULLSCREEN_VIDEO_DONE_PLAYING:String = "onFullScreenVideoDonePlaying";
		public static var VIDEO_DONE_PLAYING:String = "onVideoDonePlaying";
		
		public function VideoEvents( type:String = null) { super( type ); }

	}
}