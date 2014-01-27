package
{
	import com.inyc.core.CoreMovieClip;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Main extends CoreMovieClip
	{
		private var _codeAnalyzer:CodeAnalyzer;
		
		public function Main(){
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			log("constructor");
			_codeAnalyzer = new CodeAnalyzer();
			addChild(_codeAnalyzer);
		}
	}
}