package com.inyc.codeanalyzer.view
{
	import com.inyc.core.CoreMovieClip;
	
	public class PackageView extends CoreMovieClip{
		private var _classes:Vector.<ClassView> = new Vector.<ClassView>();
		public function PackageView(){
			super();
		}
		
		public function addClass(classView:ClassView):void{
			_classes.push(classView);
			if (_classes.length > 1){
				classView.x = _classes[_classes.length-2].x + _classes[_classes.length-2].width + AppView.CELLPADDING;
			}
			
			addChild(classView);
		}
		
	}
}