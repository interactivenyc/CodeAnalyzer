package com.inyc.codeanalyzer.models
{
	import com.inyc.codeanalyzer.view.ClassView;
	import com.inyc.core.CoreModel;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.ArrayUtils;
	
	import flash.filesystem.File;
	
	public class AppModel extends CoreModel
	{
		public var model:Object;
		private var _classItems:Array;
		
		public function AppModel(fileArray:Vector.<File>)
		{
			super();
			log("constructor");
			
			model = new Object();
			_classItems = new Array();
			
			init(fileArray);
			
		}
		
		private function init(fileArray:Vector.<File>):void{
			log("init");
			var classItem:ClassItem;
			
			for (var i:int=0; i<fileArray.length; i++){
				classItem = new ClassItem();
				classItem.processClass(fileArray[i]);
				
				//log("classItem.name: "+classItem.name);
				
				if (classItem != null && classItem.name != null) {
					model[classItem.name] = classItem;
					_classItems.push(classItem);
					
					classItem.addEventListener(AppEvents.FILE_LOADED, classLoaded);
				}
			}
		}
		
		private function classLoaded(e:GenericDataEvent):void{
			
			var classItem:ClassItem = e.data.file;
			
			log("classLoaded: "+classItem.name);
			
			ArrayUtils.removeValueFromArray(_classItems,classItem);
			log("classes left to load: "+_classItems.length);
			
			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.FILE_LOADED, {classView:new ClassView(classItem)}));
			
			if (_classItems.length == 0){
				//log(ObjectUtils.getGenericObject(model));
				_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.ALL_FILES_LOADED));
			}
		}
	}
}