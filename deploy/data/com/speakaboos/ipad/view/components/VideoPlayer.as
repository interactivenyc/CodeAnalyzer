package  com.speakaboos.ipad.view.components{
	
	import com.sdk.fw.components.videoPlayer.videoCore.ConnectionType;
	import com.sdk.fw.components.videoPlayer.videoCore.VideoAssetMetadata;
	import com.sdk.fw.components.videoPlayer.videoCore.VideoConnectionInfo;
	import com.sdk.fw.components.videoPlayer.videoCore.VideoCore;
	import com.sdk.fw.components.videoPlayer.videoCore.events.VideoCoreEvent;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	
	public class VideoPlayer extends CoreMovieClip {
		
		public static const VIDEO_START:String = 'VIDEO_START';
		public static const VIDEO_FINISHED:String = 'VIDEO_FINISHED';
		public static const PLAYER_READY:String = 'PLAYER_READY';
		
		private var debugPanel:TextField;
		private var addedToStage:Boolean = false;
		
		private var videoFile:String;
		private var stageVideoEnabled:Boolean = false;
		
		private var _stageVideo:StageVideo;
		private var _video:VideoCore;
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _width:int;
		private var _height:int;
		
		private var _darkScreen:Shape;
		private var _removedStageChildren:Array;

		
		public function VideoPlayer(width:int = 1200, height:int = 900) {
			_width = width;
			_height = height;
		}
		
		override protected function onAddedToStage(e:Event) :void{
			super.onAddedToStage(e);
			log('ADDED TO STAGE');
			addedToStage = true;
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onAvail);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function playVideo(videoFile:String) :void{
			log('playVideo: '+videoFile);
			if(addedToStage){
				this.videoFile = videoFile;
				if(stageVideoEnabled){
					playStageVideo();
				}
				else{
					playCoreVideo();
				}
			}
			else{
				//log('NOT ON STAGE');
			}
		}
		
		public function stopVideo() :void{
			log('stopVideo: _ns: '+_ns);
			log('stopVideo: _nc: '+_nc);
			log('_stageVideo: _nc: '+_stageVideo);
			
			if (_stageVideo){
				_ns.close();
				_stageVideo.attachNetStream( null );
			}else{
				_video.stop();
			}
			
			
		}
		private function onAvail(e:StageVideoAvailabilityEvent) :void{
			//log(e.availability);
			if(e.availability == StageVideoAvailability.AVAILABLE){
				//log('VIDEO AVAILABLE');
				stageVideoEnabled = true;
			}
			dispatchEvent(new Event(PLAYER_READY));
		}
		
		private function playStageVideo() :void{
			//log('STARTING TO PLAY');
			
			_stageVideo = stage.stageVideos[0];
			_stageVideo.viewPort = new Rectangle(0, 0, _width, _height); 
			_stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onRenderStageVideo);
			
			_nc = new NetConnection();
			_nc.connect(null);
			
			_ns = new NetStream(_nc);
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.client = this;
			
			_stageVideo.attachNetStream(_ns);
			_ns.play(videoFile);
		}
		
		private function playCoreVideo() :void{
			//log("playCoreVideo");
			
			_video = new VideoCore(	_width, _height, 0.1, true );
			addChild( _video );
			
			_video.addEventListener( VideoCoreEvent.PLAY_COMPLETE, onPlayComplete );
			_video.addEventListener( VideoCoreEvent.RENDERING_STAGE_VIDEO, onRenderCoreVideo );
			_video.addEventListener( VideoCoreEvent.METADATA, onVideoMetadata );
			
			var connection:VideoConnectionInfo;
			connection = new VideoConnectionInfo(videoFile, ConnectionType.PROGRESSIVE);
			_video.load( connection );
		}
		
		private function onRenderStageVideo(e:StageVideoEvent) :void{
			log('onRenderStageVideo '+e.toString());
			//_stageVideo.viewPort = new Rectangle(0, 0, _width, _height);
		}
		
		private function onRenderCoreVideo( evt:VideoCoreEvent ):void {
			//log('onRenderCoreVideo');
		}
		
		
		private function onVideoMetadata( evt:VideoCoreEvent ):void {
			var metadata:VideoAssetMetadata =	VideoAssetMetadata( evt.info );
		}
		
	
		
		
		private function onNetStatus(e:NetStatusEvent) :void{
			log(e.info.code);
			
			switch(e.info.code){
				case "NetStream.Play.Start":
					log('VIDEO START');
					dispatchEvent(new Event(VIDEO_START));
					break;
				case "NetStream.Play.Stop":
					log('VIDEO STOPPED');
					onPlayComplete();
					break;
			}
		}
		
		private function onPlayComplete(e:VideoCoreEvent = null):void{
			log("onPlayComplete");
			dispatchEvent(new Event(VIDEO_FINISHED));
		}
		public function onXMPData(info:Object) :void{
			//log("onXMPData");
			//log(info);
		}
		public function onMetaData(info:Object) :void{
			//log("onMetaData");
			//log(info);
		}
		public function onCuePoint(info:Object) :void{
			//log("onCuePoint");
			//log(info);
		}
		public function onPlayStatus(info:Object) :void{
			//log("onPlayStatus");
			//log(info);
		}
		
	}
	
}