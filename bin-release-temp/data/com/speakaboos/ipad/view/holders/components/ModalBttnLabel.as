package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.utils.HtmlTextUtil;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	
	import flash.display.MovieClip;
	
	public class ModalBttnLabel extends CoreMovieClipHolder
	{
		public function ModalBttnLabel(_view:MovieClip)
		{
			super(_view);
		}
		
		override public function setInfo(info:Object):void {
			super.setInfo(info);
			var id:String = info.id || mc.name;
			if (id) mc.id = id; //TODO would rather put this in the holder, but it is not instiated yet...
			if (mc.text &&  mc.text.label) {
				HtmlTextUtil.setFieldText(mc.text.label, info.text, HtmlTextUtil.BUTTON);
			}
		}
	}
}