package com.speakaboos.ipad.models.impl
{
	import com.speakaboos.ipad.BaseClass;
	import com.speakaboos.ipad.controller.AppController;
	import com.speakaboos.ipad.events.CoreEventDispatcher;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.LoginEvents;
	import com.speakaboos.ipad.models.data.UserProfile;
	import com.speakaboos.ipad.models.impl.enum.SubscriptionTypes;
	import com.speakaboos.ipad.utils.Validation;
	import com.speakaboos.mobile.data.dao.UserDao;
	
	public class UserProfileImpl extends BaseClass
	{
		public static const SUB_STATE_ACTIVE:String = "active";
		public static const SUB_STATE_EXPIRED:String = "expired";
		
		public static const INVALID_SESSION:String = "INVALID_SESSION";
		public static const RETURNING_USER:String = "RETURNING_USER";
		public static const FREE_TRIAL_USER:String = "FREE_TRIAL_USER";
		//public static const NEW_TRIAL_NOT_USED:String = "NEW_TRIAL_NOT_USED";
		public static const NEW_TRIAL_USED:String = "NEW_TRIAL_USED";
		//public static const EXPIRED_TRIAL_USED:String = "EXPIRED_TRIAL_USED";
		//public static const EXPIRED_TRIAL_NOT_USED:String = "EXPIRED_TRIAL_NOT_USED";
		public static const EXPIRED_SUBSCRIBER:String = "EXPIRED_SUBSCRIBER";

		private static var _instance:UserProfileImpl;
		private var _userProfile:UserProfile;
		private var _userProfileDao:UserDao; //note: use userProfileDao to access this var
		
		
		public static function get instantiated():Boolean {return Boolean(_instance)};
		public function UserProfileImpl(enforcer:SingletonEnforcer) {
			super();
			if( enforcer == null ) throw new Error( "UserProfileImpl is a singleton class and should only be instantiated via its static getInstance() method" );
		}
		
		public static function getInstance():UserProfileImpl {
			if( _instance == null ) {
				_instance = new UserProfileImpl( new SingletonEnforcer() );
				_instance.init();
			}
			return _instance;
		}
		public static function destroySingleton():void {
			if (instantiated) _instance.destroy();
		}
		private function init():void {
			addEventListeners();
		}
		
		final private function addEventListeners():void{
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.UPDATE_USER_SUCCEEDED,onUpdateUser);
			CoreEventDispatcher.getInstance().addEventListener(LoginEvents.UPDATE_USER_FAILED,onUpdateUserFailed);
		}
		
		final private function removeEventListeners():void{
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.UPDATE_USER_SUCCEEDED,onUpdateUser);
			CoreEventDispatcher.getInstance().removeEventListener(LoginEvents.UPDATE_USER_FAILED,onUpdateUserFailed);
		}
	
		/* Handlers for Listeners */
		
		final private function onUpdateUser(e:GenericDataEvent):void{
			var u:UserProfile = e.data.userProfile as UserProfile;
			userProfile = u;
			saveUser();
		}
		
		final private function onUpdateUserFailed(e:GenericDataEvent):void{
			
		}
		
		
		/* getters & setters */
		
		final public function get userProfile():UserProfile{
			if(!_userProfile){_userProfile = new UserProfile();}
			return _userProfile;
		}
		
		final public function set userProfile(u:UserProfile):void{
			log("setting user profile= " + u);
			_userProfile = u;
		}
		
		final private function get userProfileDao():UserDao{
			if(!_userProfileDao){
				_userProfileDao = new UserDao();
			}
			
			return _userProfileDao;
		}
		
		
		
		final private function set userProfileDao(upd:UserDao):void{
			_userProfileDao = upd;
		}
		
		
		
		/* convenience functions */
		
		final public function getHandle():String{
			log("UserProfileImpl.getHandle");
			log("UserProfile firstname: " + userProfile.firstname);
			if(userProfile.firstname)
				return userProfile.firstname;
			
			return userProfile.email;
		}
		
		
		final public function hasEmail():Boolean{
			
			if(!userProfile.email || userProfile.email == ""){
				return false;
			}
			
			return true;
			
		
		}
		
		
		final public function sessionIsValid():Boolean{
			if(userProfile.session == "0" || userProfile.session == null || userProfile.session == "") {
				return false;
			}
			return true;
			
		}
		
		
		
		final public function isSpeakaboosSubscriber():Boolean{
			
			if(!isSignedIn())
				return false;
			
			return (subscriberType == SubscriptionTypes.CHARGIFY_SUBSCRIBER);
			
		}
		
		
		final public function isITunesSubscriber():Boolean{
			
			if(!isSignedIn())
				return false;
			
			return (subscriberType == SubscriptionTypes.ITUNES_SUBSCRIBER);
			
		}
		
		final public function isSubscriber():Boolean{
			return (isSpeakaboosSubscriber() || isITunesSubscriber());
		}
		
		final public function isPayingSubscriber():Boolean{
			return (isSubscriber() && getSubscriptionState() == SUB_STATE_ACTIVE);
		}
		
		
		final public function isTrialingUser():Boolean{
			return (getSubscriptionStatus() == FREE_TRIAL_USER);
			
		}
		
		
		
		final public function trialIsOver():Boolean{
			var bool:Boolean = AppController.getInstance().freeStoryLimitReached();
			
			return ((getSubscriptionStatus() == FREE_TRIAL_USER) && bool);
		}
		
		
		
		final public function get subscriberType():String{
			
			if(!isSignedIn())
				return null;
			
			return userProfile.subscription_type;
			
		}
		
		
		
		final public function isSignedIn():Boolean{
			if(!userProfile)
				return false;
			
			//check db?	
			return isPopulated(userProfile.session);
			
		}
		
		
		
		final public function isFBUser():Boolean{
			return (isPopulated(userProfile.fb_id));
		}
		
		
		
		final private function isPopulated(str:String):Boolean{
			return (Validation.isNotEmpty(str));
		}
		
		
		
		final public function getSubscriptionState():String{
			return userProfile.subscription_state;
		}
		
		final public function subscriptionHasExpired():Boolean{
			return (getSubscriptionState() == SUB_STATE_EXPIRED);
		}
		
		
		/*
		 * UserDAO convenience functions
		 * 
		 */
		
		final public function getLastKnownUser(cbFunc:Function):void{
			log("UserProfileImpl.getLastKnownUser");
			var gotLastKnownUser:Function = function(u:UserProfile):void{
				log("gotLastKnownUser closure");
				log(u);
				onGetLastKnownUser(u, cbFunc);
			};

			userProfileDao.getLastUserProfile(gotLastKnownUser);
		}
		
		
		
		
		final private function onGetLastKnownUser(u:UserProfile, cbFunc:Function):void{
			log("UserProfileImpl.onGetLastKnownUser");
			userProfile = u;
			cbFunc(u);
		}
		
		final public function saveUser():void{
			//if(_userProfile){
				userProfileDao.saveUser(userProfile);
			//}
				
		}
		
		
		final public function clear():void{
			//if(_userProfile){
				userProfile.clear();
			//}
		}
		
		final public function clearSession():void{
			//if(_userProfile){
				userProfile.clearSession();
				userProfileDao.setSession(userProfile);
			//}
			
		}
		
		final public function clearAndFlushData():void{
			clear();
			deleteAllUsers();
		}

		
		final public function deleteAllUsers():void{
			userProfileDao.deleteAllUsers();
		}
		
		
		
		/*
			subscription related functions
		*/
		
		final public function userHasFullAccess(limitReached:Boolean = false):Boolean{
			
			log("*** userHasFullAccess: limitReached -> " + limitReached);
			var fullAccess:Boolean;
			var status:String = getSubscriptionStatus();
			var trialer:Boolean;
			log("*** Subscription status: " + status);
			switch(status){
			
				case EXPIRED_SUBSCRIBER:
					fullAccess = false;
					trialer = false;
					break;
				case RETURNING_USER:
					fullAccess = true;
					trialer = false
					break;
				case FREE_TRIAL_USER:
					fullAccess = !limitReached;
					trialer = true;
					break;
				
				//case INVALID_SESSION:
				default:
					fullAccess = !limitReached;
					trialer = true;
					break;
			}
			log("*** userHasFullAccess: "+fullAccess);
			AppController.getInstance().updateRestrictedMode(!fullAccess, trialer);
			return fullAccess;
		}

		
		final public function getSubscriptionStatus():String{
			
			if (!(sessionIsValid())) {
				return INVALID_SESSION;
			}
			
			log("getSubscriptionStatus-> got session: " + userProfile.session);
			
			switch(userProfile.subscription_state)
			{
				case SUB_STATE_ACTIVE:
					
					if(userProfile.subscription_type == SubscriptionTypes.FREE_TRIAL_SUBSCRIBER){
						//free trial (anonymous) user
						return FREE_TRIAL_USER;
						
					}
					else{
						//returning user
						return RETURNING_USER;
					}
					
					break;
				
				case SUB_STATE_EXPIRED:
					//former subscriber
					return EXPIRED_SUBSCRIBER;
					break;
					
				//don't seem to need these below anymore
					/*
					if(_userProfile.free_trial_used != "1")
						return EXPIRED_TRIAL_NOT_USED; //expired but trial not yet used
					else
						return EXPIRED_TRIAL_USED; //expired, trial used
					break;
				*/
				default:
					/*//must be new user?
					if(_userProfile.free_trial_used != "1"){
						//user has not used free trial
						return NEW_TRIAL_NOT_USED;
					}
					else{ 
					*/
					
					//user has used free trial
					return NEW_TRIAL_USED;
								
			}
		}
		
		final public function saveSubscriptionStatus():void{
			if(_userProfile){
				userProfileDao.updateSubscriptionStatus(_userProfile);
			}
		}
		
	
		
		final public function destroy():void{
			if(_userProfileDao){_userProfileDao.destroy();}
			_userProfileDao = null;
			removeEventListeners();
			_instance = null;
		}
		
		
	}
	
}



class SingletonEnforcer {
	public function SingletonEnforcer():void {}
}
