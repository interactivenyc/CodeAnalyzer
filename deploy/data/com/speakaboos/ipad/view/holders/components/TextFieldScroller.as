package com.speakaboos.ipad.view.holders.components
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class TextFieldScroller extends CoreMovieClipHolder
	{
		public var textField:TextField;

		private static const MIN_SB_HEIGHT:int = 4;
		private static const SB_WIDTH:int = 4;
		private static const SB_ROUNDED:int = 6;
		private static const SB_COLOR:uint = 0x555555;
		private static const SB_ALPHA:Number = 0.8;
		private static const SB_FADE_DURATION:Number = 0.5;
		private static const SCROLL_CHECK_INTERVAL:Number = 100;
		private static const DRAG_POS_COUNT:int = 5;
		
		private var _scrollBar:MovieClip;
		private var _lastScrollV:int;
		private var _dragStartTime:Number;
		private var _dragStartY:int;
		private var _avgLineHeight:Number;
		private var _scrollVPixels:Number;
		private var _dragTimer:Timer;
		private var _dragPositionQueue:Vector.<Number>;
		private var _dragPositionIndex:int;
		
		public function set text(str:String):void {
			textField.text = str;
			redrawScrollBar();
		}
		
		public function set htmlText(str:String):void {
			textField.htmlText = str;
			redrawScrollBar();
		}
		
		public function TextFieldScroller(pMc:MovieClip)
		{
			super(pMc);
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("textField")
			]));
			init();
		}
		
		private function init():void {
//			x = textField.x;
//			textField.x = 0;
//			y = textField.y;
//			textField.y = 0;
			_lastScrollV = textField.scrollV;
			_scrollBar = new MovieClip();
			mc.addChild(_scrollBar);
			_scrollBar.x = textField.width - SB_WIDTH - 1;
			_scrollBar.y = 0;
			text = "Loading...";
			_scrollBar.alpha = 0;
			_dragPositionQueue = new Vector.<Number>(DRAG_POS_COUNT, true);
			textField.addEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart,false,0,true);
			_dragTimer = new Timer(SCROLL_CHECK_INTERVAL);
		}
		
		public function scrollToBottom():void {
			textField.scrollV = textField.maxScrollV;
		}
		
		public function redrawScrollBar():void {
			var textHeight:Number = textField.textHeight;
			var containerHeight:Number = textField.height;
			var h:Number = containerHeight * containerHeight / textHeight;
			if (textHeight < containerHeight) h = containerHeight;
			if (h < MIN_SB_HEIGHT) h = MIN_SB_HEIGHT;		
			_scrollBar.graphics.clear();
			_scrollBar.graphics.beginFill(SB_COLOR, SB_ALPHA);
			_scrollBar.graphics.drawRoundRect(0, 0, SB_WIDTH, h, SB_ROUNDED, SB_ROUNDED);
			_scrollBar.graphics.endFill();
		}
		
		private function updateScrollBar():void {
			var barMaxDistance:Number = textField.height - _scrollBar.height;
			_scrollBar.y = (textField.scrollV / textField.maxScrollV) * barMaxDistance;	
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
			TweenMax.killTweensOf(textField);
			if (textField.textHeight < textField.height) {
				_scrollBar.alpha = 0;
			} else {
				TweenMax.to(_scrollBar, SB_FADE_DURATION, {alpha:show ? 1 : 0});
			}
		}
		
		private function onTextDragStart(event:MouseEvent):void
		{
			_dragPositionIndex = 0;
			var i:int = _dragPositionQueue.length;
			while (i--) _dragPositionQueue[i] = 0;
			textField.removeEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart);
			_dragTimer.addEventListener(TimerEvent.TIMER, onDragging, false, 0, true);
			_dragTimer.start();
			_avgLineHeight = (textField.textHeight - textField.height) / textField.maxScrollV;
			_scrollVPixels = textField.scrollV * _avgLineHeight;
			_dragStartY = stage.mouseY;
			onDragging(); //needs to be called at least once
			showScrollbar();
			textField.addEventListener(MouseEvent.MOUSE_UP, onTextDragEnd,false,0,true);
			textField.addEventListener(MouseEvent.RELEASE_OUTSIDE, onTextDragEnd,false,0,true);
		}
		
		protected function onDragging(event:TimerEvent = null):void
		{
			var sy:Number = stage.mouseY;
			_dragPositionQueue[_dragPositionIndex] = sy;
			_dragPositionIndex = (_dragPositionIndex + 1) % DRAG_POS_COUNT; // fill in values on a rotating index so we keep the last number of them
			_scrollVPixels += (_dragStartY - sy);
			textField.scrollV = int(_scrollVPixels / _avgLineHeight + 0.5);
			_dragStartTime = new Date().getTime();
			_dragStartY = sy;
			updateScrollBar();
		}
		
		protected function onTextDragEnd(event:MouseEvent):void
		{
			_dragTimer.stop();
			_dragTimer.removeEventListener(TimerEvent.TIMER, onDragging);
			textField.removeEventListener(MouseEvent.MOUSE_UP, onTextDragEnd);
			textField.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onTextDragEnd);
			textField.addEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart,false,0,true);
			var endTime:Number = new Date().getTime();
			var dt:Number;
			var d:Number;
			var endY:Number = stage.mouseY;
			var oldY:Number;
			var i:int = 0;
			while (!oldY) oldY = _dragPositionQueue[(_dragPositionIndex + (++i)) % DRAG_POS_COUNT];
			if (oldY) {
				dt = endTime - _dragStartTime + SCROLL_CHECK_INTERVAL * (DRAG_POS_COUNT - i);
				d = endY - oldY;
			} else {
				dt = endTime - _dragStartTime;
				d = endY - _dragStartY;
			}
			var dur:Number = 1.0; 
			var scrollVEnd:int = textField.scrollV - int(Math.abs( d) * d / dt / 4);
			TweenMax.to(textField, dur, {scrollV:scrollVEnd, ease:Quad.easeOut, onComplete:hideScrollBar, onUpdate:updateScrollBar});
		}
		
		override public function destroy():void {
			if (_dragTimer) {
				_dragTimer.reset();
				_dragTimer.removeEventListener(TimerEvent.TIMER, onDragging);
				_dragTimer = null;
			}
			//			textField.removeEventListener(MouseEvent.MOUSE_MOVE, onDragging);
			textField.removeEventListener(MouseEvent.MOUSE_UP, onTextDragEnd);
			textField.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onTextDragEnd);
			textField.removeEventListener(MouseEvent.MOUSE_DOWN, onTextDragStart);
			
			super.destroy();
		}
	}
}