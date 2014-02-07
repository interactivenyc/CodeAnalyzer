package com.inyc.codeanalyzer.models {

	public class PackageItem extends CodeItem {

		public var packageString:String;
		
		public function PackageItem(declaration:String) {
			super();
			_dataString = declaration;
			
			packageString = _dataString.split("package ")[1];
			packageString = stripChars(packageString);
			
		}

	}
}
