package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	import com.speakaboos.ipad.view.holders.CoreDisplayObjectHolder;
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	//Glue class for subclips with buttons as children
	public class ButtonGroup extends CoreMovieClipHolder
	{
		public function ButtonGroup(_view:MovieClip)
		{
			log("constructor");
			super(_view);
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams(CoreDisplayObjectHolder.DEFAULT_NAME, null, childClicked)
				]));
		}
		
		public function childClicked(child:DisplayObject):void
		{
			log("childClicked "+child.name);
			if (parentHolder) parentHolder.grandchildClicked(this, child);
			else log("childClick called with no parentHolder set");
		}
	}
}