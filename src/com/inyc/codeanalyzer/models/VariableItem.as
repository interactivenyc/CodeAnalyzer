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
		
		public function processVariable(declaration:String):void{
			var processArray:Array = declaration.split(" ");
			var arrayIndex:int = processArray.indexOf("var");
			name = processArray[arrayIndex + 1];
			name = stripChars(name);
			
			//log("VARIABLE name: "+name);
		}
		
		
	}
}