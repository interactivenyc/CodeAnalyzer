package com.speakaboos.ipad.view.holders.components
{
	import flash.display.MovieClip;

	public class NavButton extends DialogButtonBase
	{
		override public function set downState(down:Boolean):void{
			super.downState = down;
			//log("set downState: "+down + ", "+this);
			if (down){
				mc.alpha = .5;
			}else{
				mc.alpha = 1;
			}
		}
				
		public function NavButton(pButtonMC:MovieClip, pButtonText:String="", pCallback:Function=null){
			super(pButtonMC, pButtonText, pCallback);
		}
		
	}
}