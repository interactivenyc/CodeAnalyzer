package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	
	public class Accordion extends CoreMovieClip
	{
		public var accordion:ACMini_MC;
		public var indicator:MCButton;
		
		
		public function Accordion()
		{
			super();
			accordion = new ACMini_MC();
			
			accordion.bg.visible = false;
			accordion.bottom.y = accordion.top.y + accordion.top.height;
			
			indicator = accordion.top.indicator as MCButton;
			
			addChild(accordion);
		}
	}
}