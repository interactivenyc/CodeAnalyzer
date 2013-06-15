package com.speakaboos.ipad.events
{
	public class DBEvents
	{
		public static const ON_GET_USER_PROFILE:String = "ON_GET_USER_PROFILE";
		public static const ON_GET_LAST_USER:String = "ON_GET_LAST_USER";
		
		public static const ADD_USER_TO_DB:String = "ADD_USER_TO_DB";
		public static const USER_ADDED_TO_DB:String = "USER_ADDED_TO_DB";
		
		
		public static const STORY_ADDED_TO_DB:String = "STORY_ADDED_TO_DB";
//		public static var FREE_STORIES_ADDED_TO_DB:String = "FREE_STORIES_ADDED_TO_DB";
		
		public static const UPDATE_USER_DB:String = "UPDATE_USER_DB";
		public static const USER_UPDATED_DB:String = "USER_UPDATED_DB";
		
		public static const STORY_RESULTS:String = "STORY_RESULTS";
		public static const SAVED_STORY_RESULTS:String = "SAVED_STORY_RESULTS";
		public static const STORY_COUNT_RETRIEVED:String = "STORY_COUNT_RETRIEVED";
		
		public static const STORY_RETRIEVED:String = "STORY_RETRIEVED";
		
		public static const SAVE_STORY:String = "SAVE_STORY";
//		public static const SAVE_STORY_SUCCESS:String = "SAVE_STORY_SUCCESS"; //not used ATM, using STORY_ADDED_TO_DB to know when to mark a story in memory as saved
		
		public static const DELETE_STORY:String = "DELETE_STORY";
		public static const DELETE_STORY_SUCCESS:String = "DELETE_STORY_SUCCESS";
		public static const DELETE_SAVED_STORIES_SUCCESS:String = "DELETE_SAVED_STORIES_SUCCESS";
		
		public static const UPDATE_SUBSCRIPTION_STATUS:String = "UPDATE_SUSCRIPTION_STATUS";
		public static const SUBSCRIPTION_STATUS_UPDATED:String = "SUBSCRIPTION_STATUS_UPDATED";
		
		
		public function DBEvents(){
		}
	}
}