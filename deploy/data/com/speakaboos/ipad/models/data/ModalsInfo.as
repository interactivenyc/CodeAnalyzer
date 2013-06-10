package com.speakaboos.ipad.models.data
{
	import com.speakaboos.ipad.models.data.ModalData;
	import com.speakaboos.ipad.models.data.TextEntryInfo;
	import com.speakaboos.ipad.models.services.CacheDataService;
	import com.speakaboos.ipad.utils.ObjectUtils;
	import com.speakaboos.ipad.view.holders.components.CoreButton;
	import com.speakaboos.ipad.view.holders.components.LabeledTextEntries;
	import com.speakaboos.ipad.view.holders.components.ManageStoriesPanel;
	import com.speakaboos.ipad.view.holders.components.ModalBttnLabel;
	import com.speakaboos.ipad.view.holders.components.ModalTextBttn;
	import com.speakaboos.ipad.view.holders.components.SubscribeBttnGroup;
	import com.speakaboos.ipad.view.holders.components.TextFieldLoader;
	import com.speakaboos.ipad.view.holders.components.TextFieldScroller;
	
	import flash.display.BitmapData;
	
	public class ModalsInfo
	{
		public static const MESSAGE_MODAL_TYPE:Class = MessageDialogsMC;
		public static const MAIN_MODAL_TYPE:Class = MainDialogsMC;
		public static const DEBUG_LOG_TYPE:Class = DebugLogMC;
		public static const LOADER_TYPE:Class = LoaderAnimMC;
		// button icon exports:
		private static const ICON_FACEBOOK:BitmapData = icon_facebook as BitmapData;
		private static const ICON_TWITTER:BitmapData = icon_twitter as BitmapData;
		private static const ICON_YOUTUBE:BitmapData = icon_youtube as BitmapData;
		private static const ICON_PINTEREST:BitmapData = icon_pinterest as BitmapData;
		private static const ICON_SPEAKABOOS:BitmapData = icon_speakaboos as BitmapData;
		
//		public static const PREFERENCES_ID:String = "preferences";
		public static const TRIAL_OVER_ID:String = "trialOver";
		public static const WELCOME_ID:String = "welcome";
		public static const TRIALING_USER_ID:String = "trialingUser";
		public static const ABOUT_ID:String = "about";
		public static const HELP_FAQ_ID:String = "helpfaq";
		public static const CONTACT_ID:String = "contact";
		public static const TERMS_ID:String = "terms";
		public static const PRIVACY_ID:String = "privacy";
		public static const SUBSCRIBE_ID:String = "subscribe";
		public static const COMPLETE_ACCOUNT_ID:String = "completeAccount";
		public static const MANAGE_ACCOUNT_ID:String = "manageAcount";
		public static const MANAGE_ACCOUNT_EMAIL_ID:String = "manageAcountEmail";
		public static const MANAGE_STORIES_ID:String = "manageStories";
		public static const SIGNED_IN_EMAIL_ID:String = "signedInEmail";
		public static const SIGNED_IN_OTHER_ID:String = "signedInOther";
		public static const SIGN_IN_ID:String = "signIn";
		public static const FORGOT_PASSWORD_ID:String = "forgotPassword";
		public static const DEBUG_LOG_ID:String = "debugLog";
		public static const LOADER_ID:String = "loader";
		public static const NETWORK_ERROR_ID:String = "networkError";
		public static const SUBSCRIPTION_SUCCEEDED_ID:String = "subscriptionSucceeded";
		public static const SUBSCRIPTION_FAILED_ID:String = "subscriptionFailed";
		public static const SUBSCRIPTION_APP_STORE_FAILED_ID:String = "subscriptionAppStoreFailed";
		public static const SUBSCRIPTION_APP_STORE_DOWN_ID:String = "subscriptionAppStoreDown";
		public static const SUBSCRIPTION_PROD_FAILED_ID:String = "subscriptionProdFailed";
		public static const SUBSCRIPTION_REQUIRED_ID:String = "subscriptionRequired";
		public static const RESTORE_PURCHASES_SUCCEEDED_ID:String = "restorePurchasesSucceeded";
		public static const RESTORE_PURCHASES_EMPTY_ID:String = "restorePurchasesEmpty";
		public static const ERROR_RESTORE_PURCHASES_ID:String = "errorRestorePurchases";
		public static const FACEBOOK_FAILED_ID:String = "facebookFail";
		public static const FACEBOOK_FAILED_GEN_ID:String = "facebookFailGen";
		public static const ERROR_EMAIL_FORMAT_ID:String = "errorEmailFormat";
		public static const ERROR_PASSWORD_FORMAT_ID:String = "errorPasswordFormat";
		public static const ERROR_MISC_ID:String = "ErrorMisc";
		public static const COMPLETE_ACCOUNT_FAILED_ID:String = "completeAccountFailed";
		public static const SUBSCRIPTION_EXPIRED_ID:String = "subscriptionExpired";
		public static const RESUBSCRIBE_ID:String = "resubscribe";
		public static const SIGNED_IN_SUB_EXPIRED_ID:String = "signedInSubExpired";
		public static const MANAGE_ACCOUNT_SUB_EXPIRED_ID:String = "manageAccountSubExpired";
		
		public static const BACK_BTTN_ID:String = "bttn_back";
		public static const CLOSE_BTTN_ID:String = "bttn_close";
		public static const SIGN_OUT_BTTN_ID:String = "signOut";
		public static const JOIN_BTTN_ID:String = "join";
		public static const OK_BTTN_ID:String = "ok";
		public static const CANCEL_BTTN_ID:String = "cancel";
		public static const RESTORE_PURCHASES_BTTN_ID:String = "restorePurchase";
		public static const COMPLETE_ACCOUNT_BTTN_ID:String = "completeAccount";
		public static const CONTACT_SALES_ID:String = "contactSales";
		public static const CONTACT_BILLING_ID:String = "contactBilling";
		public static const CONTACT_SUPPORT_ID:String = "contactSupport";
		public static const CONTACT_GENERAL_ID:String = "contactGeneral";
		public static const CONTACT_PRESS_ID:String = "contactPress";
		public static const CONTACT_PARTNERS_ID:String = "contactPartners";
		public static const CONTACT_JOBS_ID:String = "contactJobs";
		public static const SHARE_GOOGLEPLUS_ID:String = "shareGP";
		public static const SHARE_INSTAGRAM_ID:String = "shareIg";
		public static const SHARE_FACEBOOK_ID:String = "shareFb";
		public static const SHARE_SPEAKABOOS_ID:String = "shareSb";
		public static const SHARE_PINTEREST_ID:String = "sharePt";
		public static const SHARE_YOUTUBE_ID:String = "shareYt";
		public static const SHARE_TWITTER_ID:String = "shareTr";
		public static const GET_STARTED_BTTN_ID:String = "getStarted";
		public static const DELETE_STORIES_ID:String = "delStories";
		public static const DELETE_STORY_ID:String = "delStory";
		public static const ALL_SET_ID:String = "allSet";
		public static const PASSWORD_RESET_ID:String = "passwordReset";
		public static const BAD_EMAIL_ID:String = "badEmail";
		public static const BAD_SIGN_IN_ID:String = "badSignIn";
		public static const BAD_SIGN_UP_ID:String = "badSignUp";
		public static const MISSMATCHED_EMAIL_ID:String = "missmatchedEmail";
		public static const USED_EMAIL_ID:String = "usedEmail";
		public static const ALREADY_SUBSCRIBED_BTTN_ID:String = "alreadySubscribedBttn";
		public static const CLEAR_BTTN_ID:String = "clearBttn";
		public static const HOME_BTTN_ID:String = "homeBttn";
		public static const DEBUG_BTTN_ID:String = "debugBttn";
		public static const ITUNES_FAILED_ID:String = "itunesFailed";
		public static const NEED_CONNECTION_ID:String = "needConnection";
		public static const TEST_MODALS_BTTN_ID:String = "testModals";
		public static const MORE_HELP_BTTN_ID:String = "moreHelp";
		public static const SHARE_AND_FOLLOW_ID:String = "shareAndFollow";
		public static const REPLAY_WELCOME_VIDEO_ID:String = "replayWelcomeVideo";
		public static const ERROR_STORY_LOAD_ID:String = "errorStoryLoad";
		public static const FORGOT_PASSWORD_BTTN_ID:String = "forgotPasswordBttn";
		public static const TRIAL_OVER_BLOCKER_ID:String = "trialOverBlocker";

		
		private static const VERSION_TEXT:String = "Version #version_num# © #cr_year# Speakaboos. All Rights Reserved.";
		private static const SETTINGS_TITLE:String = "Parental Settings & Help";
		private static const MANAGE_ACCOUNT_TITLE:String = "Manage Your Account";
		
		private static var _data:Object;
		
		public static function get data():Object {
			if (!_data) _data = makeData();
			return _data;
		}
		
		public static function getModalData(key:String):ModalData {
			trace("[ ModalsInfo ] * getModalData: "+key);
			if (!_data) _data = makeData();
			return new ModalData().setData(ObjectUtils.copyObj(_data[key])); //TODO:implement pool for this, important that this returns new copy of data in case it get's manipulated
		}
		
		private static function makeData():Object {
			_data = {};
			_data[TRIAL_OVER_ID] = [
				MAIN_MODAL_TYPE,
				1,
				SETTINGS_TITLE,
				[
					"<h2>Keep Reading, Join Today!</h2><p>We hope you have enjoyed your free preview of the Speakaboos app. Join today for access to one of the largest children’s book libraries!</p>",
					VERSION_TEXT
				],
				null,
				[
					{text:"Join",
						id:JOIN_BTTN_ID
					},
					{text:"Sign In",
						id:SIGN_IN_ID
					}
				],
				[
					[
						{text:"About Speakaboos",
							id:ABOUT_ID
						},
						{text:"Help & FAQs",
							id:HELP_FAQ_ID
						},
						{text:"Contact Us",
							id:CONTACT_ID
						},
						{text:"Terms of Use",
							id:TERMS_ID
						},
						{text:"Privacy Policy",
							id:PRIVACY_ID
						}
					]
				]
			];
			_data[TRIALING_USER_ID] = [
				MAIN_MODAL_TYPE,
				1,
				SETTINGS_TITLE,
				[
					"<h2>Welcome to Speakaboos!</h2><p>You’re enjoying a preview of the Speakaboos app. We're giving you 3 free books so you and your child can experience the incredible stories and fun we have to offer. Happy reading!</p>",
					VERSION_TEXT
				],
				null,
				[
					{text:"Join",
						id:JOIN_BTTN_ID
					},
					{text:"Sign In",
						id:SIGN_IN_ID
					}
				],
				[
					[
						{text:"About Speakaboos",
							id:ABOUT_ID
						},
						{text:"Help & FAQs",
							id:HELP_FAQ_ID
						},
						{text:"Contact Us",
							id:CONTACT_ID
						},
						{text:"Terms of Use",
							id:TERMS_ID
						},
						{text:"Privacy Policy",
							id:PRIVACY_ID
						}
					]
				]
			];
			_data[SIGNED_IN_EMAIL_ID] = [
				MAIN_MODAL_TYPE,
				2,
				SETTINGS_TITLE,
				[
					"<small>You are signed in as:</small>",
					"<small>Your #subscription_time# Subscription will automatically renew on #renew_date# unless cancelled.</small>", //"<small>Your #subscription_time# Subscription will automatically renew on #renew_date# unless cancelled.</small>"
					VERSION_TEXT
				],
				[
					{text:"#email#",
						id:"email",
						clss: ModalBttnLabel
					}
				],
				[
					{text:"<u>Sign Out</u>",
						id:SIGN_OUT_BTTN_ID/*,
						clss: ModalBttnLabel*/
					}
				],
				[
					[
						{text:"Manage Account",
							id:MANAGE_ACCOUNT_EMAIL_ID
						},
						{text:"Manage Stories",
							id:MANAGE_STORIES_ID
						}
					],
					[
						{text:"About Speakaboos",
							id:ABOUT_ID
						},
						{text:"Help & FAQs",
							id:HELP_FAQ_ID
						},
						{text:"Contact Us",
							id:CONTACT_ID
						},
						{text:"Terms of Use",
							id:TERMS_ID
						},
						{text:"Privacy Policy",
							id:PRIVACY_ID
						}
					]
				]
			];
			_data[SIGNED_IN_SUB_EXPIRED_ID] = [
				MAIN_MODAL_TYPE,
				2,
				SETTINGS_TITLE,
				[
					"<small>You are signed in as:</small>",
					"<small>According to our records, your subscription expired on #renew_date#.</small>", 
					VERSION_TEXT
				],
				[
					{text:"#email#",
						id:"email",
						clss: ModalBttnLabel
					}
				],
				[
					{text:"<u>Sign Out</u>",
						id:SIGN_OUT_BTTN_ID/*,
						clss: ModalBttnLabel*/
					}
				],
				[
					[
						{text:"Renew Subscription",
							id:RESUBSCRIBE_ID
						},
						{text:"Manage Account",
							id:MANAGE_ACCOUNT_SUB_EXPIRED_ID
						}
					],
					[
						{text:"About Speakaboos",
							id:ABOUT_ID
						},
						{text:"Help & FAQs",
							id:HELP_FAQ_ID
						},
						{text:"Contact Us",
							id:CONTACT_ID
						},
						{text:"Terms of Use",
							id:TERMS_ID
						},
						{text:"Privacy Policy",
							id:PRIVACY_ID
						}
					]
				]
			];
			_data[SIGNED_IN_OTHER_ID] = [
				MAIN_MODAL_TYPE,
				3,
				SETTINGS_TITLE,
				[
					"<small>You are signed in as:</small>",
					"<small>Your #subscription_time# subscription will automatically renew on #renew_date# unless cancelled.</small>", //"<small>Your #subscription_time# subscription will automatically renew on #renew_date#, unless cancelled.</small>",
					VERSION_TEXT
				],
				[
					{text:"#subscriberType# Subscriber",
						id:"subscriberType",
						clss: ModalBttnLabel
					}
				],
				[
					{text:"<u>Sign Out</u>",
						id:SIGN_OUT_BTTN_ID
					}
				],
				[
					[
						{text:"Complete Account",
							id:COMPLETE_ACCOUNT_ID
						},
						{text:"Manage Account",
							id:MANAGE_ACCOUNT_ID
						},
						{text:"Manage Stories",
							id:MANAGE_STORIES_ID
						}
					],
					[
						{text:"About Speakaboos",
							id:ABOUT_ID
						},
						{text:"Help & FAQs",
							id:HELP_FAQ_ID
						},
						{text:"Contact Us",
							id:CONTACT_ID
						},
						{text:"Terms of Use",
							id:TERMS_ID
						},
						{text:"Privacy Policy",
							id:PRIVACY_ID
						}
					]
				]
			];
			_data[COMPLETE_ACCOUNT_ID] = [
				MAIN_MODAL_TYPE,
				4,
				"Complete Account",
				[
					"<p>Get free access to Speakaboos stories and songs on the web and other devices. Complete your account for access anywhere now!</p>",
					"<small>By tapping Submit, you agree to our Terms of Use and Privacy Policy.</small>"
				],
				null,
				[
					{text:"Submit",
						id:OK_BTTN_ID
					}
				],
				null,
				{
					id:"entry",
					clss: LabeledTextEntries,
					infoLst: [
						new TextEntryInfo("E-mail", "Enter your e-mail address.", TextEntryInfo.EMAIL_TYPE),
						new TextEntryInfo("Verify", "Re-enter your e-mail address.", TextEntryInfo.EMAIL_TYPE),
						new TextEntryInfo("Password", "Enter your password.", TextEntryInfo.PASSWORD_TYPE)
					]
				}
			];
			_data[SIGN_IN_ID] = [
				MAIN_MODAL_TYPE,
				12,
				"Sign In",
				[
					"<18pt>Already Subscribed but don't have a Speakaboos account?</18pt>"
				],
				null,
				[
					{text:"Sign In",
						id:OK_BTTN_ID
					},
					{text:"<p><u>Forgot Your Password?</u></p>",
						id:FORGOT_PASSWORD_BTTN_ID,
						clss: ModalTextBttn
					},
					{text:"<22pt><b><u>Restore your purchase with your Apple ID.</u></b></22pt>",
						id:RESTORE_PURCHASES_BTTN_ID,
						clss: ModalTextBttn
					}
				],
				null,
				{
					id:"entry",
					clss: LabeledTextEntries,
					infoLst: [
						new TextEntryInfo("E-mail", "Enter your e-mail address.", TextEntryInfo.EMAIL_TYPE),
						new TextEntryInfo("Password", "Enter your password.", TextEntryInfo.PASSWORD_TYPE)
					]
				}
			];
			_data[FORGOT_PASSWORD_ID] = [
				MAIN_MODAL_TYPE,
				13,
				"Forgot Your Password?",
				[
					"<p>Enter your e-mail address, and we’ll send you a new password.</p>"
				],
				null,
				[
					{text:"Submit",
						id:OK_BTTN_ID
					}
				],
				null,
				{
					id:"entry",
					clss: LabeledTextEntries,
					infoLst: [
						new TextEntryInfo("E-mail", "Enter your e-mail address.", TextEntryInfo.EMAIL_TYPE)
					]
				}
			];
			_data[HELP_FAQ_ID] = [
				MAIN_MODAL_TYPE,
				5,
				"Help & FAQs",
				null,
				null,
				[
					{text:"Get More Help Online",
						id:MORE_HELP_BTTN_ID
					}
				],
				null,
				{
					id: "scrolling",
					clss: TextFieldLoader,
					loadSlug:CacheDataService.HELP_FAQS_SLUG
				}
			];
			_data[TERMS_ID] = [
				MAIN_MODAL_TYPE,
				6,
				"Terms of Use",
				null,
				null,
				null,
				null,
				{
					id: "scrolling",
					clss: TextFieldLoader,
					loadSlug:CacheDataService.TERMS_OF_USE_SLUG
				}
			];
			_data[PRIVACY_ID] = [
				MAIN_MODAL_TYPE,
				6,
				"Privacy Policy",
				null,
				null,
				null,
				null,
				{
					id: "scrolling",
					clss: TextFieldLoader,
					loadSlug:CacheDataService.PRIVACY_POLICY_SLUG
				}
			];
			_data[ABOUT_ID] = [
				MAIN_MODAL_TYPE,
				16,
				"About Speakaboos",
				null,
				null,
				[
					
					{text:"Replay Welcome Video",
						id:REPLAY_WELCOME_VIDEO_ID
					},
					{text:"Keep in Touch",
						id:SHARE_AND_FOLLOW_ID
					}
				],
				null,
				{
					id: "scrolling",
					clss: TextFieldLoader,
					loadSlug:CacheDataService.SPEAKABOOS_STORY_SLUG
				}
			];
			_data[MANAGE_STORIES_ID] = [
				MAIN_MODAL_TYPE,
				9,
				"Manage Stories",
				["Running out of space? You can remove downloaded stories to free up space on your device. Don't worry, you can always download them again for access offline."],
				null,
				[
					{text:"Remove All Stories",
						id:DELETE_STORIES_ID
					}
				],
				null,
				{
					id: "scrolling",
					clss: ManageStoriesPanel,
					params:[]
				}
			];
			_data[CONTACT_ID] = [
				MAIN_MODAL_TYPE,
				8,
				"Contact Us",
				[
					"<p>At Speakaboos, the only thing we love more than stories is talking to our fans. Have a question, got a gripe, or want to join us? Get in touch at the appropriate link below.</p>"
				],
				null,
				null,
				[
					[
						{text:"School & Library Sales",
							id:CONTACT_SALES_ID
						},
						{text:"Billing Questions",
							id:CONTACT_BILLING_ID
						},
						{text:"Technical Support",
							id:CONTACT_SUPPORT_ID
						},
						{text:"General Feedback",
							id:CONTACT_GENERAL_ID
						},
						{text:"Press Inquiries",
							id:CONTACT_PRESS_ID
						},
						{text:"Partnership Opportunities",
							id:CONTACT_PARTNERS_ID
						},
						{text:"Career Opportunities",
							id:CONTACT_JOBS_ID
						}
					]
				]
			];
			_data[SHARE_AND_FOLLOW_ID] = [
				MAIN_MODAL_TYPE,
				7,
				"Keep in Touch",
				[
					"<p>Follow us to stay current on the latest news, updates, and special promotions.</p>"
				],
				null,
				null,
				[
					[
//						{text:"GooglePlus",
//							id:SHARE_GOOGLEPLUS_ID,
//							icon:ICON_GOOGLEPLUS
//						},
//						{text:"Instagram",
//							id:SHARE_INSTAGRAM_ID,
//							icon:ICON_FACEBOOK
//						},
						{text:"Facebook",
							id:SHARE_FACEBOOK_ID,
							icon:ICON_FACEBOOK
						},
						{text:"Twitter",
							id:SHARE_TWITTER_ID,
							icon:ICON_TWITTER
						},
						{text:"YouTube",
							id:SHARE_YOUTUBE_ID,
							icon:ICON_YOUTUBE
						},
						{text:"Pinterest",
							id:SHARE_PINTEREST_ID,
							icon:ICON_PINTEREST
						},
						{text:"Speakaboos.com",
							id:SHARE_SPEAKABOOS_ID,
							icon:ICON_SPEAKABOOS
						}
					]
				]
			];
			_data[MANAGE_ACCOUNT_EMAIL_ID] = [
				MAIN_MODAL_TYPE,
				10,
				"Manage Account",
				[
					"<small>You are signed in as:</small>",
					"<small>Your #subscription_time# Subscription will automatically renew on #renew_date# unless cancelled.</small>", //"<small>Your #subscription_time# Subscription will automatically renew on #renew_date# unless cancelled.</small>",
				],
				[
					{text:"#email#",
						id:"email",
						clss: ModalBttnLabel
					}
				],
				[
					{text:"<u>Sign Out</u>",
						id:SIGN_OUT_BTTN_ID
					},
					{text:"Restore Purchase",
						id:RESTORE_PURCHASES_BTTN_ID
					}
				],
				null,
				{
					id: "loadField",
					clss: TextFieldLoader,
					loadSlug: CacheDataService.MANAGE_YOUR_ACCOUNT_SLUG
				}
				
			];
			_data[MANAGE_ACCOUNT_SUB_EXPIRED_ID] = [
				MAIN_MODAL_TYPE,
				10,
				"Manage Account",
				[
					"<small>You are signed in as:</small>",
					"<small>According to our records, your subscription expired on #renew_date#.</small>",
				],
				[
					{text:"#email#",
						id:"email",
						clss: ModalBttnLabel
					}
				],
				[
					{text:"<u>Sign Out</u>",
						id:SIGN_OUT_BTTN_ID
					},
					{text:"Restore Purchase",
						id:RESTORE_PURCHASES_BTTN_ID
					}
				],
				null,
				{
					id: "loadField",
					clss: TextFieldLoader,
					loadSlug: CacheDataService.MANAGE_YOUR_ACCOUNT_SLUG
				}
				
			];
			_data[MANAGE_ACCOUNT_ID] = [
				MAIN_MODAL_TYPE,
				11,
				"Manage Account",
				[
					"<small>You are signed in as:</small>",
					"<small>Your #subscription_time# Subscription will automatically renew on #renew_date# unless cancelled.</small>", //"<small>Your #subscription_time# Subscription will automatically renew on #renew_date# unless cancelled.</small>"
				],
				[
					{text:"#email#",
						id:"email",
						clss: ModalBttnLabel
					}
				],
				[
					{text:"<u>Sign Out</u>",
						id:SIGN_OUT_BTTN_ID
					},
					{text:"Complete Account",
						id:COMPLETE_ACCOUNT_BTTN_ID
					},
					{text:"Restore Purchase",
						id:RESTORE_PURCHASES_BTTN_ID
					}
				],
				null,
				{
					id: "loadField",
					clss: TextFieldLoader,
					loadSlug:CacheDataService.MANAGE_YOUR_ACCOUNT_SLUG
				}
			];
			
			_data[WELCOME_ID] = [
				MAIN_MODAL_TYPE,
				14,
				"Welcome to Speakaboos",
				[
					"<22pt>You’ll have access to <b>hundreds of stories and songs.</b></22pt>",
					"<22pt>Speakaboos <b>instills a love of reading</b> in your child.</22pt>",
					"<22pt>Our interactive books <b>build and support literacy.</b></22pt>",
					"<22pt><b>New stories</b> are added every month!</22pt>",
					"<22pt>Start exploring the Speakaboos app now. <b>Your first 3 stories are free!</b></22pt>"
				],
				null,
				[
					{text:"Get Started",
						id:GET_STARTED_BTTN_ID
					}
				]
			];
			_data[SUBSCRIBE_ID] = [
				MAIN_MODAL_TYPE,
				15,
				"Keep Reading, Join Today!",
				[
					"<h3>Join now for continued access to:</h3>",
					"<h3><b>Hundreds of storybooks</b> that get children to read more</h3>" +
					"<h3>Interactive books that enhance <b>literacy, word recognition, and comprehension</b></h3>" +
					"<h3><b>Read-along help</b> with words highlighting along with narration</h3>",
					"<h3></h3>",
					"<h3>It's easy—all you need to do is choose a plan:</h3>",
					"<small>Subscriptions will automatically renew until canceled.</small>"
				],
				null,
				[
					{text:"<b><u>Already Subscribed?</u></b>",
						id:ALREADY_SUBSCRIBED_BTTN_ID,
						clss: ModalTextBttn
					}
				],
				null,
				{
					id: "subscribeBttns",
					clss:SubscribeBttnGroup,
					params:[]
				}
			];
			_data[RESUBSCRIBE_ID] = [
				MAIN_MODAL_TYPE,
				15,
				"Your Subscription Has Expired",
				[
					"<h3>Renew your subscription for continued access to:</h3>",
					"<h3><b>Hundreds of storybooks</b> that get children to read more</h3>" +
					"<h3>Interactive books that enhance <b>literacy, word recognition, and comprehension</b></h3>" +
					"<h3><b>Read-along help</b> with words highlighting along with narration</h3>",
					"<h3></h3>",
					"<h3>It's easy—all you need to do is choose a plan:</h3>",
					"<small>Subscriptions will automatically renew until canceled.</small>"
				],
				null,
				[
					{text:"<b><u>Already Subscribed?</u></b>",
						id:ALREADY_SUBSCRIBED_BTTN_ID,
						clss: ModalTextBttn
					}
				],
				null,
				{
					id: "subscribeBttns",
					clss:SubscribeBttnGroup,
					params:[]
				}
			];
			
			_data[USED_EMAIL_ID] = [
				MESSAGE_MODAL_TYPE,
				"E-mail Address in Use",
				["This e-mail address belongs to an existing account. Please try another e-mail address or sign in with your existing account."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[MISSMATCHED_EMAIL_ID] = [
				MESSAGE_MODAL_TYPE,
				"Mismatched E-mails",
				["One of the e-mail addresses has been entered incorrectly. Please reenter your e-mail address. "],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[BAD_SIGN_IN_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops, That's Not Right",
				["The e-mail address or password you entered is incorrect. Please try again."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[BAD_SIGN_UP_ID] = [
				MESSAGE_MODAL_TYPE,
				"Sign Up Error",
				["An error occured when trying to sign you up. Please try again."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[BAD_EMAIL_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops, That's Not Right",
				["The e-mail address you entered does not match any existing account. Please try again."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[ERROR_EMAIL_FORMAT_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops, That's Not Right",
				["The e-mail address you entered is invalid. Please try again."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[ERROR_PASSWORD_FORMAT_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops, That's Not Right",
				["Your password must be at least six characters with no spaces.  Please try again."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[PASSWORD_RESET_ID] = [
				MESSAGE_MODAL_TYPE,
				"Password Sent",
				["We've reset your password and sent it to the e-mail address you provided. Please allow a few minutes for it to arrive."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[ALL_SET_ID] = [
				MESSAGE_MODAL_TYPE,
				"You're All Set!",
				["Use your Speakaboos account to sign into the app on any device or at www.speakaboos.com."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[DELETE_STORY_ID] = [
				MESSAGE_MODAL_TYPE,
				"Remove Story?",
				["Are you sure you want to remove \"#story_name#\" from your device? Don't worry. You can always download it again."],
				[
					{text:"CANCEL",
						id:CANCEL_BTTN_ID
					},
					{text:"REMOVE",
						id:OK_BTTN_ID
					}
				]
			];
			_data[DELETE_STORIES_ID] = [
				MESSAGE_MODAL_TYPE,
				"Remove All Stories",
				["Are you sure you want to remove all stories from your device? Don't worry. You can always download them again."],
				[
					{text:"CANCEL",
						id:CANCEL_BTTN_ID
					},
					{text:"REMOVE ALL",
						id:OK_BTTN_ID
					}
				]
			];
			_data[NETWORK_ERROR_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["There was a problem connecting to Speakaboos. Check your Internet connection or try again in a few minutes."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[SUBSCRIPTION_SUCCEEDED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Congratulations",
				["You’ve successfully subscribed to the Speakaboos app."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[SUBSCRIPTION_FAILED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We're unable to complete your purchase. Please contact customer service. #message#"], 
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[SUBSCRIPTION_APP_STORE_FAILED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["The App Store could not complete your purchase.  Please try again later."], 
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[SUBSCRIPTION_APP_STORE_DOWN_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We are unable to connect to the App Store to complete your purchase.  Please try again later."], 
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[SUBSCRIPTION_PROD_FAILED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We’re unable to load the subscriptions at this time. Please try again later."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[SUBSCRIPTION_REQUIRED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Subscription",
				["Sorry, only 3 titles are available without a paid subscription"],
				[
					{text:"SUBSCRIBE",
						id:SUBSCRIBE_ID
					},
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			"", "S"
			_data[ERROR_RESTORE_PURCHASES_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We’re unable to restore your purchase at this time. Please try again later."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[RESTORE_PURCHASES_SUCCEEDED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Congratulations",
				["Your purchase has been successfully restored."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[RESTORE_PURCHASES_EMPTY_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops, That's Not Right",
				["According to our records, there are no purchases to restore."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[FACEBOOK_FAILED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Facebook Error",
				["An error occurred while trying to re-authenticate with Facebook."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			//"ERROR", "Facebook Login Not Supported On this platform"
			_data[FACEBOOK_FAILED_GEN_ID] = [
				MESSAGE_MODAL_TYPE,
				"Facebook Error",
				["Sorry, a facebook related error occurred."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[ITUNES_FAILED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We’re unable to connect to the App Store at this time. Please try again later."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[COMPLETE_ACCOUNT_FAILED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We’re unable to complete your account at this time. Please try again later."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[NEED_CONNECTION_ID] = [
				MESSAGE_MODAL_TYPE,
				"You're Not Connected",
				["It looks like you aren't online, so we've switched to Offline Mode so you can still access your downloaded stories. When you can, get back online to regain full access to Speakaboos."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[ERROR_STORY_LOAD_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["We’re unable to load the story at this time. Please try again later."],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			_data[ERROR_MISC_ID] = [
				MESSAGE_MODAL_TYPE,
				"Oops",
				["#message#"],
				[
					{text:"OK",
						id:OK_BTTN_ID
					}
				]
			];
			
			_data[DEBUG_LOG_ID] = [
				DEBUG_LOG_TYPE,
				1,
				"Debug Log",
				["spe version: #spe_version#, services: #app_services#, release type: #app_release_type#"],
				null,
				[
					{text:"Check Update",
						id:HOME_BTTN_ID
					},
					{text:"Clear Log",
						id:CLEAR_BTTN_ID
					},
					{text:"Debug",
						id:DEBUG_BTTN_ID
					},
					{text:"Test Modals",
						id:TEST_MODALS_BTTN_ID
					}
				],
				null,
				{
					id: "log_field",
					clss: TextFieldScroller
				}
			];
			_data[LOADER_ID] = [
				LOADER_TYPE,
				1,
				"",
				null,
				null,
				[
					{
						id:OK_BTTN_ID,
						clss:CoreButton
					}
				]
			];
			_data[SUBSCRIPTION_EXPIRED_ID] = [
				MESSAGE_MODAL_TYPE,
				"Subscription Expired",
				["Your subscription has expired. For continued access to your downloaded stories and the complete Speakaboos library, renew your subscription today."],
				[
					{text:"CANCEL",
						id:CANCEL_BTTN_ID
					},
					{text:"RENEW",
						id:OK_BTTN_ID
					}
				]
			];
			_data[TRIAL_OVER_BLOCKER_ID] = [
				MESSAGE_MODAL_TYPE,
				"Your Trial is Over",
				["We hope you’ve enjoyed your free preview of the Speakaboos app. Join today for access to one of the largest libraries of children’s stories!"],
				[
					{text:"SIGN IN",
						id:CANCEL_BTTN_ID
					},
					{text:"JOIN",
						id:OK_BTTN_ID
					}
				]
			];
			
			
			return _data;
		}
	}
}