package com.speakaboos.ipad
{
	import com.speakaboos.ipad.events.CoreEventDispatcher;
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	
	public class CoreEventUser extends BaseClass
	{
		protected var _eventDispatcher:CoreEventDispatcher;
		public function CoreEventUser()
		{
			super();
			_eventDispatcher = CoreEventDispatcher.getInstance();
		}

		public function destroy():void {
			//_eventDispatcher = null;
		}
		
		protected function showLoader():void{
			log("showing loader");
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.SHOW_LOADER));	
		}
		protected function hideLoader():void{
			log("hiding loader");
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.HIDE_LOADER));	
		}
	}
}