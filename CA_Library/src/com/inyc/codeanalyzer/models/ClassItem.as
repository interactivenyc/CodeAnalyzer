package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.events.LoaderUtilsEvent;
	import com.inyc.utils.FileUtils;
	import com.inyc.utils.LoaderUtils;
	import com.inyc.utils.TextUtil;

	import flash.filesystem.File;

	public class ClassItem extends CodeItem{

		public var classFile:File;
		public var packageItem:PackageItem;
		public var imports:Vector.<CoreModel>;
		public var variables:Vector.<CoreModel>;
		public var functions:Vector.<CoreModel>;

		//not implemented yet
		public var extendsClass:String;
		public var implementsClass:String;

		public var defObject:Object = new Object();

		private var _loaderUtils:LoaderUtils;

		public function ClassItem(){
			imports = new Vector.<CoreModel>;
			variables = new Vector.<CoreModel>;
			functions = new Vector.<CoreModel>;
		}

		public function processClass(file:File):void{
			log("processClass: "+file.nativePath);

			classFile = file;
			_data = file;

			name = FileUtils.getFilename(file);	
			//packageString = FileUtils.getPackage(file);	

			try{
				_loaderUtils = new LoaderUtils();
				addLoadListeners();
				_loaderUtils.readFile(file.url);

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
			var varExp:RegExp = /([private|public|protected]) var /;
			var funcExp:RegExp = /([private|public|protected]) function /;
			var categoryExp:RegExp = /@category(?!.*categoryExp)/i; //(?!.*categoryExp) is so that this exact line will not be matched when reading the codebase that contains this class
			var packageExp:RegExp = /package.*/;
			var importExp:RegExp = /import /;

			// HANDLE DIFFERENT KINDS OF LINE BREAKS (NEWLINE, RETURN)			
			fileData = TextUtil.replaceChars(fileData, "\r", "\n");		
			var lineArray:Array = fileData.split(/\n/);

			var functionItem:FunctionItem;
			var variableItem:VariableItem;
			var importItem:ImportItem;

			//TODO: FIND A BETTER WAY TO LIMIT THE SCOPE OF EACH CODE TYPE
			var packageFinished:Boolean = false;
			var importsFinished:Boolean = false;
			var globalVariablesFinished:Boolean = false;

			log("*******************************************************");
			log("fileDataLoaded: "+name);
			log("lineArray.length: "+lineArray.length);
			log("*******************************************************");

			defObject.imports = new Object();
			defObject.variables = new Object();
			defObject.functions = new Object();

			//TODO: FIND A BETTER WAY TO PROGRESS LINEARLY THROUGH THE BODY OF THE CLASS - USE STATE?
			for (var i:int=0; i<lineArray.length; i++){

				//skip commented lines
				if (lineArray[i].indexOf("//") > -1) continue;
				if (lineArray[i].indexOf("/*") > -1) continue;

				if (packageExp.test(lineArray[i]) == true && packageFinished == false){

					packageFinished = true;
					packageItem = new PackageItem(lineArray[i]);
					log("package: "+packageItem.packageString);
				}

				if (importExp.test(lineArray[i]) == true && importsFinished == false){
					importItem = new ImportItem();
					importItem.processImport(lineArray[i]);
					imports.push(importItem);

					defObject.imports[i] = importItem.importClass;
				}

				if (varExp.test(lineArray[i]) == true && globalVariablesFinished == false){

					if (!importsFinished) importsFinished = true;

					variableItem = new VariableItem();
					variableItem.processVariable(lineArray[i]);
					variables.push(variableItem);

					defObject.variables[i] = variableItem.name;
				}

				if (funcExp.test(lineArray[i]) == true){

					if (!globalVariablesFinished) globalVariablesFinished = true;
					
					
					//if (lineArray[i].indexOf("get ") > -1 || lineArray[i].indexOf("set ") > -1 ){
						//exclude getter/setters
					//}else{
						functionItem = new FunctionItem();
						functionItem.processFunction(lineArray[i]);
						functions.push(functionItem);
						
						defObject.functions[i] = functionItem.name;
					//}

					
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

//			log("--------------------------------");
//			log("imports: "+imports.length);
//			log("--------------------------------");
//				for (i=0; i<imports.length; i++){
//					trace(imports[i].name);
//				}
//			log("--------------------------------");
//			log("variables: "+variables.length);
//			log("--------------------------------");
//				for (var i:int = 0; i<variables.length; i++){
//					trace(variables[i].name);
//				}
//			log("--------------------------------");
//			log("functions: "+functions.length);
//			log("--------------------------------");
//				for (i=0; i<functions.length; i++){
//					trace(functions[i].name);
//				}
//			log("--------------------------------");
			
			
			//SUMMARY
			log("imports: "+imports.length+", variables: "+variables.length+", functions: "+functions.length);
			
			
		}




	}
}

