package com.inyc.utils {//	import com.adobe.images.JPGEncoder;	import com.greensock.TweenMax;	import com.inyc.utils.debug.Logger;		import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.GradientType;	import flash.display.Graphics;	import flash.display.LineScaleMode;	import flash.display.MovieClip;	import flash.display.Shape;	import flash.display.Sprite;	import flash.filters.BitmapFilterQuality;	import flash.filters.BlurFilter;	import flash.filters.DropShadowFilter;	import flash.geom.ColorTransform;	import flash.geom.Matrix;	import flash.geom.Point;	import flash.utils.getDefinitionByName;
	/**	 * @author stevewarren	 */	public class MovieClipUtils {				public static var stageWidth:Number;		public static var stageHeight:Number;		public static function centerDisplayObject(displayObject:DisplayObject, offset:Point = null):void{			if (isNaN(stageWidth) || stageWidth == 0) {				stageWidth = displayObject.stage.stageWidth;				stageHeight = displayObject.stage.stageHeight;			}			if (!offset) offset = new Point(0,0);			displayObject.x = (stageWidth - displayObject.width) / 2 + offset.x;			displayObject.y = (stageHeight - displayObject.height) / 2 + offset.y;		}				public static function getFilledRect(w:Number,h:Number,color:Number = 0x0000FF):Shape {			//log("getFilledRect()");			var rect:Shape = new Shape();			rect.graphics.beginFill(color);			//rect.graphics.lineStyle(1,0x000000);			rect.graphics.drawRect(0, 0, w, h);			rect.graphics.endFill();			return rect;		}				public static function getFilledSprite(w:Number,h:Number,color:Number = 0x0000FF):Sprite {			var sprite:Sprite = new Sprite();			sprite.addChild(getFilledRect(w,h,color));				return sprite;		}		public static function getFilledMC(w:Number,h:Number,color:Number=0x0000FF,border:Boolean = false):MovieClip {			//log("getFilledRect()");			var mc:MovieClip = new MovieClip();			var rect:Shape = new Shape();			rect.graphics.beginFill(color);			if (border) rect.graphics.lineStyle(1, 0x000000, 1, true, LineScaleMode.NONE);			rect.graphics.drawRect(0, 0, w, h);			rect.graphics.endFill();			mc.addChild(rect);			return mc;		}		public static function makeGradient(mc:MovieClip, mcWidth:Number,mcHeight:Number,startcolor:uint,endcolor:uint, angle:Number, offAxis:Boolean):void{			//log("makeGradient:" + mc +", " + startcolor +", " + endcolor +", " + angle + ", " + offAxis);			var a:int=0;			var g:Graphics=mc.graphics;			var boxMatrix:Matrix = new Matrix();			g.clear();			g.lineStyle();			var squaresize:Number=Math.max(mcWidth,mcHeight);			if (offAxis) {				var bigsquaresize:Number=Math.ceil(Math.sqrt(mcWidth*mcWidth+mcHeight*mcHeight));				boxMatrix.createGradientBox(bigsquaresize,bigsquaresize,angle,-(bigsquaresize-squaresize)/2,-(bigsquaresize-squaresize)/2);			} else {				boxMatrix.createGradientBox(squaresize,squaresize,angle);			}			g.beginGradientFill(GradientType.LINEAR,[startcolor,endcolor],[1,1],[0,255],boxMatrix);			g.drawRect(0,0,mcWidth,mcHeight);			g.endFill();		}		//		public static function getJPGFromMC(imageDisplay:MovieClip, jpgWidth:int=0):ByteArray {//			//log("getJPGFromMC");//			//			var resizedImage:MovieClip = getRenderedMC(imageDisplay, jpgWidth);//			//			var jpgEncoder:JPGEncoder = new JPGEncoder(85);//			var jpgSource:BitmapData;//			var jpgStream:ByteArray;//			//			jpgSource = new BitmapData(resizedImage.width, resizedImage.height);//			jpgSource.draw(resizedImage);//			//			jpgStream = jpgEncoder.encode(jpgSource);//			//			return jpgStream;//		}				public static function getBitmapDataFromMC(imageDisplay:DisplayObject, jpgWidth:int=0):BitmapData {			//log("getJPGFromMC");						//var resizedImage:MovieClip = getRenderedMC(imageDisplay, jpgWidth);			var bitmapData:BitmapData = new BitmapData(imageDisplay.width, imageDisplay.height, true, 0x000000);			bitmapData.draw(imageDisplay);						return bitmapData;		}				public static function getRenderedMC(imageDisplay:MovieClip, jpgWidth:int=0):MovieClip{			var resizedImage:MovieClip = new MovieClip();						var bitmapData:BitmapData = new BitmapData(imageDisplay.width,imageDisplay.height, true, 0x000000);			bitmapData.draw(imageDisplay);						if (jpgWidth == 0){				jpgWidth = imageDisplay.width;			}						var scale:Number;			var matrix:Matrix;						//THUMB IMAGE			scale = jpgWidth/bitmapData.width;			matrix = new Matrix();			matrix.scale(scale, scale);						resizedImage.graphics.clear();			resizedImage.graphics.beginBitmapFill(bitmapData, matrix, false);			resizedImage.graphics.drawRect(0, 0, bitmapData.width*scale, bitmapData.height*scale);			resizedImage.graphics.endFill();						return resizedImage;		}		//		public static function getJPGFromMaskedMC(imageDisplay:MovieClip, jpgWidth:int=0):ByteArray {//			//log("getJPGFromMaskedMC");//			//log(imageDisplay);//			//log(imageDisplay.mask);//			//			var resizedImage:MovieClip = new MovieClip();//			var bitmapData:BitmapData = new BitmapData(imageDisplay.mask.width,imageDisplay.mask.height);//			var tempMask:DisplayObject = imageDisplay.mask;//			//			imageDisplay.mask = null;//			bitmapData.draw(imageDisplay);//			imageDisplay.mask = tempMask;//			//			//			if (jpgWidth == 0){//				jpgWidth = imageDisplay.width;//			}//			//			var scale:Number;//			var matrix:Matrix;//			//			//THUMB IMAGE//			scale = jpgWidth/bitmapData.width;//			matrix = new Matrix();//			matrix.scale(scale, scale);//			//			resizedImage.graphics.clear();//			resizedImage.graphics.beginBitmapFill(bitmapData, matrix, false, true);//			resizedImage.graphics.drawRect(imageDisplay.mask.x, imageDisplay.mask.y, imageDisplay.mask.width*scale, imageDisplay.mask.height*scale);//			resizedImage.graphics.endFill();//			//			var jpgEncoder:JPGEncoder = new JPGEncoder(85);//			var jpgSource:BitmapData;//			var jpgStream:ByteArray;//			//			jpgSource = new BitmapData(resizedImage.width, resizedImage.height);//			jpgSource.draw(resizedImage);//			//			jpgStream = jpgEncoder.encode(jpgSource);//			//			return jpgStream;//		}//						public static function getMCGrid(containerItems:Array, cellWidth:int, cellHeight:int, gap:int, cols:int):MovieClip{			var mc:MovieClip = new MovieClip();						for (var i:int=0;i<containerItems.length;i++){				containerItems[i].x = int(i%cols*(cellWidth+gap)+gap/2);				containerItems[i].y = int(int(i/cols)*(cellHeight+gap)+gap/2);				mc.addChild(containerItems[i]);			}						return mc;		}						public static function getLibraryMC(classname:String):MovieClip{			//log("getLibraryMC:"+classname);			var returnClass:Class = getDefinitionByName(classname) as Class;			var returnMC:MovieClip = new returnClass() as MovieClip;			returnMC.classType = classname;			return returnMC;		}				public static function getParents(displayObject:DisplayObject, doTrace:Boolean = false):Array {			if (doTrace) {				log("*************************************************************");				log("traceParents of " + displayObject +" : "+ displayObject.name);				log("*************************************************************");			}			var returnArray:Array = new Array();			var currentDisplayObject:DisplayObject = displayObject;			var depth:String = " ~ ";			while(currentDisplayObject is DisplayObject){				if (doTrace) log(depth +currentDisplayObject +" : "+ currentDisplayObject.name+"   scaleX:"+ currentDisplayObject.scaleX + ", loc:("+currentDisplayObject.x+","+currentDisplayObject.y+")");				depth += " ~ ";				returnArray.push(currentDisplayObject);				currentDisplayObject = currentDisplayObject.parent;			}						if (doTrace) log("*************************************************************");			return returnArray;		}				public static function blurOn(mc:Sprite):void {			var blur:BlurFilter = new BlurFilter();			blur.blurX=6;			blur.blurY=0;			blur.quality=BitmapFilterQuality.MEDIUM;			mc.filters=[blur];		}		public static function blurOff(mc:Sprite):void {			var blur:BlurFilter = new BlurFilter();			blur.blurX=0;			blur.blurY=0;			blur.quality=BitmapFilterQuality.MEDIUM;			mc.filters=[blur];		}		public static function outlineOn(mc:Sprite, width:uint, color:Number, blur:uint=0):void {			mc.filters=[new DropShadowFilter(width,0,color,1,blur,blur),new DropShadowFilter(- width,0,color,1,blur,blur),new DropShadowFilter(width,90,color,1,blur,blur),new DropShadowFilter(- width,90,color,1,blur,blur)];		}		public static function outlineOff(mc:Sprite):void {			mc.filters=[];		}		public static function shadowOn(mc:Sprite, width:uint, color:Number, blur:uint=0):void {			mc.filters=[new DropShadowFilter(width,45,color,1,blur,blur)];		}		public static function shadowOff(mc:Sprite):void {			mc.filters=[];		}		public static function applyTint(_displayObject:DisplayObject,_color:Number):void {			var _ct:ColorTransform=new ColorTransform  ;			if (! isNaN(_color)) {				_ct.color=_color;				_displayObject.transform.colorTransform=_ct;			}		}						public static function hiliteAndDisable(mc:MovieClip):void{			hiliteMC(mc);			disableMC(mc);		}				public static function hiliteMC(mc:MovieClip):void{			TweenMax.to(mc, .01, {colorTransform:{tint:0xFFFFFF, tintAmount:.3}});			mc.alpha = .7;					}				public static function disableMC(mc:MovieClip):void{			mc.mouseChildren = false;			mc.mouseEnabled = false;		}				public static function reEnable(mc:MovieClip):void{			TweenMax.to(mc, .01, {colorTransform:{tint:0xFFFFFF, tintAmount:0}});			mc.alpha = 1;			mc.mouseChildren = true;			mc.mouseEnabled = true;		}		private static function log(logItem:*):void {			Logger.log(logItem,["MovieClipUtils"],true);		}	}}