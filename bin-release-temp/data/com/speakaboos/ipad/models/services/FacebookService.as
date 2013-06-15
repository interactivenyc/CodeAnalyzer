package com.speakaboos.ipad.models.services
{
	import com.milkmangames.nativeextensions.GVFacebookFriend;
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.LoginEvents;
	import com.speakaboos.ipad.models.data.UserProfile;
	import com.speakaboos.ipad.utils.debug.TraceObject;

	public class FacebookService extends CoreService
	{
		private static var _instance:FacebookService;
		private static var _activated:Boolean = false;
		
		public function FacebookService( enforcer:SingletonEnforcer ){
			super();
			initFacebook();
		}
		
		
		public static function getInstance():FacebookService {
			if( _instance == null ) {
				_instance = new FacebookService( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		override public function destroy():void{
			super.destroy();
			
			if(_activated){
				removeEventListeners();
				GoViral.goViral.dispose();
				_activated = false;
			}
			
			if(_instance){_instance = null;}
		}
		
		/**
		 * initialize facebook extension
		 */
		final private function initFacebook():void{
			log("initFacebook");
			
			if(GoViral.isSupported()){
				//log("goviral is supported");
				GoViral.create();
				GoViral.goViral.initFacebook("211032669024829", "");
				addEventListeners();
				_activated = true;
			}else{
				//log("GoViral only works on iOS!");
				return;
			}			
		}
		
		final private function addEventListeners():void{
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_CANCELED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FAILED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED, onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookEvent);
		}
		
		final private function removeEventListeners():void{
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_DIALOG_CANCELED, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_DIALOG_FAILED, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_DIALOG_FINISHED, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGGED_IN, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGGED_OUT, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGIN_CANCELED, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_LOGIN_FAILED, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_REQUEST_FAILED, onFacebookEvent);
			GoViral.goViral.removeEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE, onFacebookEvent);
		}
		
		final public function fbLogin():void
		{
			log("fbLogin");
			log("GoViral Version: " + GoViral.VERSION);
			if(GoViral.isSupported()){
				log("isFacebookAuthenticated:"+GoViral.goViral.isFacebookAuthenticated());
				
				if(!GoViral.goViral.isFacebookAuthenticated()){
					GoViral.goViral.authenticateWithFacebook("email");
				}
				else
				{
					//user is already authenticated with FB
					GoViral.goViral.requestMyFacebookProfile();
				}
			}else{
				_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.FB_LOGIN_FAILED));
			}
		}
		
		
		final public function fbLogout():void{
			//log("fbLogout");
			if(GoViral.isSupported()){
				//log("fbLogout -> isFacebookAuthenticated:"+GoViral.goViral.isFacebookAuthenticated());
				if(GoViral.goViral.isFacebookAuthenticated()){GoViral.goViral.logoutFacebook();}		
			}
			else{
				//log("GoViral is not supported");
			}
		}
		
		
		
//		private function setUpFBUserProfile(myProfile:GVFacebookFriend):void{
//			log("setUpFBUserProfile");
//			
//			var params:URLVariables = new URLVariables();
//			params.method = "getfbuser";
//			params.fbid = myProfile.id;
//			urlRequest.data = params;
//			
//			log("API request: " + params);
//			loader.load(urlRequest);
//		}
		
		
		
		/**
		 * All facebook events
		 */
		final private function onFacebookEvent(event:GVFacebookEvent):void{
			log("onFacebookEvent: " + event.type);
			
			switch(event.type){
				case GVFacebookEvent.FB_LOGGED_IN:
					
					GoViral.goViral.requestMyFacebookProfile();
					
					break;
				
				case GVFacebookEvent.FB_LOGGED_OUT:
					break;
				
				case GVFacebookEvent.FB_LOGIN_FAILED:
				case GVFacebookEvent.FB_LOGIN_CANCELED:
				case GVFacebookEvent.FB_REQUEST_FAILED:
					fbLoginFailed();
					break;
				
				case GVFacebookEvent.FB_REQUEST_RESPONSE:
					log("FB REQUEST RESPONSE event.type = " + event.type);
					log("FB REQUEST RESPONSE event.graphPath = " + event.graphPath);	
					
					log("*****************************");
					log("*** FB data:");
					log("*****************************");
					
					log(event.data);
					
					var formattedJson:String = TraceObject.DUMP(event.jsonData);
					log("*****************************");
					log("*** FB jsonData:");
					log("*****************************");
					log(formattedJson);
					
					
					if(event.graphPath == "me"){
						var myProfile:GVFacebookFriend = event.friends[0];
						
						var userProfile:UserProfile = new UserProfile();
						userProfile.initWithFbData(myProfile);
						
						_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.FB_LOGGED_IN, {userProfile:userProfile}));
					}else
					{
						fbLoginFailed();
					}

					break;
				case GVFacebookEvent.FB_DIALOG_CANCELED:
					break;
				case GVFacebookEvent.FB_DIALOG_FAILED:
					break;
				case GVFacebookEvent.FB_DIALOG_FINISHED:
					break;
			}
		}
		
		final private function fbLoginFailed():void{
			_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.FB_LOGIN_FAILED));
		}
		
		
		final private function isStillAuthenticated():Boolean{
			
			if(!GoViral.isSupported())
				return false;
			
			if(!_activated)
				initFacebook();
			
			return GoViral.goViral.isFacebookAuthenticated();
			
		}
		
		
		final public function reAuthenticate():void{
			if(!isStillAuthenticated())
				fbLogin();
			else
				GoViral.goViral.requestMyFacebookProfile();
		
		}
		
		
		
	}
}


class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}

