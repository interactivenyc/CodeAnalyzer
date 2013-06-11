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
		
		public function processFunction(declaration:String):void{
			
			var processArray:Array = declaration.split(" ");
			var arrayIndex:int = processArray.indexOf("function");
			name = processArray[arrayIndex + 1];
			if (name == "get" || name == "set"){
				name = processArray[arrayIndex + 1] + "_" + processArray[arrayIndex + 2];
			}
			name = stripChars(name);
			
			//log("FUNCTION name: "+name);
		}
		
		
	}
}