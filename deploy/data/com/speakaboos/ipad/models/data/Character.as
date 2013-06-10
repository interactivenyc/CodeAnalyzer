package com.speakaboos.ipad.models.data
{
	import com.speakaboos.ipad.view.CharacterSWF;

	public class Character extends Category
	{
		public var charSWF:CharacterSWF;
		
		public function Character(data:Object = null){
		
			if(data){
				//log(data)
				super(data);
			}
		}
	}
}