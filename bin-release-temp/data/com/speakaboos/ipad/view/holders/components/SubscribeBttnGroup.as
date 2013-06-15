package com.speakaboos.ipad.view.holders.components
{
	import com.milkmangames.nativeextensions.ios.StoreKitProduct;
	import com.speakaboos.core.service.error.StoreKitServiceError;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	import com.speakaboos.ipad.events.SubscriptionEvents;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.models.data.MobileSubscriptions;
	import com.speakaboos.ipad.models.data.ModalsInfo;
	import com.speakaboos.ipad.models.data.product.ITunesSubscriptionProduct;
	import com.speakaboos.ipad.models.data.product.SpeakaboosSubscriptionProduct;
	import com.speakaboos.ipad.models.services.StoreKitService;
	import com.speakaboos.ipad.models.services.SubscriptionService;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.ipad.view.holders.components.SubscribeButton;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class SubscribeBttnGroup extends CoreMovieClipHolder
	{
		public var bttn_0:SubscribeButton;
		public var bttn_1:SubscribeButton;
		public var bttn_2:SubscribeButton;
		public var feedback_txt:TextField;
		
		private var _appController:AppController
		private var _products:MobileSubscriptions;
		private const BUTTON_NAME_DELIMITER:String = "_";
		private const SUBSCRIBE_BUTTON_BASE_NAME:String = "bttn";


		public function SubscribeBttnGroup(_view:MovieClip)
		{
			super(_view);
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("bttn_0", SubscribeButton, onSubscribeButtonClick),
				new HolderChildParams("bttn_1", SubscribeButton, onSubscribeButtonClick),
				new HolderChildParams("bttn_2", SubscribeButton, onSubscribeButtonClick),
				new HolderChildParams("feedback_txt")
			]));
		}
		
		/************************************************************************/
		/*
		initialization/destroy methods
		*/
		/************************************************************************/
		
		override public function onAddedToStage(e:Event = null):void{
			super.onAddedToStage(e);
			init();
		}
		
		override public function onRemovedFromStage(e:Event = null):void{
			super.onRemovedFromStage(e);
			
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_PRODUCT_DETAILS_LOADED, onITunesProductDetailsLoaded);
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_PRODUCT_DETAILS_FAILED, onITunesProductDetailsFailed);
			
			_eventDispatcher.removeEventListener(SubscriptionEvents.SPEAK_PRODUCT_IDS_LOADED, onSpeakProductIdsLoaded);
			_eventDispatcher.removeEventListener(SubscriptionEvents.SPEAK_PRODUCT_IDS_FAILED, onSpeakProductIdsFailed);
			
			
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_SUCCEEDED, onITunesSubscribeSucceeded);
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_FAILED, onITunesSubscribeFailed);
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_CANCELLED, onITunesSubscribeCancelled);
			
			destroy();
			
		}
		
		
		private function init():void{
			
			//TODO
			/*
			solve the bug that causes this to be called twice in a row.
			*/
			
//			initUI(StoreKitService.getInstance().isSupported());
			
			_appController = AppController.getInstance();
			displayFeedBackText(true, true);

			
			//add listeners
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_PRODUCT_DETAILS_LOADED, onITunesProductDetailsLoaded);
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_PRODUCT_DETAILS_FAILED, onITunesProductDetailsFailed);
			
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_SUCCEEDED, onITunesSubscribeSucceeded);
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_FAILED, onITunesSubscribeFailed);
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_CANCELLED, onITunesSubscribeCancelled);
			
			
			_eventDispatcher.addEventListener(SubscriptionEvents.SPEAK_PRODUCT_IDS_LOADED, onSpeakProductIdsLoaded);
			_eventDispatcher.addEventListener(SubscriptionEvents.SPEAK_PRODUCT_IDS_FAILED, onSpeakProductIdsFailed);
			
			
			showLoader();
			
			SubscriptionService.getInstance().getSubscriptionProducts();
			
		}
		
		private function displayFeedBackText(showText:Boolean = false, init:Boolean = false):void {
			var str:String = "";
			if (showText) {
				if (init) {
					str = "Loading the iTunes store.\nPlease wait a moment.";
				} else {
					str = "Sorry, we could not load the iTunes store.\nPlease try again later.";
				}
			}
			
			feedback_txt.text = str;
			var i:int = 0;
			var sb:SubscribeButton;
			do {
				sb = getHolderFromChild(SUBSCRIBE_BUTTON_BASE_NAME+BUTTON_NAME_DELIMITER+i) as SubscribeButton;
				if (sb) sb.visible = !showText;
				i++;
			} while (sb);
			
		}
		
		/************************************************************************/
		/*
		Button UI Callbacks
		*/
		/************************************************************************/
		private function onSubscribeButtonClick(btn:DisplayObject):void {
			var str:String = btn.name;					
			var arrName:Array = str.split(BUTTON_NAME_DELIMITER);
			var len:int = arrName.length;
			if(len > 1){
				if(arrName[0] === SUBSCRIBE_BUTTON_BASE_NAME){
					log("onButtonClick -> subscribing to iTunes ...");
					showLoader();
					var storeSvc:StoreKitService = StoreKitService.getInstance();
					//var btnSub:SubscribeButton = btn as SubscribeButton;
					var btnSub:SubscribeButton = getHolderFromChild(btn) as SubscribeButton;
					var prodID:String = btnSub.getProductID();
					storeSvc.createSubscription(_appController.getUserProfile(),prodID);
				}
			}
		}
		
		/************************************************************************/
		/*
		Helper functions
		*/
		/************************************************************************/
		
		private function extractProductIDs(vect:Vector.<SpeakaboosSubscriptionProduct>):Vector.<String>{
			var vectRet:Vector.<String> = new Vector.<String>();
			
			var len:uint = vect.length;
			for(var i:int = 0; i < len; i++){
				vectRet.push(vect[i].productID);
			}
			
			return vectRet;
			
		}
		
		private function test_buildSubscriptionButtons():void {
			var b:SubscribeButton = getHolderFromChild(SUBSCRIBE_BUTTON_BASE_NAME+BUTTON_NAME_DELIMITER+"0") as SubscribeButton;
			b.init("A", "1 Month", "4.99", "", false);
			b = getHolderFromChild(SUBSCRIBE_BUTTON_BASE_NAME+BUTTON_NAME_DELIMITER+"1") as SubscribeButton;
			b.init("A", "6 Month", "24.99", "15% off", false);
			b = getHolderFromChild(SUBSCRIBE_BUTTON_BASE_NAME+BUTTON_NAME_DELIMITER+"2") as SubscribeButton;
			b.init("A", "12 Month", "44.99", "35% off", true);
		}
		
		private function buildSubscriptionButtons():void {
			
			//var i:int = 0;
			log("creating product buttons");
			var len:uint = _products.speakaboosProducts.length;
			for(var i:int = 0; i < len; i++){
				
				var speakProduct:SpeakaboosSubscriptionProduct = _products.speakaboosProducts[i];
				log("SpeakProduct " +  i + ":");
				log("description" + speakProduct.description);
				
				var pID:String = speakProduct.productID;
				var iTunesProduct:ITunesSubscriptionProduct = _products.getITunesProduct(pID);
				if(!iTunesProduct)
					continue;
				
				log("creating button for product ID: " + pID);
				var b:SubscribeButton = getHolderFromChild(SUBSCRIBE_BUTTON_BASE_NAME+BUTTON_NAME_DELIMITER+i) as SubscribeButton;
				b.init(pID, speakProduct.title, iTunesProduct.price, speakProduct.description, speakProduct.isPromoted);
			}
		}
		
		/************************************************************************/
		/*
		iTunes CallBacks -- Product Details
		*/
		/************************************************************************/
		
		private function onITunesProductDetailsLoaded(e:GenericDataEvent):void{
			hideLoader();
			
			var _productList:Vector.<StoreKitProduct> = e.data.messageData;
			var i:int = 0;
			log("got product list: creating product buttons");
			if(!_products)
				_products = new MobileSubscriptions();
			
			for each(var p:StoreKitProduct in _productList){
				log("StoreKitProduct " +  (i+1) + ":");
				log(p);
				
				var iTunesProduct:ITunesSubscriptionProduct = new ITunesSubscriptionProduct(p.productId, p.title, p.description, p.price);
				_products.setITunesProduct(p.productId, iTunesProduct);
			}
			
			buildSubscriptionButtons();
			displayFeedBackText(false);

		}
		
		
		private function onITunesProductDetailsFailed(e:GenericDataEvent):void{
			
			hideLoader();
			// for testing button construction
//			test_buildSubscriptionButtons();
//			displayFeedBackText(false);
			
			log("failed to load iTunesProductDetails");
			displayFeedBackText(true);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ITUNES_FAILED_ID}));
			
		}
		
		/************************************************************************/
		/*
		iTunes Callbacks -- Single Transaction
		*/
		/************************************************************************/
		
		private function onITunesSubscribeSucceeded(e:*):void{
			log("onITunesSubscribeSucceeded");
			//StoreKitService.getInstance().createSpeakITunesSubscription(e.data.messageData,_appController.getUserProfile());
			SubscriptionService.getInstance().createITunesSubscription(e.data.messageData, _appController.getUserProfile());
		}
		
		
		
		private function onITunesSubscribeFailed(e:*):void{
			hideLoader();
			log("itunes subscription failed: " + e.data.messageData);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SUBSCRIPTION_FAILED_ID}));
			
		}
		
		private function onITunesSubscribeCancelled(e:*):void{
			log("transaction cancelled");
			hideLoader();
		}
		
		
		
		private function onSpeakProductIdsLoaded(e:*):void{
			hideLoader();
			if(!_products)
				_products = new MobileSubscriptions();
			
			
			//call the StoreKit service to get button store info
			log("init(): got Speakaboos product listing: ");
			log(e.data.data);
			
			var vectProducts:Vector.<SpeakaboosSubscriptionProduct> = e.data.data as Vector.<SpeakaboosSubscriptionProduct>;
			log(vectProducts);
			_products.speakaboosProducts = vectProducts;
			
			//var prodIDs:Vector.<String> = VectorUtil.toVectorOfStrings(arrProducts);
			var prodIDs:Vector.<String> = extractProductIDs(vectProducts);
			var skError:String = StoreKitService.getInstance().enable();
			if(skError == StoreKitServiceError.STOREKIT_ENABLED){
				showLoader();
				StoreKitService.getInstance().getProductDetails(prodIDs);
			}
			else{
				StoreKitService.getInstance().destroy();
				_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ITUNES_FAILED_ID}));
			}
			
		}
		
		
		
		
		private function onSpeakProductIdsFailed(e:*):void{
			log("onSpeakProductIdsFailed");
			hideLoader();
			displayFeedBackText(true);
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SUBSCRIPTION_PROD_FAILED_ID}));
		}
		
		
		
		override public function destroy():void{
			
			log("destroy");
			if(_products)
				_products.destroy();
			
			if(StoreKitService.instantiated){
				var sks:StoreKitService = StoreKitService.getInstance();
				sks.destroy();
				sks = null;
			}
			
			_products = null;
			
		}
		
		
	}
}