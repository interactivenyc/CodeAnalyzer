package com.speakaboos.ipad.events
{
	import com.speakaboos.ipad.models.services.CacheDataService;
	
	public class SpeakaboosServiceEvents
	{
		
		
//		public static var FREE_STORIES_LOADED:String = "FREE_STORIES_LOADED";
		
//		public static var CATEGORIES_LOADED:String = "CATEGORIES_LOADED";
		
//		public static var LOAD_STORIES_BY_CATEGORY:String = "LOAD_STORIES_BY_CATEGORY";
		public static var STORIES_LOADED:String = "STORIES_LOADED";
		
		public static var LOAD_STORY:String = "LOAD_STORY";
		public static var LOAD_RELATED_STORY:String = "LOAD_RELATED_STORY";
		
		public static var TERMS_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.TERMS_OF_USE_SLUG;
		public static var PRIVACY_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.PRIVACY_POLICY_SLUG;
		public static var MANAGE_YOUR_ACCOUNT_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.MANAGE_YOUR_ACCOUNT_SLUG;
		public static var HELP_FAQS_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.HELP_FAQS_SLUG;
		public static var SPEAKABOOS_STORY_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.SPEAKABOOS_STORY_SLUG;
		public static var CAST_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.CAST_SLUG;
		public static var CSS_STYLESHEET_LOADED:String = CacheDataService.GENERIC_DATA_METHOD + CacheDataService.CSS_STYLESHEET_SLUG;
		
		public function SpeakaboosServiceEvents(){
			
			
		}
	}
}