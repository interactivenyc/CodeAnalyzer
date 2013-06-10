package com.speakaboos.ipad.view.components
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TextFieldScroller extends MovieClip
	{
		private static const MIN_SB_HEIGHT:int = 4;
		private static const SB_WIDTH:int = 4;
		private static const SB_ROUNDED:int = 6;
		private static const SB_COLOR:uint = 0x555555;
		private static const SB_ALPHA:Number = 0.8;
		private static const SB_FADE_DURATION:Number = 0.5;
		
		private var _textField:TextField;
		private var _scrollBar:MovieClip;
		private var _lastScrollV:int;
		private var _dragStartTime:Number;
		private var _dragStartY:int;
		
		public function set text(str:String):void {
			_textField.text = str;
			redrawScrollBar();
		}
		
		public function set htmlText(str:String):void {
			_textField.htmlText = str;
			redrawScrollBar();
		}
		
		public function TextFieldScroller(tf:TextField)
		{
			super();
			init(tf);
		}
		
		private function init(tf:TextField):void {
			x = tf.x;
			tf.x = 0;
			y = tf.y;
			tf.y = 0;
			addChild(tf);
			_textField = tf;
			_lastScrollV = _textField.scrollV;
			_scrollBar = new MovieClip();
			addChild(_scrollBar);
			_scrollBar.x = _textField.width - SB_WIDTH - 1;
			_scrollBar.y = 0;
			redrawScrollBar();
			_scrollBar.alpha = 0;
			_textField.addEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart,false,0,true);
		}
		
		private function redrawScrollBar():void {
			var textHeight:Number = _textField.textHeight;
			var containerHeight:Number = _textField.height;
			var h:Number = containerHeight * containerHeight / textHeight;
			if (textHeight < containerHeight) h = containerHeight;
			if (h < MIN_SB_HEIGHT) h = MIN_SB_HEIGHT;		
			_scrollBar.graphics.clear();
			_scrollBar.graphics.beginFill(SB_COLOR, SB_ALPHA);
			_scrollBar.graphics.drawRoundRect(0, 0, SB_WIDTH, h, SB_ROUNDED, SB_ROUNDED);
			_scrollBar.graphics.endFill();
		}
		
		private function updateScrollBar():void {
			var barMaxDistance:Number = _textField.height - _scrollBar.height;
			_scrollBar.y = (_textField.scrollV / _textField.maxScrollV) * barMaxDistance;	
			if (_scrollBar.y > barMaxDistance) {
				//TODO: animate bar hitting bottom
			}
			//pulling down
			if (_scrollBar.y < 1) {
				//TODO: animate bar hitting top
				_scrollBar.y = 0;
			}
		}
		
		private function hideScrollBar():void {
			showScrollbar(false);
		}
		
		private function showScrollbar(show:Boolean = true):void {
			TweenMax.killTweensOf(_scrollBar);
			TweenMax.killTweensOf(_textField);
			if (_textField.textHeight < _textField.height) {
				_scrollBar.alpha = 0;
			} else {
				TweenMax.to(_scrollBar, SB_FADE_DURATION, {alpha:show ? 1 : 0});
			}
		}
		
		private function onTextDragStart(event:MouseEvent):void
		{
			_textField.removeEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart);
			_textField.addEventListener(MouseEvent.MOUSE_UP, onTextDragEnd,false,0,true);
			_textField.addEventListener(MouseEvent.RELEASE_OUTSIDE, onTextDragEnd,false,0,true);
			_textField.addEventListener(MouseEvent.MOUSE_MOVE, onDragging,false,0,true);
			_dragStartTime = new Date().getTime();
			_dragStartY = stage.mouseY;
			showScrollbar();
		}
		
		protected function onDragging(event:MouseEvent):void
		{
			updateScrollBar();
		}
		
		protected function onTextDragEnd(event:MouseEvent):void
		{
			_textField.removeEventListener(MouseEvent.MOUSE_MOVE, onDragging);
			_textField.removeEventListener(MouseEvent.MOUSE_UP, onTextDragEnd);
			_textField.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onTextDragEnd);
			_textField.addEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart,false,0,true);
			var endTime:Number = new Date().getTime();
			var endY:int = stage.mouseY;
			var d:int = endY - _dragStartY;
			var dt:Number = endTime - _dragStartTime;
			var dur:Number = 1.0; 
			var scrollVEnd:int = _textField.scrollV - int(Math.abs( d) * d / dt / 7);
			TweenMax.to(_textField, dur, {scrollV:scrollVEnd, ease:Quad.easeOut, onComplete:hideScrollBar, onUpdate:updateScrollBar});
		}
	}
}