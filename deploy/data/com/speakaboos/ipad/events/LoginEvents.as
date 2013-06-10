package com.speakaboos.ipad.events
{
	public class LoginEvents
	{
		
		//LOGIN SERVICE EVENTS
		public static const INIT_LOGIN:String = "INIT_LOGIN";	
		
		public static const LOGIN:String = "LOGIN";	
		public static const USER_LOGGED_IN:String = "USER_LOGGED_IN";
		public static const LOGIN_ERROR:String = "LOGIN_LOGIN_ERROR";
		
		//to differentiate b/w logging out locally (clearing out local db) and logging out of the server
		//Check AppEvents for events related to logging out locally
		public static const USER_LOGGED_OUT:String = "SERVER_LOGGED_OUT"; 
		public static const LOGOUT_ERROR:String = "SERVER_LOGOUT_ERROR";
		
		public static const ANONYMOUS_USER_LOGGED_IN:String = "ANONYMOUS_USER_LOGGED_IN";
		
		public static const SIGNUP:String = "SIGNUP";
		public static const USER_SIGNED_UP:String = "USER_SIGNED_UP";
		public static const SIGNUP_ERROR:String = "SIGNUP_ERROR";
		
		public static const FB_LOGIN:String = "FB_LOGIN";
		public static const FB_LOGGED_IN:String = "FB_LOGGED_IN";
		public static const FB_USER_AUTHENTICATED:String = "FB_USER_AUTHENTICATED";
		public static const FB_LOGIN_FAILED:String = "FB_LOGIN_FAILED";
		
		public static const FB_SIGNUP:String = "FB_SIGNUP";
		public static const FB_SIGNED_UP:String = "FB_SIGNED_UP";
		
		public static const FORGOT_PASSWORD:String = "FORGOT_PASSWORD";
		public static const CREATE_SUBSCRIPTION:String = "CREATE_SUBSCRIPTION";
		public static const FORGOT_PASSWORD_SENT:String = "FORGOT_PASSWORD_SENT";
		public static const FORGOT_PASSWORD_ERROR:String = "FORGOT_PASSWORD_ERROR";
		
		public static const UPDATE_USER_SUCCEEDED:String = "UPDATE_USER_SUCCEEDED";
		public static const UPDATE_USER_FAILED:String = "UPDATE_USER_FAILED";
		
		
	}
}