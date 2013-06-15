package com.speakaboos.mobile.ios.notifications
{
	
	import com.milkmangames.nativeextensions.EasyPush;
	import com.milkmangames.nativeextensions.PNAirship;
	import com.milkmangames.nativeextensions.events.PNAEvent;
	import com.speakaboos.core.settings.AppConfig;
	import com.speakaboos.ipad.utils.debug.Logger;
	
	public class PushNotificationsController
	{

		/** Your Airship Application Key */
		public static const AIRSHIP_KEY_DEV:String="3OILNhinSOm9n4_iVR-v5w";	
		/** Your Airship Application (NOT master!) Secret */
		public static const AIRSHIP_SECRET_DEV:String="zUrEybbGRKG9RhUZ9QfbtQ";

		/** Airship production credentials */
		public static const AIRSHIP_KEY_PROD:String="VSCk2RGQTdCX9lgcCOKQkQ";
		public static const AIRSHIP_SECRET_PROD:String="hGhVnyVfT1S8marSQzP6Ig";
		
		public static const AIRSHIP_ACCOUNT:String = "speakaboo";
		private var _isDev:Boolean;
		private var _airShip:PNAirship;
		
		public function PushNotificationsController(isDev:Boolean=true)
		{
			_isDev = isDev;	
		}
		
		public function init():Boolean{
			
			if (!EasyPush.isSupported())
			{
				Logger.log("[EasyPush] EasyPush is not supported on this platform (not android or ios!)");
				return false;
			}
			if (!EasyPush.areNotificationsAvailable())
			{
				Logger.log("[EasyPush] Notifications are disabled!");
				return false;
			}
			
			Logger.log("[EasyPush] init airship...");
			var isError:Boolean = false;
			var secret:String = (AppConfig.releaseIsDev()) ? AIRSHIP_SECRET_DEV : AIRSHIP_SECRET_PROD;
			var key:String = (AppConfig.releaseIsDev()) ? AIRSHIP_KEY_DEV : AIRSHIP_KEY_PROD;
			
			try{
				if(_airShip){isError = true;}
				else
				{_airShip = EasyPush.initAirship(key, secret, AIRSHIP_ACCOUNT, _isDev, true);	}		
			}
			catch(err:Error){
				Logger.log("[EasyPush] ERROR: airShip was already initialized!");
				isError = true;
			}
			finally{
				if(!isError){
					Logger.log("[EasyPush] airship initialized.");
					_airShip.addEventListener(PNAEvent.ALERT_DISMISSED,onAlertDismissed);
					_airShip.addEventListener(PNAEvent.FOREGROUND_NOTIFICATION,onNotification);
					_airShip.addEventListener(PNAEvent.RESUMED_FROM_NOTIFICATION,onNotification);
					_airShip.addEventListener(PNAEvent.TOKEN_REGISTERED,onTokenRegistered);
					_airShip.addEventListener(PNAEvent.TOKEN_REGISTRATION_FAILED,onRegFailed);
					_airShip.addEventListener(PNAEvent.TYPES_DISABLED,onTokenTypesDisabled);
				}
			}
			

			Logger.log("[EasyPush] EasyPush Ready!");
			
			return true;
		}
		
		
		public function destroy():void{
			if(_airShip){
				_airShip.removeEventListener(PNAEvent.ALERT_DISMISSED,onAlertDismissed);
				_airShip.removeEventListener(PNAEvent.FOREGROUND_NOTIFICATION,onNotification);
				_airShip.removeEventListener(PNAEvent.RESUMED_FROM_NOTIFICATION,onNotification);
				_airShip.removeEventListener(PNAEvent.TOKEN_REGISTERED,onTokenRegistered);
				_airShip.removeEventListener(PNAEvent.TOKEN_REGISTRATION_FAILED,onRegFailed);
				_airShip.removeEventListener(PNAEvent.TYPES_DISABLED,onTokenTypesDisabled);
				
				_airShip = null;
			} 
			
		}
		
		// Events
		//	
		
		private function onTokenRegistered(e:PNAEvent):void
		{
			Logger.log("[EasyPush] token registered:"+e.token);
		}
		
		private function onTokenTypesDisabled(e:PNAEvent):void
		{
			Logger.log("[EasyPush] disabled token types:"+e.disabledTypes);
		}
		
		private function onRegFailed(e:PNAEvent):void
		{
			Logger.log("[EasyPush] reg failed: "+e.errorId+"="+e.errorMsg);
		}
		
		private function onAlertDismissed(e:PNAEvent):void
		{
			Logger.log("[EasyPush] dismissed alert "+e.alert);
		}
		
		private function onNotification(e:PNAEvent):void
		{
			Logger.log("[EasyPush] " + e.type+"="+e.rawPayload+","+e.badgeValue+","+e.title);
		}
		
	}
}