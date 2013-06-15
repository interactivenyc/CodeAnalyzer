package com.speakaboos.ipad.utils {
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.AntiAliasType
	import flash.utils.getDefinitionByName
	
	public class TextFieldSBEmbedUtil
	{
		private static var embedStyles:StyleSheet;
		
		public static function init():void {
			var fc:Class = getDefinitionByName("ArialRoundedMT_main") as Class;
			var regFontName:String = new fc().fontName;
			fc = getDefinitionByName("ArialRoundedMTBold_main") as Class;
			var boldFontName:String = new fc().fontName;
			embedStyles = new StyleSheet();
			
			embedStyles.setStyle(".main", {fontSize:16, fontFamily:regFontName});
			embedStyles.setStyle(".b", {fontFamily:boldFontName});
			embedStyles.setStyle("h4", {fontSize:18, fontFamily:boldFontName});
			embedStyles.setStyle("small", {fontSize:14});
			
		}
		
		private static function initField(fld:TextField):void {
			if (fld.styleSheet != embedStyles) {
				fld.embedFonts = true;
				fld.antiAliasType = AntiAliasType.ADVANCED;
				fld.sharpness = -100;
				fld.styleSheet = embedStyles;
				fld.condenseWhite = true;
			}
		}
		
		public static function setHtmlText(fld:TextField, html:String):void {
			initField(fld);
			fld.htmlText = html;
		}
	}
}