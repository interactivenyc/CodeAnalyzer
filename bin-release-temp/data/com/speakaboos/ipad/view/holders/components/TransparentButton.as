package com.speakaboos.ipad.view.holders.components
{
	import flash.display.MovieClip;
	
	public class TransparentButton extends CoreButton
	{
		
		override public function set downState(down:Boolean):void{
			super.downState = down;
			//log("set downState: "+down + ", "+this);
			if (down){
				mc.alpha = .5;
			}else{
				mc.alpha = 0;
			}
		}

		public function TransparentButton(pMc:MovieClip)
		{
			super(pMc);
			mc.alpha = 0;
		}
		
	}
}