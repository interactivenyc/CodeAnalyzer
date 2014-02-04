package com.inyc.codeanalyzer.models {

	public class FunctionItem extends CodeItem{		
		public var name:String;
		public var access:String;
		public var isStatic:Boolean;
	
		public function FunctionItem(){
			super();
		}
		
		public function processFunction(declaration:String):String{
			_dataString = declaration;
			
			if (declaration.indexOf("function") > -1){
				var varExp:RegExp = new RegExp("(?<=function)(.*)");
				name = varExp.exec(declaration)[0];
				name = name.substring(0, name.indexOf("(")) + "()";
				name = prefixSymbols(declaration, name);
				
				//log("FUNCTION name: "+name);
				//var colon:RegExp = /:/g;
				//name = name.split(colon).join(" : ");
			}
			
			return name;
		}
		
		public function processCategory(declaration:String):String{
			
			if (declaration.indexOf("@category") > -1){
				var varExp:RegExp = new RegExp("(?<=@category)(.*)");
				name = varExp.exec(declaration)[0];
				name = stripChars(name);
				name = prefixSymbols(declaration, name);
				
				//log("FUNCTION name: "+name);
			}
			return name;
		}
		
		
	}
}