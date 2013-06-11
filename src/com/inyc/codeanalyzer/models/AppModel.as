package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;
	import com.inyc.events.AppEvents;
	import com.inyc.events.GenericDataEvent;
	import com.inyc.utils.ArrayUtils;
	import com.inyc.utils.ObjectUtils;
	
	public class AppModel extends CoreModel
	{
		public var model:Object;
		private var _classItems:Array;
		
		public function AppModel(fileArray:Array)
		{
			super();
			
			_classItems = new Array();
			var classItem:ClassItem;
			model = new Object();
			
			//for (var i:int=0; i<fileArray.length; i++){
			for (var i:int=0; i<10; i++){
				classItem = new ClassItem();
				classItem.processClass(fileArray[i]);
				
				log(classItem.name);
				
				if (classItem != null && classItem.name != null) {
					model[classItem.name] = classItem;
					_classItems.push(classItem);
					classItem.addEventListener(AppEvents.FILE_LOADED, classLoaded);
				}
				
			}
			
			
			
		}
		
		private function classLoaded(e:GenericDataEvent):void{
			var classItem:ClassItem = e.data.file;
			ArrayUtils.removeValueFromArray(_classItems,classItem);
			log("classes left to load: "+_classItems.length);
			
			if (_classItems.length == 0){
				log(ObjectUtils.getGenericObject(model));
			}
		}
	}
}