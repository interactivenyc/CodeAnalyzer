package com.inyc.components
{
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextButton extends MCButton
	{
		protected var _tf:TextField;
		protected var _fmt:TextFormat;
		protected var _bg:MovieClip;
		
		protected var _text:String;
		protected var _bgColor:int;
		protected var _width:int;
		protected var _height:int;
		
		
		public function TextButton(text:String, bgColor:int=0xff6600, width:int=120, height:int=48)
		{
			super();
			_text = text;
			_bgColor = bgColor;
			_width = width;
			_height = height;
		}
		public function set textFormat(fmt:TextFormat):void{
			_fmt = fmt;
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			_bg = MovieClipUtils.getFilledMC(_width,_height,_bgColor,true);
			addChild(_bg);
			
			_tf = new TextField();
			_tf.width = _width;
			_tf.height = _height;
			_tf.text = _text;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			
			if (_fmt == null){
				_fmt = _tf.getTextFormat();
				_fmt.font = "_sans";
				_fmt.bold = true;
				_fmt.align = "center";
			}else{
				_tf.defaultTextFormat = _fmt;
			}
			
			_tf.setTextFormat(_fmt);
			addChild(_tf);
		}
	}
}