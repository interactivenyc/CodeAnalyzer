package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.events.GenericDataEvent;
	import com.speakaboos.ipad.events.ModalEvents;
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.models.data.TextEntryInfo;
	import com.speakaboos.ipad.utils.HtmlTextUtil;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class LabeledTextEntry extends CoreMovieClipHolder
	{
		public var label:TextField;
		public var entry:CoreInputText;
		public var type:String;
		
		public function LabeledTextEntry(_view:MovieClip)
		{
			super(_view);
		}
		
		override public function setInfo(info:Object):void {
			log("setInfo ", info);
			var tei:TextEntryInfo = info.info as TextEntryInfo;
			type = tei.type;
			setupChildren(Vector.<HolderChildParams>([
				new HolderChildParams("label"),
				new HolderChildParams("entry", CoreInputText)
			]));
			HtmlTextUtil.setFieldText(label, tei.label);
			entry.prompt = tei.prompt;
			entry.displayAsPassword = (type === TextEntryInfo.PASSWORD_TYPE);
		}
		
		override public function getData():Object {
			return entry.text;
		}
	}
}