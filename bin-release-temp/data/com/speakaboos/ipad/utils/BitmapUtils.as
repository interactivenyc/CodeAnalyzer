package com.speakaboos.ipad.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.Matrix;

	public class BitmapUtils
	{
		public static function copyScaledBmp(srcBitmap:Bitmap, width:Number = NaN, height:Number = NaN):Bitmap {
			srcBitmap.smoothing = true;
			var scaleX:Number = width / srcBitmap.width;
			var scaleY:Number = height / srcBitmap.height;
			if (isNaN(height)) {
				scaleY = scaleX;
				height = srcBitmap.height * scaleY;
			} else if (isNaN(width)) {
				scaleX = scaleY;
				width = srcBitmap.width * scaleX;
			}
			var bmd:BitmapData = new BitmapData(width, height, true, 0x000000);
			var result:Bitmap = new Bitmap(bmd, PixelSnapping.NEVER, true);
			var m:Matrix = new Matrix();
			m.scale(scaleX, scaleY);
			bmd.drawWithQuality(srcBitmap, m, null, null, null, true, StageQuality.BEST);
			return result;
		}
		
	}
}