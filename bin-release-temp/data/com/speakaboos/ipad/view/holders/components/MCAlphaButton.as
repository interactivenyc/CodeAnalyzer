/********************************************************************************************************
 * @file	MCAlphaButton.as
 * @author 	shaneculp
 * @date	Mar 11, 2013 5:56:07 PM
 *
 * Class to override MCButton to remove tint and replcae with alpha.
 ********************************************************************************************************/
package com.speakaboos.ipad.view.holders.components
{
	import flash.display.MovieClip;

	public class MCAlphaButton extends CoreButton
	{
		
		/************************************************************************************************
		 * Constructor
		 ************************************************************************************************/
		public function MCAlphaButton(pButtonMC:MovieClip) {
			super(pButtonMC);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////
		//External Functions
		/////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function set downState(down:Boolean):void{
			super.downState = down;
			//log("set downState: "+down + ", "+this);
			if (down){
				mc.alpha = .5;
			}else{
				mc.alpha = 1;
			}
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////
		//Internal Functions
		/////////////////////////////////////////////////////////////////////////////////////////////////
		
		
	}
}