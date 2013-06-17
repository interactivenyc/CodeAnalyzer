package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	
	import flash.utils.getDefinitionByName;
	

	public class Toolbar extends CoreMovieClip
	{
		public var toolbar:Toolbar_MC;
		public var btn_select:BasicButton;
		
		public function Toolbar(){
			toolbar = new Toolbar_MC;
			addChild(toolbar);
			toolbar.x = toolbar.y = 10;
			
			
//			var buttons:Array = new Array();
//			var button:BasicButton;
//			//button
//			btn_select = new BasicButton();
//			var classDef:Class = BasicButton;
//			classDef.prototype = btn_select;
//			addChild(btn_select);
			
		}
	}
}