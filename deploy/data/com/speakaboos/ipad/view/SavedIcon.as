/**
 * @author Manuel Joachim -	manuel.joachim@gmail.com
 * 
 */
package com.speakaboos.ipad.view
{
	import com.sdk.utils.text.TextUtils;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class SavedIcon extends Sprite{
		
		public function SavedIcon() { 
			
			var label:TextField;
			
			label =			TextUtils.createCenteredTextField( 0xffffff, 50, "Arial", false, 12, true );
			label.text =	"SAVED";
			label.y =		2;	
			
			graphics.beginFill( 0xff0000 );
			graphics.lineStyle( 1, 0x000000, 1.5, true );
			graphics.drawRoundRect( 0, 0, 50, 20, 15 );
			
			addChild( label );
		
		}
	}
}