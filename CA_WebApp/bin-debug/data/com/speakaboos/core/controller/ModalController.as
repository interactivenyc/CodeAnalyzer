package com.speakaboos.core.controller
{
	import com.speakaboos.core.events.AppEvents;
	import com.speakaboos.core.events.CoreEventDispatcher;
	import com.speakaboos.core.events.GenericDataEvent;
	import com.speakaboos.core.events.LoginEvents;
	import com.speakaboos.core.events.ModalEvents;
	import com.speakaboos.core.events.NavEvents;
	import com.speakaboos.core.events.SubscriptionEvents;
	import com.speakaboos.core.models.data.ModalData;
	import com.speakaboos.core.models.data.ModalsInfo;
	import com.speakaboos.core.models.data.TextEntryInfo;
	import com.speakaboos.core.models.data.UserProfile;
	import com.speakaboos.core.models.impl.UserProfileImpl;
	import com.speakaboos.core.models.services.LoginService;
	import com.speakaboos.core.models.services.SpeakaboosService;
	import com.speakaboos.core.settings.AppConfig;
	import com.speakaboos.core.utils.TextUtil;
	import com.speakaboos.core.utils.SocialUtils;
	import com.speakaboos.core.utils.Validation;
	import com.speakaboos.core.view.holders.components.AnxEventSender;
	import com.speakaboos.core.view.holders.components.LabeledTextEntry;
	import com.speakaboos.core.view.holders.components.TextFieldScroller;
	import com.speakaboos.core.view.holders.modals.ModalDialog;
	import com.speakaboos.story.events.AnalyticsEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ModalController extends AnxEventSender
	{
		private var _appController:AppController;
		//This is public so that CoreModals can check to 
		//see if they're currently at the top level
		private var _modalStack:Vector.<Object>;
		
		private var _curModals: Vector.<ModalDialog>;
		private var _curModalLookup: Vector.<Class>;
		private var _containers: Vector.<MovieClip>;
		private const _MAIN_MODAL_INDEX:int = 0;
		private const _MESSAGE_MODAL_INDEX:int = 1;
		private const _LOADER_INDEX:int = 2;
		private const _DEBUG_LOG_INDEX:int = 3;
		private static var _logString:String;
		// vars for testing modals
		private var _mainModal:ModalDialog;
		private var _messageModal:ModalDialog;
		private var _debugArray:Array;
		private var _modal:ModalDialog;
		
		
		// set up log window to use large background of new dialogs... maybe it is another slot in array, or just above the other modals...
		// also spinner for loader...
		private static const MAX_LOG_STRING:int = 80000;
		private var _modalOpening:Boolean;

		private var _testField:TextField;

		private var _testModalIndex:int;
		private var _modalIdPendingAgeVerify:String;
		private var _ageGatePassed:Boolean = false;
		
		public function ModalController(controller:AppController)
		{
			super(new MovieClip());
			_appController = controller;
			init();
		}
		
		private function init():void {
			log("init");
			_logString = "";
			_curModalLookup = new <Class>[ModalsInfo.MAIN_MODAL_TYPE, ModalsInfo.MESSAGE_MODAL_TYPE, ModalsInfo.LOADER_TYPE, ModalsInfo.DEBUG_LOG_TYPE];
			_curModalLookup.fixed = true;
			var i:int, n:int = _curModalLookup.length;
			_curModals = new Vector.<ModalDialog>(n, true);
			_containers = new Vector.<MovieClip>(n, true);
			var cont:MovieClip;
			for (i=0; i<n; i++) {
				cont = new MovieClip();
				mc.addChild(cont);
				_containers[i] = cont;
			}
			_modalOpening = false;
			_modalStack = new Vector.<Object>();
		}
		
		override public function onAddedToStage(e:Event=null):void {
			addEventListeners();
		}
		
		override public function onRemovedFromStage(e:Event=null):void {
			removeEventListeners();
		}
		
		private function addEventListeners():void {
			log("addEventListeners " + stage);
			//			flash.debugger.enterDebugger();
			_eventDispatcher.addEventListener(ModalEvents.OPEN_EXTERNAL_URL, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.OPEN_MAIL_DOC, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.SHOW_LOG, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.SHOW_LOADER, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.HIDE_LOADER, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.SHOW_MODAL, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.CLOSE_MODAL, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.CLOSE_ALL_MODALS, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.CLOSE_MESSAGE_MODALS, receiveEvent);
			_eventDispatcher.addEventListener(ModalEvents.MODAL_BTTN_CLICKED, modalBttnClicked);
		}
		
		private function removeEventListeners():void {
			log("removeEventListeners");
			_eventDispatcher.removeEventListener(ModalEvents.OPEN_EXTERNAL_URL, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.OPEN_MAIL_DOC, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.SHOW_LOG, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.SHOW_LOADER, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.HIDE_LOADER, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.SHOW_MODAL, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.CLOSE_MODAL, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.CLOSE_ALL_MODALS, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.CLOSE_MESSAGE_MODALS, receiveEvent);
			_eventDispatcher.removeEventListener(ModalEvents.MODAL_BTTN_CLICKED, modalBttnClicked);
		}
		
		/*********************************************************************
		 * EVENT HANDLING
		 *********************************************************************/
		
		private function receiveEvent(e:GenericDataEvent):void{
			log("* receiveEvent type:"+e.type);
			//			log(new Date());
			
			switch(e.type){
				case ModalEvents.SHOW_MODAL:
					showModalById(e.data);
					break;
				case ModalEvents.CLOSE_MODAL:
					closeTopModal();
					break;
				case ModalEvents.SHOW_LOADER:
//					flash.debugger.enterDebugger();
					showLoaderMC();
					break;
				case ModalEvents.HIDE_LOADER:
					hideLoaderMC();
					break;
				case ModalEvents.CLOSE_ALL_MODALS:
					closeAllModals();
					break;
				case ModalEvents.CLOSE_MESSAGE_MODALS:
					closeModalByIndex(_MESSAGE_MODAL_INDEX);
					break;
				case ModalEvents.BACK_PREV_MODAL:
					backToPrevModal(e.data.clearStack, 
						(typeof(e.data.clearTop) === "boolean") ? e.data.clearTop : true
					);
					break;
				case ModalEvents.SHOW_LOG:
					showModalById({id:ModalsInfo.DEBUG_LOG_ID});
					
					// MODAL TESTING
					//					showModalById({id:ModalsInfo.SIGN_IN_ID});
					
					break;
				case ModalEvents.OPEN_EXTERNAL_URL:
					SocialUtils.openExternalUrl(e.data.link);
					break;
				case ModalEvents.OPEN_MAIL_DOC:
					SocialUtils.openMailDoc(e.data);
					break;
				case NavEvents.GO_HOME:
					closeAllModals();
					break;
				default: // assumes a show modal event:
					log("receiveEvent type not handled "+e.type);
					
			}
			
			log("receiveEvent done:"+e.type);
		}
		
		private function getAnxId(id:String):String {
			var result:String = id.toLowerCase();
			var spltAry:Array = result.split("_");
			if (spltAry[spltAry.length - 1] === "id") spltAry.pop();
			if (spltAry[0] === "bttn") spltAry.shift();
			if (spltAry[spltAry.length - 1] === "bttn") spltAry.pop();
			if (spltAry[spltAry.length - 1] === "verify") spltAry.pop();
			result = spltAry.join("-");
			return result;
		}
		
		private function handleTextInFocus(e:GenericDataEvent):void {
			var textFieldName:String;
			if (e.data.obj && e.data.obj.parentHolder) {
				var te:LabeledTextEntry = e.data.obj.parentHolder as LabeledTextEntry;
				if (te) {
					textFieldName = te.type;
					if (textFieldName === TextEntryInfo.EMAIL_TYPE) {
						var labelText:String = te.label.text.split(" ")[0].toLowerCase();
						if (labelText === "verify") {
							textFieldName = labelText+"-"+textFieldName;
						}
					}
					textFieldName = "text-field_"+textFieldName;
				}
			}
			CONFIG::DEBUG {
				trace("[ ModalController ] handleTextInFocus(e) "+ textFieldName);
			}
			sendAnxModalData(null, AnalyticsEvent.EVENT_ACTION_TAP, textFieldName);
		}
		
		public function sendAnxModalData( modalId:String, eventAction:String = "",eventLabel:String = ""):void {
			var m:ModalDialog;
			if (!modalId) { // assume current open modal
				m = topModal();
				if (m) modalId = m.id;
			}
			if (modalId 
				&& modalId !== ModalsInfo.LOADER_ID
				&& modalId !== ModalsInfo.DEBUG_LOG_ID
				&& modalId !== ModalsInfo.ERROR_KYOWON_AUTH_ID
			) {
				var info:ModalData = ModalsInfo.getModalData(modalId);
				if (eventAction === AnalyticsEvent.EVENT_ACTION_TAP) {
					eventLabel = getAnxId(eventLabel);
				} 
				_eventScreen = [];
				var mainModalId:String;
				if (info.type === ModalsInfo.MESSAGE_MODAL_TYPE) {
					_eventCat = AnalyticsEvent.EVENT_CATEGORY_MODALS;
					m = _curModals[_MAIN_MODAL_INDEX];
					if (m) mainModalId = m.id;
					_eventScreen.push(AnalyticsEvent.EVENT_SCREEN_MODAL);
				} else {
					_eventCat = AnalyticsEvent.EVENT_CATEGORY_SETTINGS;
					mainModalId = modalId;
				}
				switch (mainModalId) {
					case ModalsInfo.SUBSCRIPTION_EXPIRED_ID:
					case ModalsInfo.TRIAL_OVER_ID:
					case ModalsInfo.WELCOME_ID:
					case ModalsInfo.TRIALING_USER_ID:
					case ModalsInfo.FULL_SUBSCRIPTION:
					case ModalsInfo.IPAD_SUBSCRIPTION:
					case ModalsInfo.SIGN_IN_ID:
						_eventScreen.unshift(AnalyticsEvent.EVENT_SCREEN_SETTINGS);
						break;
					case ModalsInfo.MANAGE_ACCOUNT_IPAD_SUBSCRIPTION_ID:
					case ModalsInfo.MANAGE_ACCOUNT_FULL_SUBSCRIPTION_ID:
					case ModalsInfo.MANAGE_ACCOUNT_SUBSCRIPTION_EXPIRED_ID:
						_eventScreen.unshift(AnalyticsEvent.EVENT_SCREEN_MANAGE_ACCOUNT);
						break;
					case ModalsInfo.TRIAL_EXPIRED_ID:
					case ModalsInfo.SUBSCRIPTION_EXPIRED_ID:
					case ModalsInfo.SUBSCRIPTION_RENEW_ID:
						_eventScreen.unshift(AnalyticsEvent.EVENT_SCREEN_SUBSCRIBE);
						break;
					default:
				}
				if (modalId === ModalsInfo.SUBSCRIPTION_EXPIRED_ID
					|| modalId === ModalsInfo.MANAGE_ACCOUNT_SUBSCRIPTION_EXPIRED_ID) {
					var subType:String = "FULL";
					var profile:UserProfileImpl = UserProfileImpl.getInstance();
					if (profile.isITunesSubscriber() && !profile.hasEmail()) {
						subType = "IPAD";
					}
					modalId = subType +"_"+ modalId;
				}
				
				_eventScreen.push(getAnxId(modalId));
				sendAnxData(eventAction, eventLabel);
			}
		}
		
		private function modalBttnClicked(e:GenericDataEvent):void { 
			var bttnId:String = e.data.bttn_id;
			var modalId:String = e.data.modal_id;
			sendAnxModalData(modalId, AnalyticsEvent.EVENT_ACTION_TAP, bttnId);
			log( "*** modalBttnClicked bttnId='"+bttnId+"', modalId='"+modalId+"'");
			switch (bttnId) {
				case ModalsInfo.SIGN_OUT_BTTN_ID:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.LOGOUT_USER));
					break;
				case ModalsInfo.RESTORE_PURCHASES_BTTN_ID:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(SubscriptionEvents.RESTORE_TRANSACTIONS));
					break;
				case ModalsInfo.CONTACT_SALES_ID:
					SocialUtils.openMailDoc({email:"sales@speakaboos.com"});
					break;
				case ModalsInfo.CONTACT_BILLING_ID:
					SocialUtils.openMailDoc({email:"billing@speakaboos.com"});
					break;
				case ModalsInfo.CONTACT_SUPPORT_ID:
					SocialUtils.openMailDoc({email:"ipad.support@speakaboos.com"});
					break;
				case ModalsInfo.CONTACT_GENERAL_ID:
					SocialUtils.openMailDoc({email:"feedback@speakaboos.com"});
					break;
				case ModalsInfo.CONTACT_PRESS_ID:
					SocialUtils.openMailDoc({email:"press@speakaboos.com"});
					break;
				case ModalsInfo.CONTACT_PARTNERS_ID:
					SocialUtils.openMailDoc({email:"partners@speakaboos.com"});
					break;
				case ModalsInfo.CONTACT_JOBS_ID:
					SocialUtils.openMailDoc({email:"jobs@speakaboos.com"});
					break;
				//				case ModalsInfo.SHARE_GOOGLEPLUS_ID:
				//					SocialUtils.openExternalUrl("TBD");
				//					break;
				case ModalsInfo.SHARE_INSTAGRAM_ID:
					SocialUtils.openExternalUrl("http://instagram.com/speakaboos");
					break;
				case ModalsInfo.SHARE_FACEBOOK_ID:
					SocialUtils.openExternalUrl("http://www.facebook.com/speakaboos");
//					SocialUtils.openExternalUrl("fb://profile/47473197424", "http://www.facebook.com/speakaboos");
					//id:563605759
					break;
				case ModalsInfo.SHARE_SPEAKABOOS_ID:
					SocialUtils.openExternalUrl("http://www.speakaboos.com");
					break;
				case ModalsInfo.SHARE_PINTEREST_ID:
					SocialUtils.openExternalUrl("http://pinterest.com/speakaboos");
					break;
				case ModalsInfo.SHARE_YOUTUBE_ID:
					SocialUtils.openExternalUrl("http://www.youtube.com/speakaboos");
					break;
				case ModalsInfo.SHARE_TWITTER_ID:
					SocialUtils.openExternalUrl("https://twitter.com/speakaboos");
//					SocialUtils.openExternalUrl("twitter://user?screen_name=speakaboos", "https://twitter.com/speakaboos");
					break;
				case ModalsInfo.MORE_HELP_BTTN_ID:
					SocialUtils.openExternalUrl("http://help.speakaboos.com");
					break;
				case ModalsInfo.REPLAY_WELCOME_VIDEO_ID:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.PLAY_WELCOME_VIDEO));
					break;
				case ModalsInfo.REMOVE_ALL_STORIES_ID:
				case ModalsInfo.MANAGE_STORIES_ID:
					if (SpeakaboosService.getInstance().savedStoryCount > 0) {
						showModalById({id: bttnId});
					} else {
						showModalById({id: ModalsInfo.NO_STORIES_SAVED_ID});
					}
					break;
				case ModalsInfo.KEEP_IN_TOUCH_ID:
				case ModalsInfo.REMOVE_STORY_ID:
				case ModalsInfo.ABOUT_ID:
				case ModalsInfo.HELP_FAQ_ID:
				case ModalsInfo.CONTACT_ID:
				case ModalsInfo.TERMS_ID:
				case ModalsInfo.PRIVACY_ID:
				case ModalsInfo.TRIAL_EXPIRED_ID:
				case ModalsInfo.SUBSCRIPTION_RENEW_ID:
				case ModalsInfo.COMPLETE_ACCOUNT_ID:
				case ModalsInfo.MANAGE_ACCOUNT_IPAD_SUBSCRIPTION_ID:
				case ModalsInfo.MANAGE_ACCOUNT_FULL_SUBSCRIPTION_ID:
				case ModalsInfo.MANAGE_ACCOUNT_SUBSCRIPTION_EXPIRED_ID:
				case ModalsInfo.PASSWORD_RESET_ID:
				case ModalsInfo.NO_MATCHING_EMAIL_ID:
				case ModalsInfo.EMAIL_PASSWORD_INCORRECT_ID:
				case ModalsInfo.BAD_SIGN_UP_ID:
				case ModalsInfo.MISSMATCHED_EMAIL_ID:
				case ModalsInfo.USED_EMAIL_ID:
				case ModalsInfo.SIGN_IN_ID:
					showModalById({id: bttnId});
					break;
				case ModalsInfo.JOIN_BTTN_ID:
					showModalById({id: ModalsInfo.TRIAL_EXPIRED_ID});
					break;
				case ModalsInfo.SIGN_IN_VERIFY_ID: 
					log("** SIGN_IN_VERIFY_ID");
					showModalById({id: ModalsInfo.SIGN_IN_ID});
					break;
				case ModalsInfo.JOIN_VERIFY_ID:
					log("** JOIN_VERIFY_ID");
					showModalById({id: ModalsInfo.TRIAL_EXPIRED_ID});
					break;
				case ModalsInfo.FORGOT_PASSWORD_BTTN_ID:
					showModalById({id: ModalsInfo.FORGOT_PASSWORD_ID});
					break;
				case ModalsInfo.ALREADY_SUBSCRIBED_BTTN_ID:
					showModalById({id: ModalsInfo.SIGN_IN_ID});
					break;
				case ModalsInfo.DEBUG_BTTN_ID:
					_appController.enterDebugger();
					break;
				case ModalsInfo.CLEAR_BTTN_ID:
					clearLog();
					break;
				case ModalsInfo.HOME_BTTN_ID:
					_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.FULL_RESET));
					break;
					case ModalsInfo.TEST_MODALS_BTTN_ID:
				CONFIG::DEBUG {
					testModals();
				}
					break;
				case ModalsInfo.TOGGLE_FRAMERATE_BTTN_ID:
					CONFIG::DEBUG {
					mc.stage.frameRate = (mc.stage.frameRate > 24) ? 24 : 120;
					closeAllModals();
				}
					break;
				case ModalsInfo.OK_BTTN_ID:
					switch (modalId) {
						case ModalsInfo.SIGN_IN_ID:
							signIn(e.data.modal);
							break;
						case ModalsInfo.COMPLETE_ACCOUNT_ID:
							//signUp(e.data.modal);
							completeAccount(e.data.modal);
							break;
						case ModalsInfo.REMOVE_ALL_STORIES_ID:
							_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.DELETE_ALL_STORIES_CLICKED));
							break;
						case ModalsInfo.REMOVE_STORY_ID:
							_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.DELETE_STORY_CLICKED));
							break;
						case ModalsInfo.SUBSCRIPTION_EXPIRED_BLOCKER_ID:
							showModalById({id: ModalsInfo.SUBSCRIPTION_RENEW_ID});
							break;
						case ModalsInfo.TRIAL_OVER_BLOCKER_ID:
							showModalById({id: ModalsInfo.TRIAL_EXPIRED_ID});
							break;
						case ModalsInfo.FORGOT_PASSWORD_ID:
							forgotPassword(e.data.modal);
							break;
						case ModalsInfo.PARENTAL_AGE_GATE_ID:
							log("PARENTAL_AGE_GATE_ID");
							//forgotPassword(e.data.modal);
							verifyAge(e.data.modal);
							break;
						
						case ModalsInfo.LOADER_ID:
							log("close the loader? "+AppConfig.DEBUG_MODE);
							if (AppConfig.DEBUG_MODE) closeModalById(modalId);
							break;
						case ModalsInfo.PASSWORD_RESET_ID:
							closeAllModals();
							break;
						case ModalsInfo.ERROR_STORY_LOAD_ID:
						case ModalsInfo.NEED_CONNECTION_ID:
						case ModalsInfo.NETWORK_ERROR_ID:
							closeModalById(modalId);
							if (AppController.viewMode === AppController.MODE_STORY) {
								CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(AppEvents.SHOW_HOME_SCREEN));
							}
							break;
						case ModalsInfo.ERROR_KYOWON_AUTH_ID:
							CONFIG::KYOWON {
								//Quit app entirely when authorization fails
								NativeApplication.nativeApplication.exit();
								//StartupController.appFinishAndroid();
							}
						break;
							
						case ModalsInfo.FACEBOOK_FAILED_ID:
					//TODO: FB logout
								
						default:
							closeModalById(modalId);
					}
					break;
				
				case ModalsInfo.BACK_BTTN_ID:
					backToPrevModal();
					break;
				case ModalsInfo.CLOSE_BTTN_ID:
					closeModalById(modalId, true);
					break;
				case ModalsInfo.CANCEL_BTTN_ID:
					closeModalById(modalId);
					break;
				case ModalsInfo.ALL_SET_ID:
				case ModalsInfo.GET_STARTED_BTTN_ID:
				default:
					closeModalById(modalId);
					break;
			}
			dispatchClosedAllModals();
		}
		
		
		/*********************************************************************
		 * AGE GATE FUNCTIONS
		 *********************************************************************/
		
		final private function verifyAge(modal:ModalDialog):void{
			log("** verifyAge");
			var entryList:Array = modal.getData() as Array;
			if(entryList && entryList.length && _modalIdPendingAgeVerify){
				var birthYear:int = int(entryList[0]);
				var id:String = _modalIdPendingAgeVerify;
				_modalIdPendingAgeVerify = null;
				if (Validation.isValidBirthDate(birthYear,1,1)  && Validation.isOldEnough(birthYear, 14)) {
					_ageGatePassed = true;
					showModalById( {id:id, closeOpen:true});
				} else {
					closeAllModals();
				}
			}
		}
		
		final private function filterId(id):String { // currently only changes PREFERENCES_ID, but could be used for others down the road
			_appController.appStateUpdated();
			var modalId:String = id;
			if (modalId === ModalsInfo.PREFERENCES_ID) {
				CONFIG::KYOWON {
					modalId = ModalsInfo.MANAGE_STORIES_ID;
				}
					CONFIG::NOTKYOWON {
						var profile:UserProfileImpl = UserProfileImpl.getInstance();
						
						// these are the modal IDs for the 4 prefs states from left to right in Stephen's onboarding-screens.pdf
						//TRIALING_USER_ID TRIAL_OVER_ID FULL_SUBSCRIPTION IPAD_SUBSCRIPTION
						//TODO: set modalId properly based on user state
						//	var modalId:String = ModalsInfo.TRIAL_EXPIRED_ID;
						// = ModalsInfo.FULL_SUBSCRIPTION;
						
						if (UserProfileImpl.getInstance().subscriptionHasExpired()) {
							modalId = ModalsInfo.SUBSCRIPTION_EXPIRED_ID;
						} else if (profile.isSpeakaboosSubscriber()) {
							modalId = ModalsInfo.FULL_SUBSCRIPTION;
						} else if (profile.isITunesSubscriber()) {
							if (profile.hasEmail()) {
								modalId = ModalsInfo.FULL_SUBSCRIPTION;
							} else {
								modalId = ModalsInfo.IPAD_SUBSCRIPTION;
							} 
						} else if (profile.trialIsOver()) {
							modalId = ModalsInfo.TRIAL_OVER_ID;
						} else {
							modalId = ModalsInfo.TRIALING_USER_ID;
						}
						CONFIG::SIGNED_IN {
							if (profile.hasEmail()) {
								modalId = ModalsInfo.FULL_SUBSCRIPTION;
							} else {
								modalId = ModalsInfo.IPAD_SUBSCRIPTION;
							} 
						}
					} // end CONFIG::NOTKYOWON
			}
			if (!_ageGatePassed) {
				switch (modalId) {
					case ModalsInfo.SUBSCRIPTION_RENEW_ID:
					case ModalsInfo.SIGN_IN_ID:
					case ModalsInfo.TRIAL_EXPIRED_ID:
					case ModalsInfo.FULL_SUBSCRIPTION:
					case ModalsInfo.IPAD_SUBSCRIPTION:
					case ModalsInfo.SUBSCRIPTION_EXPIRED_ID:
					case ModalsInfo.TRIAL_OVER_ID:
					case ModalsInfo.TRIALING_USER_ID:
						_modalIdPendingAgeVerify = modalId;
						modalId = ModalsInfo.PARENTAL_AGE_GATE_ID;
				}
			}
			return modalId;
		}
		
		/*********************************************************************
		 * SPECIFIC MODAL GLUE
		 *********************************************************************/
		
		private function signIn(modal:ModalDialog):void {

			var entryList:Array = modal.getData() as Array;
			
			if(Validation.isPopulated(entryList[0]) && Validation.isPopulated(entryList[1])){
				var userProfile:UserProfile = new UserProfile();
				userProfile.email = entryList[0];
				userProfile.password = entryList[1];
				_appController._loginController.logIn(userProfile);
				//TODO: Use an event rather than appController.logIn()
				//_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.LOGIN, {userProfile:userProfile}));
			} else {
				//showModalById({id:ModalsInfo.ERROR_EMAIL_FORMAT_ID});
				showModalById({id:ModalsInfo.EMAIL_PASSWORD_INCORRECT_ID});
				
			}
		}
		
		private function signUp(modal:ModalDialog):void {
			//TODO: check email format and if pw is not empty before sending event
			var entryList:Array = modal.getData() as Array;
			var email0:String = TextUtil.trim(entryList[0]);
			var email1:String = TextUtil.trim(entryList[1]);
			if (email0 == email1) {
				if (Validation.isValidEmailEx(email0)) {
					var userProfile:UserProfile = new UserProfile();
					userProfile.email = email0;
					userProfile.password = entryList[2];
					_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.SIGNUP, {userProfile:userProfile}));
				} else {
					showModalById({id:ModalsInfo.ERROR_EMAIL_FORMAT_ID});
				}
			} else {
				showModalById({id:ModalsInfo.MISSMATCHED_EMAIL_ID});
			}
		}
		
		private function completeAccount(modal:ModalDialog):void {
			//TODO: check email format and if pw is not empty before sending event
			var entryList:Array = modal.getData() as Array;
			var email0:String = TextUtil.trim(entryList[0]);
			var email1:String = TextUtil.trim(entryList[1]);
			var pw:String = TextUtil.trim(entryList[2]);
			if (email0 == email1) {
				if (Validation.isValidEmailEx(email0)) {
					if(Validation.isValidPassword(pw)){
						//var userProfile:UserProfile = new UserProfile();
						//userProfile.email = email0;
						//userProfile.password = entryList[2];
						//_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.SIGNUP, {userProfile:userProfile}));
						_appController._loginController.completeAccount(email0, pw);
					}
					else{
						showModalById({id:ModalsInfo.ERROR_PASSWORD_FORMAT_ID});
					}
				} else {
					showModalById({id:ModalsInfo.ERROR_EMAIL_FORMAT_ID});
				}
			} else {
				showModalById({id:ModalsInfo.MISSMATCHED_EMAIL_ID});
			}
		}
		
		final private function forgotPassword(modal:ModalDialog):void{
			var entryList:Array = modal.getData() as Array;
//			flash.debugger.enterDebugger();
			if(entryList && entryList.length){
				var strEmail:String = entryList[0] as String;
				if(Validation.isValidEmailEx(strEmail)){
					showLoaderMC();
					LoginService.getInstance(); // make sure this exists to listen
					_eventDispatcher.dispatchEvent(new GenericDataEvent(LoginEvents.FORGOT_PASSWORD, {email:strEmail}));
				}else{
					showModalById({id:ModalsInfo.ERROR_EMAIL_FORMAT_ID});
				}
			}
			
			
		
		}
		
		
		/*********************************************************************
		 * for reviewing the modals for copy/ layout
		 *********************************************************************/
		CONFIG::DEBUG {
		private function testModals():void {
			//			stage.addEventListener(MouseEvent.MOUSE_DOWN,function(e:MouseEvent):void{log("mouse down "+e.target+", "+e.target.name)});
//			_eventDispatcher.removeEventListener(ModalEvents.MODAL_BTTN_CLICKED, modalBttnClicked);
//			_eventDispatcher.addEventListener(ModalEvents.MODAL_BTTN_CLICKED, nextTestModal);
			_debugArray = [];
			var data:Object = ModalsInfo.data;
			for (var nm:String in data) {
				if (nm !== ModalsInfo.LOADER_ID && nm !== ModalsInfo.DEBUG_LOG_ID) _debugArray.push(nm);
			}
			if (!_testField) {
				_testField = new TextField();
				_testField.background = true;
//				_testField.autoSize = "left";
				_testField.width = Math.floor( 0.23 * stage.fullScreenWidth);
				_testField.height = Math.floor( 0.04 * stage.fullScreenWidth);
				_testField.defaultTextFormat = new TextFormat(null, 0.015 * stage.fullScreenWidth);
			}
			_testField.addEventListener(MouseEvent.CLICK, nextTestModal);
			_testModalIndex = 0;
			stage.addChild(_testField);
			log("modal test");
			log(_debugArray);
			//			_mainModal = new ModalDialog(ModalsInfo.MAIN_MODAL_TYPE);
			//			_messageModal = new ModalDialog(ModalsInfo.MESSAGE_MODAL_TYPE);
			nextTestModal();
		}
		private function nextTestModal(e:MouseEvent = null):void {
			closeAllModals();
			_testModalIndex += (e && stage.mouseX < (_testField.width / 2.5)) ? -1 : 1;
			if (_testModalIndex >= 0 && _testModalIndex < _debugArray.length) {
				var nm:String = _debugArray[_testModalIndex];
				_testField.text = nm;
				_ageGatePassed = true;
				showModalById({id:nm});
			} else {
				cleanupTestModals();
			}
		}
		private function cleanupTestModals():void {
			if (_testField && _testField.hasEventListener(MouseEvent.CLICK)) {
				_testField.removeEventListener(MouseEvent.CLICK, nextTestModal);
				
				stage.removeChild(_testField);
				//				_eventDispatcher.removeEventListener(ModalEvents.MODAL_BTTN_CLICKED, nextTestModal);
				//				_eventDispatcher.addEventListener(ModalEvents.MODAL_BTTN_CLICKED, modalBttnClicked);
			}
		}
		}
		
		/*********************************************************************
		 * MODAL DISPLAY
		 *********************************************************************/

		final private function showModalById(params:Object):void {
			log("******************************************");
			log ("*** showModalById: "+params.id+", "+params.clearStack);
			log("******************************************");
			
			var id:String = filterId(params.id);
			if ((id !== ModalsInfo.LOADER_ID) || StartupController.introFinished) {
				params.id = id;
				// add listener here for text focus event for ANX hits
				if (!_eventDispatcher.hasEventListener(ModalEvents.TEXT_INPUT_FIELD_IN_FOCUS, handleTextInFocus)) {
					_eventDispatcher.addEventListener(ModalEvents.TEXT_INPUT_FIELD_IN_FOCUS, handleTextInFocus);
				}
				_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.MODAL_OPEN));
				_modalOpening = true;
				sendAnxModalData(id);
				if (params.closeOpen) closeAllModals();
				var info:ModalData = ModalsInfo.getModalData(id);
				
				var modalIndex:int = _curModalLookup.indexOf(info.type);
				if (modalIndex >=0) {
					var showBackBttn:Boolean = false;
					log ("showing modal "+id+", "+_modalStack.length);
					if (params.clearStack) _modalStack.length = 0;
					var sl:int = _modalStack.length;
					var i:int = sl;
					var tInfo:ModalData;
					while (i--) {
						tInfo = ModalsInfo.getModalData(_modalStack[i].id);
						if (!tInfo.track) sl--;
					}
					showBackBttn = (modalIndex === _MAIN_MODAL_INDEX) && (sl > 0);
					if (modalIndex === _MAIN_MODAL_INDEX) { 
						_modalStack.push(params); 
						closeModalByIndex(_MESSAGE_MODAL_INDEX); // if message modal is up when main shown, assume it should be closed
					}
					closeModalByIndex(modalIndex);
					if (modalIndex === _MESSAGE_MODAL_INDEX) {
						hideLoaderMC(); //if a message dialog is shown when loader is up, assume loader should be removed, maybe for other modals also...
					}
					var modal:ModalDialog = new ModalDialog(info.type);
					modal.setDialogById(id, showBackBttn);
					if (params.allowInteraction) {
						modal.hideBlocker();
					}
					_containers[modalIndex].addChild(modal.mc);
					_curModals[modalIndex] = modal;
					if (modalIndex === _DEBUG_LOG_INDEX) {
						(modal.customObject as TextFieldScroller).text = _logString;
						(modal.customObject as TextFieldScroller).scrollToBottom();
					}
					setModalFocus();
				} else {
					throw new Error("bad modal type for id '"+id+"'");
				}
				_modalOpening = false;
				dispatchClosedAllModals();
			}
		}
		
		private function backToPrevModal(clearStack:Boolean = false, clearTop:Boolean = true):void {
			//log("* backToPrevModal clearStack, clearTop "+clearStack+", "+clearTop);
			//log("* backToPrevModal "+_modalStack);
			var prev:Object;
			if (clearStack) _modalStack.length = 0;
			if (clearTop) prev = popStack();
			var info:ModalData;
			do {
				prev = topStack();
				if (prev) {
					info = ModalsInfo.getModalData(prev.id);
					if (info.track) {
						prev = null;
					} else {
						prev = popStack();
					}
				}
			} while (prev);
			//			log("backToPrevModal top "+prev);
			prev = popStack();
			log("* backToPrevModal prev ",prev);
			if (prev) {
				showModalById(prev);
			} else {
				closeTopModal();
			}
		}
		
		private function topStack():Object {
			var result:Object;
			var n:int = _modalStack.length;
			if (n) result = _modalStack[n-1];
			return result
		}
		
		private function popStack():Object {
			return _modalStack.length ? _modalStack.pop() : null;
		}
		
		private function topModal():ModalDialog { 
			var result:ModalDialog;
			var i:int = _curModals.length - 1;
			while (i--) {
				result = _curModals[i];
				if (result) break;
			}
			return result;
		}
		
		private function closeModalById(modalId:String, clearStack:Boolean = false):void { 
			log('* closeModalById; '+modalId);
			var i:int = _curModals.length;
			while (i--) {
				if (_curModals[i] && (_curModals[i].id === modalId)) {
					closeModalByIndex(i);
					break;
				}
			}
			if (clearStack) _modalStack.length = 0;
		}
		
		private function closeAllModals():void{
			for (var i:int=0; i<_curModals.length; i++) {
				closeModalByIndex(i);
			}
		}
		private function closeModalByIndex(i:int):Boolean {
			log('* closeModalByIndex; '+i);
			
			var result:Boolean = false;
			var modal:ModalDialog = _curModals[i];
			if (modal) {
				result = true;
				log("destroying modal "+modal.id);
				_containers[i].removeChild(modal.mc);
				modal.destroy();
				_curModals[i] = null;
				if (i == _DEBUG_LOG_INDEX) clearLog(false); // if closing log window, clear the textfield
//				dispatchClosedAllModals();
				setModalFocus();
			}
			return result;
		}
		
		private function dispatchClosedAllModals():void{ 
			if (_modalStack && !modalOpen()) { 
				_ageGatePassed = false;
				_eventDispatcher.removeEventListener(ModalEvents.TEXT_INPUT_FIELD_IN_FOCUS, handleTextInFocus);
				_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.MODAL_CLOSED_ALL));
				CONFIG::DEBUG {
					cleanupTestModals();
				}
			}
		}
		private function closeTopModal():void{
			log("* closeTopModal");
			
			var i:int = _curModals.length;
			while (i--) {
				if (_curModals[i]) {
					closeModalByIndex(i);
					break;
				}
			}
		}
		private function setModalFocus():void{
			var i:int = _curModals.length;
			var hasFocus:Boolean = true;
			while (i--) {
				if (_curModals[i]) {
					_curModals[i].hasFocus = hasFocus;
					hasFocus = false;
				}
			}
		}
		private function showLoaderMC(allowIneraction:Boolean = true):void{
			showModalById({id:ModalsInfo.LOADER_ID, closeOpen:false, allowIneraction:allowIneraction});
		}
		private function hideLoaderMC():void {
			closeModalByIndex(_LOADER_INDEX);
		}
		
		public function modalOpen():Boolean {
			var result:Boolean = _modalOpening;
			if (!result) {
				var i:int = _curModals.length;
				while (i--) {
					if (_curModals[i]) {
						result = true;
						break;
					}
				}
			}
			return result;
		}
		
		override public function destroy():void {
			log("destroy");
			removeEventListeners();
			_modalStack = null;
			var i:int;
			for (i=0; i<_curModals.length; i++) {
				if (_curModals[i]) _curModals[i].destroy();
			}
			_curModals = null;
			_curModalLookup = null;
			_containers = null;
			_logString = null;
			if (_mainModal) _mainModal.destroy();
			if (_messageModal) _messageModal.destroy();
			if (_modal) _modal.destroy();
			_mainModal = null;
			_messageModal = null;
			_modal = null;
			_debugArray = null;
			super.destroy();
		}
		
		public static function logMessage(msg:String):void {
			if (_logString) {
				if (_logString.length > MAX_LOG_STRING) {
					_logString = _logString.substring(int(MAX_LOG_STRING / 2));
				}
			} else {
				_logString = "";
			}
			_logString += msg;
		}
		private function clearLog(clearString:Boolean = true):void {
			if (clearString) _logString = "";
			var modal:ModalDialog = _curModals[_DEBUG_LOG_INDEX];
			if (modal) {
				(modal.customObject as TextFieldScroller).text = _logString;
			}
		}
	}
}
