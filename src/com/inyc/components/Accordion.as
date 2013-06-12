package com.inyc.components
{
	import com.inyc.core.CoreMovieClip;
	
	public class Accordion extends CoreMovieClip
	{
		public var accordion:Accordion_MC;
		
		
		public function Accordion()
		{
			super();
			accordion = new Accordion_MC();
		}
	}
}