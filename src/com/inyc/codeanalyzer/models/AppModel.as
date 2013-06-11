package com.inyc.codeanalyzer.models
{
	import com.inyc.core.CoreModel;
	import com.inyc.utils.ObjectUtils;
	
	public class AppModel extends CoreModel
	{
		public var model:Object;
		
		public function AppModel(fileArray:Array)
		{
			super();
			
			var classItem:ClassItem;
			model = new Object();
			
			//for (var i:int=0; i<fileArray.length; i++){
			for (var i:int=0; i<100; i++){
				classItem = new ClassItem();
				classItem.processClass(fileArray[i]);
				log(classItem.name);
				
				if (classItem.name != null) model[classItem.name] = classItem;
				
			}
			
			log(ObjectUtils.getGenericObject(model));
			
		}
	}
}