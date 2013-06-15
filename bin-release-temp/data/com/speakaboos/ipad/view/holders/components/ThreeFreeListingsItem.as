package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.models.data.HolderChildParams;

	public class ThreeFreeListingsItem extends ListingsItemBase
	{
		public function ThreeFreeListingsItem(){
			super(new ThreeFreeListingsItemMC());
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("btn_play", MCButton, null, new GenericDataEvent(LISTINGS_ITEM_PLAY_CLICKED, {listingsItem:this}))
			]));
		}
	}
}