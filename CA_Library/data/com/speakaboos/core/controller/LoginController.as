package com.speakaboos.core.controller
{
	import com.speakaboos.core.events.AppEvents;
	import com.speakaboos.core.events.CoreEventDispatcher;
	import com.speakaboos.core.events.DBEvents;
	import com.speakaboos.core.events.GenericDataEvent;
	import com.speakaboos.core.events.LoginEvents;
	import com.speakaboos.core.events.ModalEvents;
	import com.speakaboos.core.models.data.ErrorStruct;
	import com.speakaboos.core.models.data.ModalsInfo;
	import com.speakaboos.core.models.data.UserProfile;
	import com.speakaboos.core.models.impl.UserProfileImpl;
	import com.speakaboos.core.models.services.LoginService;
	import com.speakaboos.core.models.services.NetworkMonitor;
	import com.speakaboos.core.models.services.enum.LoginModes;
	import com.speakaboos.core.utils.HtmlTextUtil;
	import com.speakaboos.core.utils.Validation;
	import com.speakaboos.core.view.CoreView;
	
	import flash.events.Event;
	
	public class LoginController extends CoreView
	{
		private var _appController:AppController;
		private var _loginService:LoginService;
				
		public function LoginController(appController:AppController){
			super.init();
			_appController = appController;
			log("CONSTRUCTOR");
			addEventListeners();
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
			_loginService = LoginService.getInstance();
			
			
			//showSignIn();
		}
		
		override protected function onRemovedFromStage(e:Event):void{
			super.onRemovedFromStage(e);
			removeEventListeners();
		}
		
		
		final private function addEventListeners():void{
			//LOGIN SERVICE EVENTS
			log("addEventListeners");
			//CoreEventDispatcher.getInstance().addEventListener(AppEvents.LOGIN_SUCCESS, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(AppEvents.LOGOUT_USER, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.SIGNUP, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.SIGNUP_ERROR, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.CREATE_SUBSCRIPTION, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(DBEvents.USER_ADDED_TO_DB, receiveEvent);
			
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.FORGOT_PASSWORD_SENT, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.FORGOT_PASSWORD_ERROR, receiveEvent);

		}
		
		final private function removeEventListeners():void{
			//LOGIN SERVICE EVENTS
			//CoreEventDispatcher.getInstance().addEventListener(AppEvents.LOGIN_SUCCESS, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(AppEvents.LOGOUT_USER, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.SIGNUP, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.SIGNUP_ERROR, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.CREATE_SUBSCRIPTION, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(DBEvents.USER_ADDED_TO_DB, receiveEvent);
			
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.FORGOT_PASSWORD_SENT, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.FORGOT_PASSWORD_ERROR, receiveEvent);

		}
		
		final private function showSignIn():void{
			//log("showSignIn _firstTimeUser:"+_appController.firstTimeUser);
			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.SIGN_IN_ID}));
		}
		
		
		final private function receiveEvent(e:*):void{
			log("receiveEvent type:"+e.type);
			//log(e.data);
			
			var userProfile:UserProfile;
			
			switch(e.type){
				
				case LoginEvents.SIGNUP:
					showLoader();
					_loginService.signup(e.data.userProfile);
					break;
				
				case LoginEvents.SIGNUP_ERROR:
					
					hideLoader();
					
					var errorCode:String = e.data.error.code;
					
					switch(errorCode) 
					{
						case "501":
							CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.USED_EMAIL_ID}));
							break;
						default:
							CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.BAD_SIGN_UP_ID}));
					}
					break;
				
				case AppEvents.LOGIN_SUCCESS:
					onSessionValidated(e);
					break;
				
				case AppEvents.LOGIN_ERROR:	
					processLoginError(e);
					break;
				
				
				
				case AppEvents.LOGOUT_USER:
					logOut();
					break;
				
				
				case LoginEvents.LOGOUT_ERROR:
				case LoginEvents.USER_LOGGED_OUT:
					// sent by loginService on log out from server - get another anonymous user to preserve session
					
					removeAppLogoutListeners();
					createNewAnonSession();
					
					break;
				
				case DBEvents.USER_ADDED_TO_DB:
					removeInsertUserToDbListeners();
					_appController.getSubscriptionController().doSubscriptionFlow();
					
					break;
				
				case DBEvents.INSERT_ERROR:
					
					//TODO: better handling of db insert error
					removeInsertUserToDbListeners();
					hideLoader();
					break;
				
				
				case LoginEvents.UPDATE_USER_SUCCEEDED:
					
					removeUpdateUserAccountListeners();
					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_ALL_MODALS));
					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ALL_SET_ID, clearStack:true}));
					_appController.appStateUpdated();
					
					
					break;
				
				case LoginEvents.UPDATE_USER_FAILED:
					
					removeUpdateUserAccountListeners();
					
					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));
					_appController.appStateUpdated();
					var thisError:ErrorStruct = e.data.error as ErrorStruct;
					if(thisError.code != 501){
						CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.COMPLETE_ACCOUNT_FAILED_ID, clearStack:true}));
					}else{
						CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.USED_EMAIL_ID, clearStack:true}));
					}
					
					break;
				
				case LoginEvents.FORGOT_PASSWORD_SENT:
					hideLoader();
					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.PASSWORD_RESET_ID}));
					
					break;
				
				case LoginEvents.FORGOT_PASSWORD_ERROR:
					hideLoader();
					var err:ErrorStruct = e.data.error as ErrorStruct;
					if(err.code == 502){
						//user not found error
						CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.NO_MATCHING_EMAIL_ID}));
					}else{
						//unknown error occurred
						HtmlTextUtil.textSubstitutions = {message: "We were unable to reset your password.  Please try again later."};
						CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ERROR_MISC_ID}));
					}
					
					break;
				
				
				
				
			}
			
			
		}
		
		
	
		override public function destroy():void{
			log("destroy");
			removeEventListeners();
			_appController = null;
			_loginService = null;
			super.destroy();
		}
		
		
		final private function addAppLoginListeners():void{
			CoreEventDispatcher.getInstance().addEventListener(AppEvents.LOGIN_SUCCESS, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(AppEvents.LOGIN_ERROR, receiveEvent);
		}
		
		final private function removeAppLoginListeners():void{
			CoreEventDispatcher.getInstance().removeEventListener(AppEvents.LOGIN_SUCCESS, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(AppEvents.LOGIN_ERROR, receiveEvent);
		}
		
		final private function addAppLogoutListeners():void{
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.USER_LOGGED_OUT, receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.LOGOUT_ERROR, receiveEvent);
		}
		
		final private function removeAppLogoutListeners():void{
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.USER_LOGGED_OUT, receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.LOGOUT_ERROR, receiveEvent);
		}
		
		final private function addUpdateUserAccountListeners():void{
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.UPDATE_USER_SUCCEEDED,receiveEvent);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.UPDATE_USER_FAILED,receiveEvent);
		}
		
		final private function removeUpdateUserAccountListeners():void{
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.UPDATE_USER_SUCCEEDED,receiveEvent);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.UPDATE_USER_FAILED,receiveEvent);
		}
		
		
		final public function checkSession():void{
			addAppLoginListeners();
			LoginService.getInstance().checkSession(LoginService.getInstance().getUserProfile());
		}
		
		final public function completeAccount(newName:String, newPw:String):void{
			var u:UserProfile = LoginService.getInstance().getUserProfile();
			if(u){
				showLoader();
				LoginService.getInstance().updateUserAccount(u, newName, newPw);
				addUpdateUserAccountListeners();
			}
			
		}
		
		
		final private function onSessionValidated(e:GenericDataEvent):void{
			log("onSessionValidated");
			
			/*
			NOTE: 
			This callback function is called by login, checksession, and createAnonymousUser from LoginService
			Be sure to use addUserToDB, rather than saveUserToDB()
			addUserToDB() dispatches events that are used downstream
			*/
			
			removeAppLoginListeners();
			LoginService.destroySingleton();
			
			var thisMode:String = e.data.mode as String;
			
			log("LoginMode: " + thisMode);
			//check to see if the user was obtaining a new session while on the Subscription or Restore modal
			if(thisMode != LoginModes.LOGIN_NEW_SESSION){
				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_ALL_MODALS));
				showLoader();
			}
			
			/*
			add new user to db
			*/
			addUserToDB();
			
			// TODO: Maybe we need to wait until the user add is complete before finishing? not sure, and not sure how
			
			//this seems unnecessary.  It's being done in doSubscriptionFlow()
			if (!StartupController.introFinished) {
				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(AppEvents.FINISH_INTRO));
			}
		}
		
		final private function addInsertUserToDbListeners():void{
			CoreEventDispatcher.getInstance().addEventListener(DBEvents.INSERT_ERROR,receiveEvent);
		}
		
		final private function removeInsertUserToDbListeners():void{
			CoreEventDispatcher.getInstance().removeEventListener(DBEvents.INSERT_ERROR,receiveEvent);
		}
		
		
		
		
		
		
		
		
		final private function processLoginError(e:GenericDataEvent):void{
			removeAppLoginListeners();
			LoginService.destroySingleton();
			var loginError:ErrorStruct = e.data.error as ErrorStruct;
			log("Error occurred: " + loginError.error);
			if (loginError && (loginError.code == 402)) {
				hideLoader();
				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.EMAIL_PASSWORD_INCORRECT_ID}));
			} else {
				doInvalidSession();
			}
		}
		
		
		final public function doInvalidSession():void{
			//return to login screen
			log("doInvalidSession")
			removeAppLoginListeners();
			
			//log("User's session is invalid -> logging the user out");
			logOut();
			
		}
		
		
		final public function logIn(u:UserProfile):void{
			showLoader();
			addAppLoginListeners();
			LoginService.getInstance().login(u);
		}
		
		final public function logOut():void{
			log("logOut");
			//clear the user from the database and present the login screen
			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.CLOSE_ALL_MODALS));
			var u:UserProfile = LoginService.getInstance().getUserProfile();
			if (u == null){return};
			
			//clear userProfile data and delete all db users 
			var s:String = u.session;
			UserProfileImpl.getInstance().clearAndFlushData();
			
			if(NetworkMonitor.getInstance().isOnline){
				addAppLogoutListeners();
				LoginService.getInstance().logOut(s);
			}
			
			if (StartupController.introFinished) {
				_appController.appStateUpdated();
			} else {
				CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(AppEvents.FINISH_INTRO));
			}
			
		}
		
		
		
		final public function getNewSession():void{
			//use this function to obtain a new session on the fly
			//Note: any modals currently open will remain open
			addAppLoginListeners();
			LoginService.getInstance().getNewSession();
		}
		
		final public function clearSession():void{
			UserProfileImpl.getInstance().clearSession();		
		}
		
		final public function sessionIsValid():Boolean{
			return UserProfileImpl.getInstance().sessionIsValid();
		}
		
		final public function registerAnonymousUser():void {
			addAppLoginListeners();
			LoginService.getInstance().registerAnonymousUser();
		}
		
		
		
		final public function createNewAnonSession():void{
				registerAnonymousUser();	
		}
		
		CONFIG::KYOWON{
			final public function initKyoWonAuth(ku:String=""):void{
				//get the username from the intent
				//pass the username to a service that will return a new session and Speakaboos account ID
				if(Validation.isPopulated(ku)){
					//username found, pass it to a web service that creates a speakaboos user from a kyoWon username
					registerKyoWonUser(ku);
				}
				else{
					//Cannot proceed without a valid KyoWon username
					//Warn user and close the app
				
					//TODO:
					//generate a new modal instead of this generic error modal below.  The new modal would automatically shut the app when the user clicks "OK"
					HtmlTextUtil.textSubstitutions = {message: "Could not retrieve user account.  Please restart the application and try again"};
					CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:ModalsInfo.ERROR_MISC_ID}));		
				}
			}
		
			
			final public function registerKyoWonUser(u:String):void {
				addAppLoginListeners();
				LoginService.getInstance().registerKyoWonUser(u);
			}
		
		} //end CONFIG::KYOWON
		
			
		
		final public function addUserToDB():void{
			/*
			Insert a new user into the DB
			Dispatches USER_ADDED_TO_DB event
			*/
			
			//TODO: remove the need for this hack by handling destroys() better
			//hack to make sure UserDAO is listening for ADD_USER_TO_DB event
			LoginService.getInstance().getUserProfile();
			
			addInsertUserToDbListeners();
			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(DBEvents.ADD_USER_TO_DB, {userProfile:LoginService.getInstance().getUserProfile()}));
		}
		
		
		final public function showSubscribe(e:Event = null):void{
			//log("showSubscribe");
			var modalId:String = (UserProfileImpl.getInstance().subscriptionHasExpired()) ? ModalsInfo.SUBSCRIPTION_EXPIRED_BLOCKER_ID : ModalsInfo.TRIAL_OVER_BLOCKER_ID;
			CoreEventDispatcher.getInstance().dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_MODAL, {id:modalId, clearStack:true}));
		}
		
		
		
	}
}
