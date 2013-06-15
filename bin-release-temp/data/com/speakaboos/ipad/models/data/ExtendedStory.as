package com.speakaboos.ipad.models.data
{
	import com.speakaboos.ipad.BaseClass;

	public class ExtendedStory extends BaseClass
	{
		public var slug:String;
		public var title:String;
		public var content_id:String;
		public var short_title:String;
		public var story_desc:String;
		public var loading_screen_bg_color:Number;
		public var by_lines:String;
		public var photo_credits:String;
		public var story_type:String;
		public var credits:String;
		public var cast:String;
		public var co_production_partner:String;
		public var licensor:String;
		public var related_stories:String;
		public var categories:String;
		public var thumbnail:String;
		public var story_icon:String;
		
		public var interactive_json:String;
		public var interactive_zip:String;
		
		public var assets:String;
		public var cover:Object;
		public var modes:Array;
		
		public var status:String;
		
		public function ExtendedStory(){
			//log("constructor");
		}
		
		public function setData(data:Object):void{
			
			slug = data.slug;
			title = data.title;
			content_id = data.content_id;
			short_title = data.short_title;
			story_desc = data.story_desc;
			loading_screen_bg_color = new Number( "0x"+data.loading_screen_bg_color);
			by_lines = data.by_lines;
			photo_credits = data.photo_credits;
			story_type = data.story_type;
			credits = data.credits;
			cast = data.cast;
			co_production_partner = data.co_production_partner;
			licensor = data.licensor;
			related_stories = data.related_stories;
			categories = data.categories;
			thumbnail = data.thumbnail;
			story_icon = data.story_icon;
			
			interactive_json = data.interactive_json;
			interactive_zip = data.interactive_zip;
			
			assets = data.assets;
			cover = data.cover;
			modes = data.modes;
			
			status = data.status;
			
		}
		
		
		
		
	}
}