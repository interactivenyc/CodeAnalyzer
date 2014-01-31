package com.inyc.utils
{
	import flash.filesystem.File;

	public class FileUtils
	{
		public function FileUtils(){
			
		}
		
		public static function getFilename(file:File):String{
			return file.nativePath.split("/").pop();
		}
		
		
		
	}
}