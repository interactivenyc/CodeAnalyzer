package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.events.AppEvents;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.models.services.NetworkMonitor;
	import com.speakaboos.ipad.utils.ColorUtil;
	
	import flash.filters.ColorMatrixFilter;

	public class LogButton extends MCButton
	{
		private var _showLog:Function;
		private var _statusColorFilter:ColorMatrixFilter;
		private var _onlineColorFilters:Array;
		private var _offlineColorFilters:Array;
		
		public function LogButton(showLog:Function)
		{
			super(new LogButtonMC());
			init();
			_showLog = showLog
		}
		
		override public function press(immediate:Boolean = false):void {
			_showLog();
		}
		
		private function init():void {
			x = 105;
			y = 25;
			mc.alpha = .5;
			_statusColorFilter = ColorUtil.getColorMatrixFilterForBCSH();
			var fltrs:Array = mc.filters;
			fltrs.push(_statusColorFilter);
			mc.filters = fltrs;
			_onlineColorFilters = [ColorUtil.getColorMatrixFilterForBCSH(50, 0, 50, -45)];
			_offlineColorFilters = [ColorUtil.getColorMatrixFilterForBCSH(50, 0, 50, 45)];
			_eventDispatcher.addEventListener(AppEvents.NETWORK_STATUS, onNetworkStatusUpdate);
			setNetworkStatus(NetworkMonitor.getInstance().isOnline);
		}
		
		private function setNetworkStatus(isOnline:Boolean):void {
			mc.filters = isOnline ? _onlineColorFilters : _offlineColorFilters;
			log("setNetworkStatus isOnline "+isOnline);
		}
		
		protected function onNetworkStatusUpdate(e:GenericDataEvent):void {
			setNetworkStatus(e.data.isOnline);
		}
		
		override public function destroy():void {
			_eventDispatcher.removeEventListener(AppEvents.NETWORK_STATUS, onNetworkStatusUpdate);
			super.destroy();
		}
	}
}