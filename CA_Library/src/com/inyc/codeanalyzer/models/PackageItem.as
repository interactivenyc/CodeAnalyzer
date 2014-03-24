package com.inyc.codeanalyzer.models {

	public class PackageItem extends CodeItem {

		public var packageString:String;
		
		public function PackageItem(declaration:String) {
			super();
			_dataString = declaration;
			
			try{
				packageString = _dataString.split("package ")[1];
				packageString = stripChars(packageString);
			}catch(e:Error){
				log("Error: "+e.type);
				if (declaration.indexOf("package") > -1){
					packageString = "default package";
				}else{
					packageString = "unknown package";
				}
			}
			
			
		}

	}
}
