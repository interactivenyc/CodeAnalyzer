package com.speakaboos.ipad.view.holders.components
{
	import com.speakaboos.ipad.models.data.HolderChildParams;
	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;
	
	import flash.display.MovieClip;
	
	public class LabeledTextEntries extends CoreMovieClipHolder
	{
		private static const CHILD_BASE_NAME:String = "entry";
		private static const NAME_DELIM:String = "_";
		
		public function LabeledTextEntries(_view:MovieClip)
		{
			super(_view);
		}
		
		override public function setInfo(info:Object):void {
			log("setInfo ", info);
			var lst:Array = info.infoLst;
			var i:int,n:int = lst.length;
			var holderData:Vector.<HolderChildParams> = new Vector.<HolderChildParams>();
			for (i = 0; i<n; i++) {
				holderData.push(new HolderChildParams(CHILD_BASE_NAME + NAME_DELIM + i, {clss:LabeledTextEntry, info:lst[i]}));
			}
			setupChildren(holderData);
			
		}
		
		override public function getData():Object {
			var result:Array = [];
			var nameParts:Array;
			for (var nm:String in childInfoLookUp) {
				nameParts = nm.split(NAME_DELIM);
				if (nameParts[0] === CHILD_BASE_NAME) {
					result[int(nameParts[1])] = getHolderFromChild(nm).getData() as String;
				}
			}
			return result;
		}
	}
}