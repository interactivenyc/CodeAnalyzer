package com.speakaboos.ipad.models.data
{
	public class Subscription
	{
		public var id:Number;
		public var subscription_type_id:Number;
		public var chargify_id:Number;
		public var chargify_state:String;
		public var receipt:String;
		public var free_trial_used:Boolean;
		public var period_start:String;
		public var period_end:String;
		public var type:String;
		public var state:String;
		
		public function Subscription(){}
	}
}