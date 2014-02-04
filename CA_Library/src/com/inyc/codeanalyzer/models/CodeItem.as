package com.inyc.codeanalyzer.models
{
	import com.adobe.utils.StringUtil;
	import com.inyc.core.CoreModel;
	import com.inyc.utils.TextUtil;

	public class CodeItem extends CoreModel{
		
		
		
		public static const PUBLIC:String = "PUBLIC";
		public static const PRIVATE:String = "PRIVATE";
		public static const PROTECTED:String = "PROTECTED";
		
		public function CodeItem(){
			
		}
		
		protected function stripChars(input:String):String{
			//input = StringUtil.remove(input, "()");
			input = StringUtil.remove(input, "{");
			input = StringUtil.remove(input, "}");
			input = StringUtil.remove(input, ";");
			input = TextUtil.trim(input);
			
			return input;
		}
		
		
		protected function prefixSymbols(declaration:String, name:String):String{
			var prefix:String = "";
			
//			if (declaration.indexOf("final") > -1){
//				prefix = "F" + prefix
//			}
//			if (declaration.indexOf("static") > -1){
//				prefix = "S" + prefix
//			}
//			if (declaration.indexOf("override") > -1){
//				prefix = "O" + prefix
//			}
			
			if (declaration.indexOf("public") > -1){
				prefix = "+" + prefix
			}else if (declaration.indexOf("private") > -1){
				prefix = "-" + prefix
			}else if (declaration.indexOf("protected") > -1){
				prefix = "*" + prefix
			}else if (declaration.indexOf("category") > -1){
				prefix = "*****" + prefix
				return "----- "+name+" -----";
			}
			
			return "["+prefix+"] " +name;
		}
		
		
	}
}