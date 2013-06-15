package com.speakaboos.core.settings
{
	 
	public class AppConfig
	{
		
		/*******************************************************/
		//app version
		public static const APP_VERSION:String = "1.0.0";
		
		//Server to use for web services
		public static const APP_SERVICES_STAGE:String = AppConfigEnum.SERVICES_PRODUCTION;
		//public static const APP_SERVICES_STAGE:String = AppConfigEnum.SERVICES_DEVELOPMENT;
		
		//Provisioning profile in use (dev, ad hoc or app store) */
		//IMPORTANT: Please confirm your app.xml corresponds to the correct release type!!!!
		public static const APP_RELEASE_TYPE:String = AppConfigEnum.RELEASE_AD_HOC;
		
		//Log data and show debug features in app
		public static const DEBUG_MODE:Boolean = true;
		
		//Perform unit tests?
		public static const UNIT_TESTING_ENABLED:Boolean = false;
		
		
		//FORCE OFFLINE MODE
		public static var forceOfflineMode:Boolean = false;
		
		
		/*******************************************************/

		
		public function AppConfig(){}
		
		public static function get copyrightYear():String{
			return new Date().fullYear.toString();
		}
		
		
		
		/*******************************************************/
				//Convenience functions
		 /*******************************************************/
		
		public static function isServicesProd():Boolean{
			return (APP_SERVICES_STAGE == AppConfigEnum.SERVICES_PRODUCTION);
		}
		
		public static function isServicesDev():Boolean{
			return (APP_SERVICES_STAGE == AppConfigEnum.SERVICES_DEVELOPMENT);
		}
		
		public static function releaseIsAppStore():Boolean{
			return (APP_RELEASE_TYPE == AppConfigEnum.RELEASE_APP_STORE);	
		}
		
		
		public static function releaseIsAdHoc():Boolean{
			return (APP_RELEASE_TYPE == AppConfigEnum.RELEASE_AD_HOC);
		}
		
		public static function releaseIsDev():Boolean{
			return (APP_RELEASE_TYPE == AppConfigEnum.RELEASE_DEV);
		}
		
		public static function isUnitTesting():Boolean{
			return UNIT_TESTING_ENABLED;
		}
		
		
	}
}