package com.inyc.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextButton extends MCButton
	{
		protected var _tf:TextField;
		protected var _fmt:TextFormat;
		protected var _bg:MovieClip;
		
		public function TextButton(text:String, bgColor:int, width:int, height:int)
		{
			super();
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
		}
	}
}