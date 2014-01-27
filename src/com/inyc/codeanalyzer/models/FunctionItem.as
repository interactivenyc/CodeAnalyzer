package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;
	
	import flash.events.PressAndTapGestureEvent;

	public class FunctionItem extends CoreModel{
		
		public var name:String;
		public var access:String;
		public var isStatic:Boolean;
	
		public function FunctionItem(){
			super();
		}
		
		public function processFunction(declaration:String):String{
			
//			var processArray:Array = declaration.split(" ");
//			var arrayIndex:int = processArray.indexOf("function");
//			
//			
//				
//			
//			if (declaration.indexOf("closeModal") > -1){
//				log("catch special case");
//				var varExp:RegExp = new RegExp("(?<=function)(.*)");
//				log(varExp.exec(declaration)[0]);
//			}
//			
//			for (var i:int=0; i<processArray.length; i++){
//				//for functions that are squashed onto one line like this:
//				//public function set firstOfflineModeChange(val:Boolean):void{_firstOfflineModeChange = val};
//				if (processArray[i].indexOf("{") > -1){
//					processArray[i] = processArray[i].split("{")[0];
//				}
//			}
//			
//			
//			
//			name = processArray[arrayIndex + 1];
//			if (name == "get" || name == "set"){
//				name = processArray[arrayIndex + 1] + "_" + processArray[arrayIndex + 2];
//			}
//			name = stripChars(name);
			
			
			if (declaration.indexOf("function") > -1){
				var varExp:RegExp = new RegExp("(?<=function)(.*)");
				name = varExp.exec(declaration)[0];
				name = stripChars(name);
				name = prefixSymbols(declaration, name);
				
				log("FUNCTION name: "+name);
			}
			
			
			return name;
			
			
		}
		
		
	}
}