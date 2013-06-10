﻿package com.speakaboos.ipad.view.holders.components{	import com.speakaboos.ipad.events.GenericDataEvent;	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;		import flash.display.MovieClip;	import flash.events.Event;	public class ProgressBar extends CoreMovieClipHolder //Abstract class, must be subclassed with specifics	{		public static const UPDATE_PROGRESS:String = "UPDATE_PROGRESS";		public static const COMPLETED_TYPE:int = 2;		public static const TOTAL_TYPE:int = 1;		public static const CONTRIBUTION_TYPE:int = 0;		protected var _progStats:Array;		private var _progress:Number;		public function set progress(val:Number):void {			if (val < 0) val = 0;			if (val > 1) val = 1;			if (val == 0 || val > _progress) { //never have the progress bar receed unless being reset				_progress = val;				var fr:int = int(val * (mc.totalFrames - 1)) + 1;				mc.gotoAndStop(fr);			}		}		public function get progress():Number {			return _progress;		}				public function ProgressBar(pMc:MovieClip) {			super(pMc);			_eventDispatcher.addEventListener(UPDATE_PROGRESS, onUpdate);		}				protected function initProgStats(progList:Array):void {			var i:int, n:int = progList.length;			_progStats = new Array(n);			var total:int = 0;			for (i=0; i<n; i++) {				total += progList[i];			}			for (i=0; i<n; i++) {				_progStats[i] = [progList[i] / total, 0, 0];			}			progress = 0;		}		protected function updateProgress(index:int, type:int, val:int):void {			_progStats[index][type] = val;			if (_progStats[index][TOTAL_TYPE] && (_progStats[index][COMPLETED_TYPE] > _progStats[index][TOTAL_TYPE])) {				_progStats[index][COMPLETED_TYPE] = _progStats[index][TOTAL_TYPE];			}			var prog:Number = 0;			for (var i:int = 0; i< _progStats.length; i++) {				if (_progStats[i][TOTAL_TYPE]) prog += _progStats[i][CONTRIBUTION_TYPE] * _progStats[i][COMPLETED_TYPE] / _progStats[i][TOTAL_TYPE];			}			progress = prog;		}				private function removeListeners():void {			_eventDispatcher.removeEventListener(UPDATE_PROGRESS, onUpdate);		}				private function onUpdate(event:GenericDataEvent):void {			var info:Object = event.data;			if (info) {				var index:int = info.index;				var type:int = info.type;				var val:int = info.val;				if (info.increment) {					val += _progStats[index][type];				}				updateProgress( index, type, val);			}		}				override public function destroy():void {			for (var i:int=0; i<_progStats.length; i++) {				_progStats[i] = null;			}			removeListeners();			super.destroy();		}	}}