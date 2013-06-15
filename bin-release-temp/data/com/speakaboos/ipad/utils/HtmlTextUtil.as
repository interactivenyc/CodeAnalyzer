package com.speakaboos.ipad.utils
{
	import flash.text.StyleSheet;
	import flash.text.TextField;

	public class HtmlTextUtil
	{
		public static const TITLE:int = 0;
		public static const BUTTON:int = 1;
		public static const BODY:int = 2;
		public static const LOADED:int = 3;
		public static const textSubDelim:String = "#";
		
		private static var _textSubstitutions:Object;
		
		public static function set textSubstitutions(subs:Object):void {
			for (var prop:String in subs) {
				_textSubstitutions[prop] = subs[prop];
			}
		}
		
		public static function set loadedCss(ss:StyleSheet):void {
			sheets[LOADED] = ss;
		}
		public static function get loadedCss():StyleSheet {
			return sheets[LOADED];
		}
		
		public static var sheets:Vector.<StyleSheet>;
		
		public function HtmlTextUtil(){}
		
		public static function init():void {
			_textSubstitutions = {"":textSubDelim};
			sheets = new Vector.<StyleSheet>(LOADED+1, true);
			var ss:StyleSheet;
			ss = new StyleSheet();
			sheets[TITLE] = ss;
			ss = new StyleSheet();
			ss.setStyle("p", {fontSize:18, marginTop:0});
			ss.setStyle("h2", {fontSize:28, marginTop:5});
			sheets[BUTTON] = ss;
			ss = new StyleSheet();//TODO flesh this out
			//ss.setStyle(".main", {fontSize:14});
			ss.setStyle("h1", {fontSize:28, fontWeight:"bold"});
			ss.setStyle("h2", {fontSize:22, fontWeight:"bold"});
			ss.setStyle("h3", {fontSize:19});
			ss.setStyle("p", {fontSize:15});
			ss.setStyle("small", {fontSize:12});
			ss.setStyle("16pt", {fontSize:16});
			ss.setStyle("17pt", {fontSize:17});
			ss.setStyle("18pt", {fontSize:18});
			ss.setStyle("22pt", {fontSize:22});
			sheets[BODY] = ss;
		}
		
		public static function replaceText(str:String):String {
			var strParts:Array = str.split(textSubDelim);
			for (var i:int = 1; i<strParts.length; i +=2) {
				strParts[i] = _textSubstitutions[strParts[i]];
				if (!strParts[i]) strParts[i] = "";
			}
			return strParts.join("");
		}
		
		public static function setFieldText(fld:TextField, txt:String, type:int = BODY):void {
			// TODO: depending on type, use htmlText and CSS styleSheets to set the text
			if (txt.indexOf(textSubDelim) >= 0) txt = replaceText(txt);
			if (type === TITLE) {
				fld.text = txt; // TODO: maybe set the embedded font through code here from spe font
			} else {
				fld.styleSheet = sheets[type];
				fld.condenseWhite = true;
				fld.htmlText = txt;
			}
		}
	}
}