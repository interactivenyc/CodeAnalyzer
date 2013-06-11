package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;

	public class ImportItem extends CoreModel{
		public var importClass:String;
		public var importPackage:String;
		
		public function ImportItem(){
			super();
		}
		
		public function processImport():void{
			
		}
		
		
	}
}