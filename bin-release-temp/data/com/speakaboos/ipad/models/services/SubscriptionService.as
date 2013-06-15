﻿package com.speakaboos.ipad.models.services{		import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;	import com.speakaboos.core.settings.AppConfig;	import com.speakaboos.core.utils.UniqueID;	import com.speakaboos.ipad.events.GenericDataEvent;	import com.speakaboos.ipad.events.SubscriptionEvents;	import com.speakaboos.ipad.models.data.ErrorStruct;	import com.speakaboos.ipad.models.data.UserProfile;	import com.speakaboos.ipad.models.data.product.ITunesTransaction;	import com.speakaboos.ipad.models.data.product.SpeakaboosSubscriptionProduct;	import com.speakaboos.ipad.models.services.test.TestSubscriptionErrorCode;	import com.speakaboos.ipad.utils.ObjectUtils;		import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.net.URLRequest;	import flash.net.URLVariables;
			public class SubscriptionService extends CoreService	{				private static var _instance:SubscriptionService;						public function SubscriptionService( enforcer:SingletonEnforcer) {			super();			if( enforcer == null ) throw new Error( "SubscriptionService is a singleton class and should only be instantiated via its static getInstance() method" );		}				public static function get instantiated():Boolean {return Boolean(_instance)};				public static function getInstance():SubscriptionService {			if( _instance == null ) {				_instance = new SubscriptionService( new SingletonEnforcer() );			}				return _instance;		}		public static function destroySingleton():void {			if (instantiated) _instance.destroy();		}		override public function destroy():void {			if (_instance) {				loader.removeEventListener(Event.COMPLETE, onCreateITunesSubscription);				loader.removeEventListener(Event.COMPLETE, onGetSubscriptionProducts);				TestSubscriptionErrorCode.destroySingleton();								super.destroy();								_instance = null;			}		}					public function getSubscriptionProducts():void{									/*				retrieve available subscription products from Speakaboos				these productIDs are subsequently passed to the iTunes store							method: getproducts						*/									log("getSubscriptionProducts");						var params:URLVariables = new URLVariables();			params.method = "getproducts";			params.format = "json";			log(params);						if(!urlRequest){				urlRequest = new URLRequest(getBaseURL(true));				urlRequest.method = "POST";				}						urlRequest.data = params;						loader.addEventListener(Event.COMPLETE, onGetSubscriptionProducts);			loader.load(urlRequest);					}						private function onGetSubscriptionProducts(e:Event):void{						/*				handlle response from Speakaboos server							method: getproducts			*/									log("onGetSubscriptionProducts");			loader.removeEventListener(Event.COMPLETE, onGetSubscriptionProducts);						var jsonString:String = loader.data;			var jsonData:Object = JSON.parse(jsonString);			log(jsonData);						if(responseOK(jsonData)){ 								log("got subscription products list");				log("products:");				log(jsonData.response.products);								var arrData:Array = jsonData.response.products as Array;				var len:int = arrData.length;								var vectProducts:Vector.<SpeakaboosSubscriptionProduct> = new Vector.<SpeakaboosSubscriptionProduct>;				if(len){					for(var i:int = 0; i < len; i++){											log("i: " + i);						var p:Object = arrData[i] as Object;						var isPromoted:Boolean = p.promoted;// as Boolean;						var thisProduct:SpeakaboosSubscriptionProduct = new SpeakaboosSubscriptionProduct(p.product_id, p.title, p.description, isPromoted);						vectProducts.push(thisProduct);					}				}				_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SPEAK_PRODUCT_IDS_LOADED, {data:vectProducts}));							}			else {				log("onGetSubscriptionProducts error");				_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SPEAK_PRODUCT_IDS_FAILED, {data:jsonData.response}));					}					}						public function createITunesSubscription(e:StoreKitEvent, userProfile:UserProfile):void{//, isSandbox:Boolean=true):void {  						/*				create iTunes Subscription on Speakaboos server				based on valid iTunes subscription							method: subscribe						*/						log("onCreateITunesSubscription called -> StoreKitEvent:");			log(e);			log("onCreateITunesSubscription transaction id: "+e.transactionId);			//TODO			/*				Dispose of the urlRequest object			*/						if(!urlRequest){				urlRequest = new URLRequest(getBaseURL(true));				urlRequest.method = "POST";				}									log("Contacting API server to verify payment. ");						var data:URLVariables = new URLVariables();			data.method  = 'subscribe';			//data.sandbox = isSandbox ? "1" : "0";			data.receipt = e.receipt;			data.product = e.productId;			data.transaction = e.transactionId;			if(AppConfig.isUnitTesting()){				data.customerror = TestSubscriptionErrorCode.getInstance().getTestErrorCode().toString();				TestSubscriptionErrorCode.destroySingleton();			}						//data.userid  = userProfile.user_id;			data.session = userProfile.session;						log("Subscribe request: ");			log(data);						urlRequest.data = data;			loader.addEventListener(Event.COMPLETE, onCreateITunesSubscription);			loader.load(urlRequest);					}							private function onCreateITunesSubscription(e:Event):void{						/*				handle response from Speakaboos server							method: subscribe			*/					//_tempDataStore = null;						log("onCreateITunesSubscription");			loader.removeEventListener(Event.COMPLETE, onCreateITunesSubscription);						var jsonString:String = loader.data;			var jsonData:Object = JSON.parse(jsonString);						log(jsonData);						if(responseOK(jsonData)){					log("subscription service: success");				_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SUBSCRIBE_SUCCEEDED, {messageData:jsonData}));					}			else {								log("subscription service: error");								var thisError:ErrorStruct = getErrorStructFromJsonData(jsonData);				var u:UserProfile = new UserProfile();				u.initWithData(jsonData);				var trans:String = ObjectUtils.getSafeParameter(jsonData.response, "transaction");				var retObj:Object = {userProfile: u, error:thisError, transaction:trans};				_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SUBSCRIBE_FAILED,{error:retObj}));								}					}						public function restoreITunesSubscription(userProfile:UserProfile, trans:ITunesTransaction):void{//, isSandbox:Boolean=true):void{			/*			create iTunes Subscription on Speakaboos server			based on valid iTunes subscription						method: subscribe						*/								//TODO			/*			Dispose of the urlRequest object			*/						if(!urlRequest){				urlRequest = new URLRequest(getBaseURL(true));				urlRequest.method = "POST";				}						log("Contacting API server to verify payment. ");			log("Restoring transaction ID: " + trans.transactionID + "product ID: " + trans.productID);						var data:URLVariables = new URLVariables();			data.method  = 'restore';			//data.sandbox = isSandbox ? "1" : "0";			data.receipt = trans.receipt;			//data.product = trans.productID;			data.transaction = trans.originalTransID;			data.spd = UniqueID.getUniqueIDHash();			data.session = userProfile.session;						log("Restore request: ");			log(data);						urlRequest.data = data;			loader.addEventListener(Event.COMPLETE, onRestoreITunesSubscription);			loader.load(urlRequest);				}				private function onRestoreITunesSubscription(e:Event):void{								loader.removeEventListener(Event.COMPLETE, onRestoreITunesSubscription);						log("onRestoreITunesSubscription");						var jsonString:String = loader.data;			var jsonData:Object = JSON.parse(jsonString);						log(jsonData);						if(responseOK(jsonData)){									log("restore service: success");				var userProfile:UserProfile = new UserProfile();				userProfile.initWithData(jsonData);				_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SUBSCRIBE_RESTORE_SUCCEEDED, {userProfile:userProfile}));					}			else {								log("restore service: error");				_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SUBSCRIBE_RESTORE_FAILED,{error:jsonData.response.error}));								}					}								override protected function onIOError(e:IOErrorEvent):void{			log("onLoginIOError: "+e.text);					}				override protected function onSecurityError(event:SecurityError):void{			log("onLoginSecurityError: "+event.message);					}							}}class SingletonEnforcer {	public function SingletonEnforcer():void {}}