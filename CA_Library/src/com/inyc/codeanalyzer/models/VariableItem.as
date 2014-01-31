package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;

	public class VariableItem extends CoreModel{
		public var declaration:String;
		
		public var name:String;
		public var access:String;
		public var isStatic:String;
		
		public function VariableItem(){
			super();
		}
		
		public function processVariable(declaration:String):void{
			declaration = declaration;
			
			var processArray:Array = declaration.split(" ");
			var arrayIndex:int = processArray.indexOf("var");
			name = processArray[arrayIndex + 1];
			var colon:RegExp = /:/g;
			name = name.split(colon)[0];
			//name = stripChars(name);
			name = prefixSymbols(declaration, name);
			
			//log("VARIABLE name: "+name);
			//var colon:RegExp = /:/g;
			//name = name.split(colon).join(" : ");
		}
		
		
	}
}