package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;

	public class FunctionItem extends CoreModel{
		
		public var name:String;
		public var access:String;
		public var isStatic:Boolean;
	
		public function FunctionItem(){
			super();
		}
		
		public function processFunction():void{
			
		}
		
		
	}
}