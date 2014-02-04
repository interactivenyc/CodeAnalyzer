package com.inyc.codeanalyzer.models{
	
	public class VariableItem extends CodeItem{		
		public var name:String;
		public var access:String;
		public var isStatic:String;
		
		public function VariableItem(){
			super();
		}
		
		public function processVariable(declaration:String):void{
			_dataString = declaration;
			
			var processArray:Array = declaration.split(" ");
			var arrayIndex:int = processArray.indexOf("var");
			name = processArray[arrayIndex + 1];
			var colon:RegExp = /:/g;
			name = name.split(colon)[0];
			name = prefixSymbols(declaration, name);
			
			//log("VARIABLE name: "+name);
			//var colon:RegExp = /:/g;
			//name = name.split(colon).join(" : ");
		}
		
		
	}
}