﻿package com.speakaboos.ipad.models.data{		import com.speakaboos.ipad.BaseClass;
	import com.speakaboos.ipad.models.services.CoreService;
	import com.speakaboos.ipad.utils.FileUtil;
	
	import flash.display.BitmapData;	public class Story extends BaseClass	{		public var id:int;		public var name:String;		public var slug:String;		public var title:String;		public var shortTitle:String;		public var assets:String;				public var categories:Array;		public var modes:Array;		public var bgColor:String;				public var thumbnail:String;		public var storyIcon:String;		public var lowResIcon:BitmapData;		public var highResIcon:BitmapData;				public var storyType:String;		public var freeStory:int;		public var saved:Boolean;		public var storyDisabled:Boolean;		public var isPromo:Boolean = false;		public var inOfflineMode:Boolean = false;								public function Story(data:Object = null){			if (data) setData(data);		}						public function setData(data:Object):void{			//log("setData");			//log(data);						id = data.id;			slug = data.slug;			name = data.slug;			title = data.title;			shortTitle = data.short_title;						storyIcon = data.story_icon;			thumbnail = data.thumbnail;						categories = data.categories;			modes = data.modes;			storyType = data.story_type;			var bgColorString:String = "0x" + data.loadingScreenBGColor;			bgColor = bgColorString; 			assets = data.assets;			if (data.isPromo != null) isPromo = data.isPromo;			inOfflineMode = Boolean(data.inOfflineMode);		}				public function reset():void {			id = 0;			slug = null;			name = null;			title = null;			shortTitle = null;						storyIcon = null;			thumbnail = null;			if (categories) categories.length = 0;			categories = null;			if (modes) modes.length = 0;			modes = null;			storyType = null;			bgColor = null; 			assets = null;			if (lowResIcon) lowResIcon.dispose();			lowResIcon = null;			if (highResIcon) highResIcon.dispose();			lowResIcon = null;			inOfflineMode = false;		}		public function get dataLocation():String{			var dataLoc:String;			if (saved==true){				dataLoc = FileUtil.getCacheDir(true, "/stories/"+slug+"/storyManifest.json").url;			}else{				dataLoc = CoreService.getBaseURL() + "?method=getStory&format=json&slug="+slug;			}						log("*** RETURN DATA LOCATION: "+dataLoc);			return dataLoc;		}		//		public function destroy():void{//			lowResIcon = null;//			highResIcon = null;//		}			}}