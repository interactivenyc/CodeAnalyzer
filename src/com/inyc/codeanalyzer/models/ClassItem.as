package com.inyc.codeanalyzer.models
{
	import com.inyc.core.Config;
	import com.inyc.core.CoreModel;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.LoaderUtils;
	import com.inyc.utils.ObjectUtils;

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
			
			var processArray:Array = new Array();
			processArray = declaration.split("/");
			name = processArray[processArray.length - 1];
			name = stripChars(name);
			name.replace(".as", "");
			
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
			var fileData:String = e.data.file;
			var varExp:RegExp = /([private|public|protected]) var/i;
			var funcExp:RegExp = /([private|public|protected]) function/i;
			var importExp:RegExp = /import/i;
			var lineArray:Array = fileData.split(/\n/);
			var functionItem:FunctionItem;
			var variableItem:VariableItem;
			var importItem:ImportItem;
			
			log("fileDataLoaded: "+fileData);
			
			
			defObject.imports = new Object();
			defObject.variables = new Object();
			defObject.functions = new Object();
			
			for (var i:int=0; i<lineArray.length; i++){
				if (lineArray[i].indexOf("//") > 0) continue;
				
				if (importExp.test(lineArray[i]) == true){
					//log(lineArray[i]);
					importItem = new ImportItem();
					importItem.processImport(lineArray[i]);
					imports.push(importItem);
					
					defObject.imports[i] = importItem.importClass;
				}
					
				if (varExp.test(lineArray[i]) == true){
					//log(lineArray[i]);
					variableItem = new VariableItem();
					variableItem.processVariable(lineArray[i]);
					variables.push(variableItem);
					
					defObject.variables[i] = variableItem.name;
				}
				
				if (funcExp.test(lineArray[i]) == true){
					//log(lineArray[i]);
					functionItem = new FunctionItem();
					functionItem.processFunction(lineArray[i]);
					functions.push(functionItem);
					
					defObject.functions[i] = functionItem.name;
				}
					
			}
			
			dispatchEvent(new GenericDataEvent(AppEvents.FILE_LOADED, {file:this}));
								
				
//			//log(ObjectUtils.getGenericObject(defObject));
//			
//			log("*********************************");
//			log("fileData readClass: "+name);
//			log("*********************************");
//			log("imports: "+imports.length);
//			log("--------------------------------");
//			log("variables: "+variables.length);
//			log("--------------------------------");
//			log("functions: "+functions.length);
//			log("--------------------------------");
				
			
			
		}
		
		
	}
}