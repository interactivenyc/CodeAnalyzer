package com.speakaboos.ipad.models.services
{
	import com.speakaboos.core.service.IService;
	import com.speakaboos.core.settings.AppConfig;
	import com.speakaboos.ipad.BaseClass;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.CoreEventDispatcher;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.models.data.ErrorStruct;
	import com.speakaboos.ipad.utils.ObjectUtils;
	
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class CoreService extends BaseClass implements IService
	{
		protected var _eventDispatcher:CoreEventDispatcher;
		
		protected var loader:URLLoader;
		protected var urlRequest:URLRequest;
		protected static const SERVICE_BASE_URL_DEV:String = "test-api.speakaboos.com/ws/v2";
		protected static const SERVICE_BASE_URL_PROD:String = "api.speakaboos.com/ws/v2";
		
		/*
		_tempDataStore is used for holding the data that comes in through a service request
		so that it's still available for the service response. 
		*/
		protected var _tempDataStore:Object;
		
		public function CoreService(){
			_eventDispatcher = CoreEventDispatcher.getInstance();
			
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			_tempDataStore = {};
		}
		
		protected function onIOError(e:IOErrorEvent):void{
			log("onIOError: "+e.text);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.NETWORK_ERROR, {error:e}));
		}
		
		
		public function destroy():void{
			if(_tempDataStore == null){
				return;
			}
			
			if(ObjectUtils.methodExists(_tempDataStore, "destroy")){
				try{
					_tempDataStore.destroy();
				}catch(err:Error){}
			}
			
			_tempDataStore = null;
			
			//TODO: call destroy on eventDispatcher & networkMonitor?
			_eventDispatcher = null;
			
			loader = null;
			urlRequest = null;
		}
	
		
		protected function onSecurityError(e:SecurityError):void{
			log("onSecurityError: "+e.message);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.NETWORK_ERROR, {error:e}));
		}
		
		
		private static function get baseURL():String{
			return AppConfig.isServicesProd() ? SERVICE_BASE_URL_PROD : SERVICE_BASE_URL_DEV;
		}
			
	
		public static function getBaseURL(isSecure:Boolean = false):String{
			var url:String = (isSecure ? "https://" : "http://" ) + baseURL;
			return (url);
		}
		
		
		final protected function responseOK(jsonData:Object):Boolean{
			
			var response:Object = (jsonData.response != null) ? jsonData.response : null;
			
			if(response == null || response.status == null || response.status != "ok") {
				return false;
			}
			
			return true;
			
		}
		
		final protected function getErrorStructFromJsonData(jsonData:Object):ErrorStruct{
			
			var thisError:ErrorStruct;
			
			if(jsonData && jsonData.response){
				
				var e:String = ObjectUtils.getSafeParameter(jsonData.response, "error");
				var c:int = int(ObjectUtils.getSafeParameter(jsonData.response, "code", "0"));
				
				thisError = new ErrorStruct(e, c);
			}
			else{
				thisError = new ErrorStruct();
				
			}
			
			
			return thisError;
		}
		
		
		
	}
}