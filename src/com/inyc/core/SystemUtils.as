﻿package com.inyc.core{	import flash.system.Capabilities;		public class SystemUtils	{				private static var _platform:String;		private static var _os:String;				public final function SystemUtils(){}						public static function isIOS():Boolean{			/*				detection for ios platform			*/			return (platform == "IOS");		}				public static function isAppleIOS():Boolean{			/*				IOS dectection, excluding FB Simulator				Note: Will return true for XCode iOS Simulator			*/			return (isIOS() && !isFbIosSimulator());		}				public static function isFbIosSimulator():Boolean{			/*				detection for Flash Builder IOS simulator			*/			return (platform == "IOS" &&  (os == "Mac" || os == "Windows"));		}						public static function get platform():String{			/*				return "WIN", "MAC", "IOS", "AND", etc			*/						if(_platform)				return _platform;						_platform = getFirstWord(Capabilities.version);						return _platform;					}				public static function get os():String{			/*				returns "Windows", "Mac", "iPhone", etc			*/						if(_os)				return _os;						_os = getFirstWord(Capabilities.os);						return _os;				}				public static function compareVersionStrings(v1:String, v2:String):int {			var result:int = 0			if (v1 !== v2) { 				var av1:Array = v1.split(".");				var av2:Array = v2.split(".");				var i:int = av2.length, n:int = av1.length;				// make the version arrays the same length				if (i > n) {					n = i;					i = i - n;					while (i--) av1.push("0");				} else {					i = n - i;					while (i--) av2.push("0");				}				for (i = 0; i < n; i++) {					if (int(av1[i]) > int(av2[i])) {						result = 1;						break;					} else if (int(av1[i]) < int(av2[i])) {						result = -1;						break;					}				}			}			return result;		}		// String helper		private static function getFirstWord( s : String ) : String		{			var i:int = s.indexOf(" ");			var len:uint = (i>0) ? i : s.length;			return s.substring(0, len);		}			}}