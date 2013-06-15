package com.speakaboos.ipad.models.data
{
	public class FileUrlInfo
	{
		public static const LOC_BUNDLE:String = "bundle";
		public static const LOC_APP_STORAGE:String = "appStorage";
		public static const LOC_WEB:String = "web";
		public static const LOC_INTERNAL:String = "internal";
		private static const locTypes:Array = [LOC_BUNDLE, LOC_APP_STORAGE, LOC_WEB, LOC_INTERNAL];
		private static const DATE_PARTS_COUNT:uint = 4;
		private static const DATE_PARTS_DELIM:String = "-";
		private static const FILE_DELIM:String = "/";
		private static const LINKAGE_DELIM:String = "_";
		private static const FILETYPE_DELIM:String = ".";
		
		public var name:String;
		public var date:String;
		public var type:String;
		public var path:String;
		private var _location:int = -1;
		private var _linkage:String;
		
		public function set fullName(str:String):void {
			var n:int;
			var tempDtAry:Array;
			var tempAry:Array = str.split(".");
			name = null;
			if (tempAry.length == 2) {
				type = tempAry[1];
				tempAry = tempAry[0].split(DATE_PARTS_DELIM);
				n = tempAry.length;
				if (n > DATE_PARTS_COUNT) {
					tempDtAry = tempAry.splice(n - DATE_PARTS_COUNT, DATE_PARTS_COUNT);
					name = tempAry.join(DATE_PARTS_DELIM);
					date = tempDtAry.join(DATE_PARTS_DELIM);
				} else {
					name = tempAry.join(DATE_PARTS_DELIM);
				}
			}
		}
		public function get fullName():String {
			var result:String;
			if (name && type) {
				result = name + (date? DATE_PARTS_DELIM + date : "") + FILETYPE_DELIM + type;
			}
			return result;
		}
		
		public function get valid():Boolean {
			return Boolean( name);
		}
		
		public function get location():String {
			var result:String;
			if (_location > -1) result = locTypes[_location];
			return result;
		}
		public function set location(val:String):void {
			_location = locTypes.indexOf(val);
		}
		
		public function set url(str:String):void {
			// TODO: save the beginning of the URL?
			var tempAry:Array = str.split(FILE_DELIM);
			var n:int = tempAry.length;
			fullName = tempAry.pop();
			path = tempAry.pop() + FILE_DELIM;
		}
		
		public function get linkage():String {
			return _linkage;
		}
		
		public function set linkage(str:String):void {
			_linkage = str;
			var tempAry:Array = str.split(LINKAGE_DELIM+LINKAGE_DELIM);
			path = tempAry[0] + FILE_DELIM;
			tempAry = tempAry[1].split(LINKAGE_DELIM);
			type = tempAry.pop();
			fullName = tempAry.join(DATE_PARTS_DELIM) + FILETYPE_DELIM + type;
			location = LOC_INTERNAL;
		}
		
		public function get key():String {
			var result:String = name;
			return result;
		}
		
		public function setData(_url:String = "", loc:String = ""):void {
			if (_url) url = _url;
			if (loc) location = loc;
		}
		
		public function reset():void {
			name = null;
			date = null;
			type = null;
			path = null;
			_location = -1;
			_linkage = null;
		}
		
		public function FileUrlInfo(_url:String = "", loc:String = "") {
			setData(_url, loc);
			//super();
		}
	}
}