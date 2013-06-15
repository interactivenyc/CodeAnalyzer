package com.speakaboos.mobile.data.db.error
{
	public final class GenericDbError extends Error
	{
		public function GenericDbError(message:String="", id:int=0)
		{
			super(message, id);
		}
	}
}