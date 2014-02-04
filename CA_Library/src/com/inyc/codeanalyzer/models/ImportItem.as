package com.inyc.codeanalyzer.models {
	
	public class ImportItem extends CodeItem{		
		public var importClass:String;
		public var importPackage:String;
		
		public function ImportItem(){
			super();
		}
		
		public function processImport(declaration:String):String{
			_dataString = declaration;
			
			var processArray:Array = declaration.split(" ");
			var wholeImport:String = processArray[processArray.length-1];
			var packageArray:Array = wholeImport.split(".");
			
			importClass = packageArray[packageArray.length -1];
			importClass = stripChars(importClass);
			
			packageArray.pop();
			importPackage = packageArray.join(".");
			
			return importPackage;
			//log("IMPORT package: "+importPackage+" ::  class: "+importClass);
		}
		
		
		public function get name():String{
			return importPackage + "." + importClass;
		}
		
		
	}
}