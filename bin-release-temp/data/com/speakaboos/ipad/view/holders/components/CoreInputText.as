package com.speakaboos.ipad.view.holders.components
{
	
	import com.speakaboos.ipad.view.holders.CoreDisplayObjectHolder;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CoreInputText extends CoreDisplayObjectHolder
	{
		public var tf:TextField;
		private var _displayAsPassword:Boolean = false;
		
		private var _fmt:TextFormat;
		private var _prompt:String;
		
		private static var LIGHT:Number = 0xAAAAAA;
		private static var DARK:Number = 0x11989D;
		
		public function get tabEnabled():Boolean {
			return tf.tabEnabled;
		}
		public function set tabEnabled(val:Boolean):void {
			tf.tabEnabled = val;
		}
		public function get tabIndex():int {
			return tf.tabIndex;
		}
		public function set tabIndex(val:int):void {
			tf.tabIndex = val;
		}
		
		public function CoreInputText(_tf:TextField)
		{
			tf = _tf;
			super(tf as DisplayObject);
			log("constructor: "+name+", "+tf.getTextFormat().font);
		}
		
		override public function onAddedToStage(e:Event = null):void{
			super.onAddedToStage(e);
			tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn,false,0,true);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut,false,0,true);
			
			_fmt = tf.getTextFormat();
			tf.defaultTextFormat = _fmt;
			
			
			tf.text = _prompt;
			tf.border = false;
			setColor(LIGHT);
		}
		
		override public function onRemovedFromStage(e:Event = null):void{
			super.onRemovedFromStage(e);
			tf.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			tf.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		
		private function onFocusIn(e:FocusEvent):void{
			//log("onFocusIn");
			if (tf.text == _prompt){
				tf.text = "";
			}
			setColor(DARK);
			displayAsPassword = _displayAsPassword;
			
		}
		
		private function onFocusOut(e:FocusEvent):void{
			//log("onFocusOut");
			if (tf.text == ""){
				tf.text = _prompt;
				setColor(LIGHT);
				
			}else{
				setColor(DARK);
			}
			
			displayAsPassword = _displayAsPassword;
		}
		
		public function set prompt(prompt:String):void{
			_prompt = prompt;
			tf.text = _prompt;
			displayAsPassword = _displayAsPassword;
			setColor(DARK);

		}
		
		public function get prompt():String{
			return _prompt;
		}
		
		public function set displayAsPassword(value:Boolean):void{
			_displayAsPassword = value;
			if (tf.text == _prompt){
				tf.displayAsPassword = false;
			}else{
				tf.displayAsPassword = _displayAsPassword;
			}
		}
		
		public function get displayAsPassword():Boolean{
			return _displayAsPassword;
		}
		
		private function setColor(color:Number):void{
			//log("setColor field: "+name+ ", color: "+color);
			_fmt = tf.getTextFormat();
			_fmt.color = color;
			tf.setTextFormat(_fmt);
		}
		
		public function get text():String{
			var result:String = tf.text
			if (result === _prompt) result = "";
			return result;
		}
		
	}
}