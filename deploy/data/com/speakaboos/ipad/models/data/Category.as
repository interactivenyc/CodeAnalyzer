package com.speakaboos.ipad.models.data
{
	import com.speakaboos.ipad.BaseClass;

	public class Category extends BaseClass
	{
		
		public var slug:String;
		public var title:String;
		public var short_title:String;
		public var home_screen_category_icon:String;
		public var category_screen_category_icon:String;
		public var story_screen_category_icon:String;
		public var category_screen_page_color:String;
		public var category_screen_text_color:String;
		public var category_title_audio:String;
		public var category_welcome_audio:String;
		public var position:String;
		public var home_screen_wheel_icon:String;
		public var popup_animation_audio:String;
		public var main_animation_audio:String;
		public var thumbnail:String;
		public var savedStories:Object;
		public var storySlugs:Array;
		
		public function get savedStoryCount():int {
			var result:int = 0;
			for (var slug:String in savedStories) if (savedStories[slug]) result++;
			return result;
		}
		
		public function Category(data:Object = null){
		
			if (data) {
				//log(data)
				
				slug = data.slug;
				title = data.title;
				short_title = data.short_title;
				home_screen_category_icon = data.home_screen_category_icon;
				category_screen_category_icon = data.category_screen_category_icon;
				story_screen_category_icon = data.story_screen_category_icon;
				category_screen_page_color = data.category_screen_page_color;
				category_screen_text_color = data.category_screen_text_color;
				category_title_audio = data.category_title_audio;
				category_welcome_audio = data.category_welcome_audio;
				position = data.position;
				home_screen_wheel_icon = data.home_screen_wheel_icon;
				popup_animation_audio = data.popup_animation_audio;
				main_animation_audio = data.main_animation_audio;
				thumbnail = data.thumbnail;
				savedStories = {};
				storySlugs = [];
			}
		}
		
		public function reset():void {
			title = null;
			short_title = null;
			home_screen_category_icon = null;
			category_screen_category_icon = null;
			story_screen_category_icon = null;
			category_screen_page_color = null;
			category_screen_text_color = null;
			category_title_audio = null;
			category_welcome_audio = null;
			position = null;
			home_screen_wheel_icon = null;
			popup_animation_audio = null;
			main_animation_audio = null;
			thumbnail = null;
			for (slug in savedStories) {
				delete savedStories[slug];
			}
			savedStories = null;
			if (storySlugs) storySlugs.length = 0;
			slug = null;
			storySlugs = null;
		}
	}
}