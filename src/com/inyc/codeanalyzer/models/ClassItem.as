package com.inyc.codeanalyzer.models
{
	import com.inyc.core.Config;
	import com.inyc.core.CoreModel;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	import com.inyc.utils.TextUtil;

	public class ClassItem extends CoreModel{
		
		public var name:String;
		public var packagePath:String;
		public var extendsClass:String;
		public var implementsClass:String;
		public var imports:Vector.<ImportItem>;
		public var variables:Vector.<VariableItem>;
		public var functions:Vector.<FunctionItem>;
		
		public var defObject:Object = new Object();
		
		private var _loaderUtils:LoaderUtils;
		
		public function ClassItem(){
			imports = new Vector.<ImportItem>;
			variables = new Vector.<VariableItem>;
			functions = new Vector.<FunctionItem>;
		}
		
		public function processClass(declaration:String):void{
			
			if (declaration == null || declaration.length < 2) return;
			
			log("processClass: "+declaration);
			
			var filePath:String;
			if (declaration.charAt(0) == "/"){
				filePath = declaration;
			}else{
				var processArray:Array = new Array();
				processArray = declaration.split("/");
				name = processArray[processArray.length - 1];
				name = stripChars(name);
				name.replace(".as", "");
				
				if (name.length < 3) return;
				
				processArray.pop();
				processArray.shift();
				packagePath = processArray.join("/");
				filePath =( Config.ROOT_PATH + "/" + packagePath + "/" + name);
			}
			
			log("fileData load: "+filePath);
			
			try{
				_loaderUtils = new LoaderUtils();
				addLoadListeners();
				_loaderUtils.readFile(filePath);
			}catch(e:Error){
				log("Error: "+e.message);
			}
			
		}
		
		private function addLoadListeners():void{
			_loaderUtils.addEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			_loaderUtils.addEventListener(LoaderUtilsEvent.IO_ERROR, onLoadError);
			_loaderUtils.addEventListener(LoaderUtilsEvent.SECURITY_ERROR, onLoadError);
		}
		
		private function removeLoadListeners():void{
			_loaderUtils.removeEventListener(LoaderUtilsEvent.FILE_LOADED, fileDataLoaded);
			_loaderUtils.removeEventListener(LoaderUtilsEvent.IO_ERROR, onLoadError);
			_loaderUtils.removeEventListener(LoaderUtilsEvent.SECURITY_ERROR, onLoadError);
		}
		
		private function onLoadError(e:LoaderUtilsEvent):void{
			log("onLoadError");
			removeLoadListeners();
			
		}
		
		private function fileDataLoaded(e:GenericDataEvent):void{
			removeLoadListeners();
			var fileData:String = e.data.file;
			var varExp:RegExp = /([private|public|protected]) var/i;
			var funcExp:RegExp = /([private|public|protected]) function/;
			var categoryExp:RegExp = /@category/i;
			var importExp:RegExp = /import/i;
			
			// HANDLE DIFFERENT KINDS OF LINE BREAKS (NEWLINE, RETURN)			
			fileData = TextUtil.replaceChars(fileData, "\r", "\n");		
			var lineArray:Array = fileData.split(/\n/);
			
			var functionItem:FunctionItem;
			var variableItem:VariableItem;
			var importItem:ImportItem;
			
			log("*******************************************************");
			log("fileDataLoaded: "+name);
			log("lineArray.length: "+lineArray.length);
			log("*******************************************************");
			
			defObject.imports = new Object();
			defObject.variables = new Object();
			defObject.functions = new Object();
			
			
			for (var i:int=0; i<lineArray.length; i++){
				
				//skip commented lines
				if (lineArray[i].indexOf("//") > -1) continue;
				if (lineArray[i].indexOf("/*") > -1) continue;
				
				if (importExp.test(lineArray[i]) == true){
					importItem = new ImportItem();
					importItem.processImport(lineArray[i]);
					imports.push(importItem);
					
					defObject.imports[i] = importItem.importClass;
				}
					
				if (varExp.test(lineArray[i]) == true){
					variableItem = new VariableItem();
					variableItem.processVariable(lineArray[i]);
					variables.push(variableItem);
					
					defObject.variables[i] = variableItem.name;
				}
				
				if (funcExp.test(lineArray[i]) == true){
					
					functionItem = new FunctionItem();
					functionItem.processFunction(lineArray[i]);
					functions.push(functionItem);
					
					defObject.functions[i] = functionItem.name;
				}
				
				if (categoryExp.test(lineArray[i]) == true){
					
					functionItem = new FunctionItem();
					functionItem.processCategory(lineArray[i]);
					functions.push(functionItem);
					
					defObject.functions[i] = functionItem.name;
				}
			}		
				
			traceElements();
			dispatchEvent(new GenericDataEvent(AppEvents.FILE_LOADED, {file:this}));
			
		}
		
		private function traceElements():void{
			//log(ObjectUtils.getGenericObject(defObject));
			
//			log("*********************************");
//			log("fileData readClass: "+name);
//			log("*********************************");
			
			log("--------------------------------");
			log("imports: "+imports.length);
			log("--------------------------------");
//					for (i=0; i<imports.length; i++){
//						trace(imports[i].name);
//					}
			log("--------------------------------");
			log("variables: "+variables.length);
			log("--------------------------------");
				for (var i:int = 0; i<variables.length; i++){
					trace(variables[i].name);
				}
			log("--------------------------------");
			log("functions: "+functions.length);
			log("--------------------------------");
				for (i=0; i<functions.length; i++){
					trace(functions[i].name);
				}
			log("--------------------------------");
		}
		
		public function getImportsArray():Array{
			var importsArray:Array = [];
			for each (var elem:ImportItem in imports) {
				importsArray.push(elem.name);
				 
			}
			return importsArray;
		}
		
		public function getVariablesArray():Array{
			var variablesArray:Array = [];
			for each (var elem:VariableItem in variables) {
				variablesArray.push(elem.name);
			}
			return variablesArray;
		}
		
		public function getFunctionsArray():Array{
			var functionsArray:Array = [];
			for each (var elem:FunctionItem in functions) {
				functionsArray.push(elem.name);
			}
			return functionsArray;
		}
		
		
	}
}