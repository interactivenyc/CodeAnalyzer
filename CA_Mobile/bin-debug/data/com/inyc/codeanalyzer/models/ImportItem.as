package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;

	public class ImportItem extends CoreModel{
		public var importClass:String;
		public var importPackage:String;
		
		public function ImportItem(){
			super();
		}
		
		public function processImport(declaration:String):String{
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