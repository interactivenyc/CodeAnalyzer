package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.models.data.ModalsInfo;
	import com.speakaboos.ipad.models.data.Story;
	import com.speakaboos.ipad.utils.HtmlTextUtil;
	
	import flash.display.MovieClip;

	public class ListingsItem extends ListingsItemBase
	{
		public var bttn_delete: ModalBttn;
		
		public function ListingsItem(){
			super(new StoryListingItemMC());
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("bttn_delete", ModalBttn, bttnClicked)
			]));
			bttn_delete.setInfo( {id:ModalsInfo.DELETE_STORY_ID, text: "Remove"});
		}
		
		private function bttnClicked(bttn:MovieClip):void {
			HtmlTextUtil.textSubstitutions = {"story_name": _listingsData.shortTitle || _listingsData.title};
//			(parentHolder as ManageStoriesPanel).selectedStory  = _listingsData;
			
			_eventDispatcher.dispatchEvent(new GenericDataEvent(LISTINGS_ITEM_DELETE_CLICKED, _listingsData));
			_eventDispatcher.dispatchEvent(new GenericDataEvent(ModalEvents.MODAL_BTTN_CLICKED, {bttn_id: bttn.id}));
		}
		
	}
}