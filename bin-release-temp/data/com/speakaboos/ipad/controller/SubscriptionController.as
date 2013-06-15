package com.speakaboos.ipad.controller
{
	
	import com.adobe.utils.DictionaryUtil;
	import com.milkmangames.nativeextensions.ios.events.StoreKitEvent;
	import com.speakaboos.core.service.error.StoreKitServiceError;
	import com.speakaboos.ipad.CoreEventUser;
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	import com.speakaboos.ipad.events.SubscriptionEvents;
	import com.speakaboos.ipad.models.data.ModalsInfo;
	import com.speakaboos.ipad.models.data.UserProfile;
	import com.speakaboos.ipad.models.data.product.ITunesTransaction;
	import com.speakaboos.ipad.models.impl.UserProfileImpl;
	import com.speakaboos.ipad.models.services.StoreKitService;
	import com.speakaboos.ipad.models.services.SubscriptionService;
	
	import flash.utils.Dictionary;
	
	public class SubscriptionController extends CoreEventUser
	{
		
		private var _appController:AppController;
		//private var _restoredPurchases:Vector.<ITunesTransaction>;
		private var _dictRestoredPurchases:Dictionary;
		
		private var _numRestored:uint = 0;
		private var _numToRestore:uint = 0;
		//private var _expired:Boolean; //is subscription expired?
		
		public function SubscriptionController(appController:AppController)
		{
			_appController = appController;
			init();
		}
		
		private function init():void {
			_eventDispatcher.addEventListener(SubscriptionEvents.RESTORE_TRANSACTIONS, restoreTransactions);
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_TRANSACTIONS_RESTORED, onITunesTransactionsRestored);
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_TRANSACTION_RESTORE_SUCCEEDED, onITunesTransactionRestoreSucceeded);
			//_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_FAILED, onRestoreSpeakITunesPurchaseFailed);
			//_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_CANCELLED, onITunesTransactionCancelled);			
			_eventDispatcher.addEventListener(SubscriptionEvents.ITUNES_TRANSACTION_RESTORE_FAILED, onITunesTransactionRestoreFailed);
			_eventDispatcher.addEventListener(SubscriptionEvents.SUBSCRIBE_RESTORE_SUCCEEDED, onRestoreSpeakITunesPurchaseSucceeded);
			_eventDispatcher.addEventListener(SubscriptionEvents.SUBSCRIBE_RESTORE_FAILED, onRestoreSpeakITunesPurchaseFailed);
		}
		
		override public function destroy():void {
			log("destroy");
			_eventDispatcher.removeEventListener(SubscriptionEvents.RESTORE_TRANSACTIONS, restoreTransactions);
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_TRANSACTIONS_RESTORED, onITunesTransactionsRestored);
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_TRANSACTION_RESTORE_SUCCEEDED, onITunesTransactionRestoreSucceeded);
			//_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_FAILED, onRestoreSpeakITunesPurchaseFailed);
			//_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_SUBSCRIBE_CANCELLED, onITunesTransactionCancelled);			
			_eventDispatcher.removeEventListener(SubscriptionEvents.ITUNES_TRANSACTION_RESTORE_FAILED, onITunesTransactionRestoreFailed);
			_eventDispatcher.removeEventListener(SubscriptionEvents.SUBSCRIBE_RESTORE_SUCCEEDED, onRestoreSpeakITunesPurchaseSucceeded);
			_eventDispatcher.removeEventListener(SubscriptionEvents.SUBSCRIBE_RESTORE_FAILED, onRestoreSpeakITunesPurchaseFailed);
			clear();
			
			//_restoredPurchases = null;
			super.destroy();
		}		
		
		public function getDialogEventFromStatus(subState:String, storiesViewed:int):GenericDataEvent{
			
			/*
			Steps to take:
			
			
			1. Check subscription state
			2. If active, check to see if user is a RETURNING_USER or a FREE_TRIAL_USER
			3. If FREE_TRIAL_USER, present welcome dialog if no stories have been downloaded
			4. If RETURNING_USER (subscriber), do nothing
			5. If subscription is expired, present SUBSCRIPTION blocker
			
			*/
			
			var event:GenericDataEvent;
//			var msgHead:String;
//			var msgBody:String;
//			var buttons:Vector.<DialogButtonBase>;
//			var button:DialogButtonBase;
//			var defaultButton:DialogButtonBase;
			
			//var thisUser:UserProfile = _appController.getUserProfile();
			
			switch(subState){
				
				case UserProfileImpl.RETURNING_USER:
					//returning subscriber
					
					//var handle:String = _appController.getUserProfileImpl().getHandle();
			
					
					event = null;
					
					break;
				
		
				case UserProfileImpl.FREE_TRIAL_USER:
				 	//User has valid session and free trial subscription"
					//show number of days until free trial is over
					//and allow to continue free trial
					//var daysLeft:String = thisUser.days_left;
					//event = new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SIGNED_IN_EMAIL_ID});
//					log("free trial user.  Stories viewed: " + storiesViewed);
//					if(storiesViewed && storiesViewed >= 1){
//						log("storiesviewed >= 1");
//						event = null;
//					}
//					else{
//						log("storiesviewed: " + storiesViewed);
//						event = new GenericDataEvent(AppEvents.PLAY_WELCOME_VIDEO);
//					}
					
					event = null;
					
					break;
				/*
				case UserProfileImpl.NEW_TRIAL_NOT_USED:
					//User is new user without free trial
					//new user
					//allow to start free trial
					event = new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.WELCOME_ID, clearStack:true});
//					msgHead = "New User";
//					msgBody = "Congrats and welcome to your 30 day free trial.  We hope you enjoy all that Speakaboos has to offer.";
					
					break;
				*/
				case UserProfileImpl.NEW_TRIAL_USED:
					//User has already used free trial
					//show subscription dialog
					event = new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.TRIAL_OVER_ID});
					
					break;
				/*
				case UserProfileImpl.EXPIRED_TRIAL_USED:
					//expired subscriber
					//free trial used
					event = new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SUBSCRIBE_ID});
					break;
				
				case UserProfileImpl.EXPIRED_TRIAL_NOT_USED:
					
					// expired subscriber
					// who hasn't used free trial
					event = new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SUBSCRIBE_ID});
					break;
				*/
				
				case UserProfileImpl.EXPIRED_SUBSCRIBER:
					event = new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SUBSCRIPTION_EXPIRED_ID, clearStack:true});
					break;

				
				
		
				/*
				no dialog for the states below
				*/
				
				case UserProfileImpl.INVALID_SESSION:
					//invalid session
					
				default:
				 event  = null;
					
			}
			
			return event;
		}
		
		/************************************************************************/
		/*
		core logic
		*/
		/************************************************************************/
		
		
		public function restoreTransactions():void{
			
			var storeSvc:StoreKitService = StoreKitService.getInstance();
			if(StoreKitServiceError.STOREKIT_ENABLED != storeSvc.enable()){
				log("could not enable storekit service");
				storeSvc.destroy();
				storeSvc = null;
				_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ITUNES_FAILED_ID}));
				return;
			}
			
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_LOADER));	
			/*
			if(_restoredPurchases)
				_restoredPurchases.length = 0; //clear the vector
			else
				_restoredPurchases = new Vector.<ITunesTransaction>();
			*/
			
			if(!_dictRestoredPurchases){
				_dictRestoredPurchases = new Dictionary();
			}
			
			_numRestored = 0;
			storeSvc.restoreTransactions();
			
		}
		
		private function moreToRestore():Boolean{
			
			/*
			if(!(_restoredPurchases && _restoredPurchases.length))
				return false;
			*/
			
			return ((_numRestored < _numToRestore) && (DictionaryUtil.getKeys(_dictRestoredPurchases).length > 0));
				//return true;
			
			//return false;
		}
		
		/************************************************************************/
		/*
		iTunes Callbacks -- Restore Transactions
		*/
		/************************************************************************/
		
		
		private function onITunesTransactionRestoreSucceeded(e:GenericDataEvent):void{
			
			log("onITunesTransactionRestoreSucceeded");
			
			var ske:StoreKitEvent = e.data.messageData as StoreKitEvent;
			
			log("productID: " + ske.productId);
			log("original transID:" + ske.originalTransactionId);
			log("transactionID: " + ske.transactionId);
			//log("receipt: " + ske.transactionId);
			
			var iTunesTrans:ITunesTransaction = new ITunesTransaction(ske);
			var keyID:String = iTunesTrans.originalTransID;
			if(keyID == null || keyID  == "null"){
				log("**** original transID was null... ignoring this transaction ****");
				return;
			}
			
			if(_dictRestoredPurchases[keyID] == null){
				_dictRestoredPurchases[keyID] = Vector.<ITunesTransaction>([iTunesTrans]);
			}
			else{
				var vect:Vector.<ITunesTransaction> = _dictRestoredPurchases[keyID];
				vect.push(iTunesTrans);
			}
			//_restoredPurchases.push(iTunesTrans);
			
			//StoreKitService.getInstance().createSpeakITunesSubscription(e.data.messageData,_appController.getUserProfile());
		}
		
		private function onITunesTransactionCancelled(e:GenericDataEvent):void {
			log("onITunesTransactionCancelled");
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));	
		}
		
		private function onITunesTransactionRestoreFailed(e:GenericDataEvent):void{
			log("onITunesTransactionRestoreFailed");
			//_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));				
			onRestoreSpeakITunesPurchaseFailed(e);
		}
		
		
		private function onITunesTransactionsRestored(e:GenericDataEvent):void{
			/*
				StoreKit is done restoring transactions.  Now, send those transactions to the speakaboos server
			*/
			log("onITunesTransactionsRestored");
			destroyStoreKit();
			
			_numToRestore = DictionaryUtil.getKeys(_dictRestoredPurchases).length;
			if(_numToRestore > 0){
				//now, transmit the restored transactions to the server
				restoreSpeakITunesPurchases();
			}else{
				clear();
				_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));
				_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.RESTORE_PURCHASES_EMPTY_ID}));
			}
			
		}
		
		
		private function restoreSpeakITunesPurchases():void{
			
			//initialize the restore purchases process

			_numRestored = 0;
			
			//start the process
			doRestoreSpeakITunesPurchases();
			
		}
		
		
		private function doRestoreSpeakITunesPurchases():void{
			log("Transactions Restored: " + _numRestored);
			//if(moreToRestore()){
				
				var trans:ITunesTransaction;
				
				_numRestored++;
				for(var theKey:String in _dictRestoredPurchases){
					//get a single key/value pair from the dictionary and exit the loop
					
					trans = null;
					
					log("Restoring original transaction:" + theKey);
					var vect:Vector.<ITunesTransaction> = _dictRestoredPurchases[theKey];
					if(vect.length > 0){
						//trans = vect[vect.length-1];//grab the last one in the list (probably the most recent one)
						trans = getMostRecentTransaction(vect);
					}else{
						log("ITunesTransaction vector was empty");
					}
					
					vect.length = 0;
					vect = null;
					delete _dictRestoredPurchases[theKey];

					break; //exit the loop after a single iteration
					
				}
				
				if(trans){
					SubscriptionService.getInstance().restoreITunesSubscription(_appController.getUserProfile(), trans);
				}
				else{
					log("could not retrieve transaction from vector!!!");
					if(moreToRestore()){
						doRestoreSpeakITunesPurchases();
					}else{
						_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.SUBSCRIBE_RESTORE_FAILED,{error:"ITunesTransaction vector was empty"}));	
					}
				}	
			
		}
		
		
		private function onRestoreSpeakITunesPurchaseSucceeded(e:GenericDataEvent):void{
			log("**********************************");
			log("*** onRestoreSpeakITunesPurchaseSucceeded")
			log("**********************************");
			
			var userProfile:UserProfile = e.data.userProfile as UserProfile;
			_appController.setUserProfile(userProfile);
			_appController.saveUserToDB();
			
			if(moreToRestore())
			{doRestoreSpeakITunesPurchases();}
			else
			{restoreSpeakITunesPurchasesDone(userProfile);}
		}
		
		private function onRestoreSpeakITunesPurchaseFailed(e:GenericDataEvent):void{
			log("**********************************");
			log("*** onRestoreSpeakITunesPurchaseFailed");
			log("**********************************");
			
			clear();
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ERROR_RESTORE_PURCHASES_ID}));
			
			//if(moreToRestore())
			//	doRestoreSpeakITunesPurchases();
			//else
			//	restoreSpeakITunesPurchasesDone();
			
		}
		
		
		private function restoreSpeakITunesPurchasesDone(u:UserProfile):void{
			
			log("**********************************");
			log("*** restoreSpeakITunesPurchasesDone");
			log("**********************************");
			//remove listeners
			
			clear();
			//remove loader
			//_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));	
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_ALL_MODALS));
			
			if(_appController.subscriptionHasExpired()){
				_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SUBSCRIPTION_EXPIRED_ID, clearStack:true}));
			}
			else{
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.RESTORE_PURCHASES_SUCCEEDED_ID}));

			}
			
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.USER_DATA_UPDATED));
			
			
		}
		
		final private function getMostRecentTransaction(vect:Vector.<ITunesTransaction>):ITunesTransaction{
			//extract the transaction with the highest transactionID
			//return null if none is found
			
			var lastTrans:ITunesTransaction;
			var lastID:String = "";
			var len:int = vect.length;
			if(len > 0){
				for(var i:int = 0; i < len; i++){
					if(lastID < vect[i].transactionID){
						lastID = vect[i].transactionID;
						lastTrans = vect[i];
					}
				}
			}
			
			return lastTrans;
		
		}
		
		private function clear():void{
		
			//clear the vector
			/*
			if(_restoredPurchases){
				_restoredPurchases.length = 0;
			}
			
			_restoredPurchases = null;
			*/
			_numRestored = 0;
			_numToRestore = 0;
			
			if(_dictRestoredPurchases){
				for(var thisKey:String in _dictRestoredPurchases){
					var vect:Vector.<ITunesTransaction> = _dictRestoredPurchases[thisKey];
					vect.length = 0;
					vect = null;
					delete _dictRestoredPurchases[thisKey];
				}
			}
			
			_dictRestoredPurchases = null;
			
			destroyStoreKit();
			
		}
		
		
		final private function destroyStoreKit():void{
			if(StoreKitService.instantiated){
				StoreKitService.getInstance().destroy();
			}
		}
		
		final private function restoreDone():void{
			subscribeDone();
		}
		
		final private function subscribeDone():void{
			clear();
		}
		
		
		
		private function closeModal():void {
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_MODAL));
		}
		
	}
}