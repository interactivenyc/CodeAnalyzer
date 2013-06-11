package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;

	public class VariableItem extends CoreModel{
		
		public var name:String;
		public var access:String;
		public var isStatic:String;
		
		public function VariableItem(){
			super();
		}
		
		public function processVariable():void{
			
		}
		
		
	}
}