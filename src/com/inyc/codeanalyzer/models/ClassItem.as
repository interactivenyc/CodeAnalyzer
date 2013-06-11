package com.inyc.codeanalyzer.models
{
	import com.inyc.core.Config;
	import com.inyc.core.CoreModel;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;

	public class ClassItem extends CoreModel{
		
		public var name:String;
		public var packagePath:String;
		public var extendsClass:String;
		public var implementsClass:String;
		public var imports:Vector.<ImportItem>;
		public var variables:Vector.<VariableItem>;
		public var functions:Vector.<FunctionItem>;
		
		private var _loaderUtils:LoaderUtils;
		
		public function ClassItem(){
		}
		
		public function processClass(declaration:String):void{
			
			if (declaration == null || declaration.length < 2) return;
			
			var processArray:Array = new Array();
			processArray = declaration.split("/");
			name = processArray[processArray.length - 1];
			
			
			if (name.length < 3) return;
			
			processArray.pop();
			processArray.shift();
			packagePath = processArray.join("/");
			var filePath:String =( Config.ROOT_PATH + "/" + packagePath + "/" + name);
			
			log("fileData load: "+filePath);
			
			try{
				_loaderUtils = new LoaderUtils();
				_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
				_loaderUtils.readFile(filePath);
			}catch(e:Error){
				log("Error: "+e.message);
			}
			
			
		}
		
		private function fileDataLoaded(e:GenericDataEvent):void{
			var fileData:String = e.data.fileData;
			
			try{
				log("fileData read: "+name);
				log(e.data);
			}catch(e:Error){
				log("Error: "+e.message);
			}
			
		}
		
		
	}
}