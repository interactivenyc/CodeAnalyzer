package com.inyc.utils
	
{
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Point;
	
	import fl.motion.AdjustColor;
	import fl.motion.Color;

    public class ColorUtil
    {        
        
        public static function colorize(obj:DisplayObject, color:String):void {
			// colors the bitmapData of bitmap objects, adds a filter for mc
			trace("[ ColorUtil ] colorize: "+color);
            var colorParams:Vector.<String> = Vector.<String>(color.split(","));
            switch (colorParams[0].toLowerCase()) {
                case "adjustcolor": // adjust color
                    var colorMatrix:ColorMatrixFilter = getColorMatrixFilterForBCSH(
															Number(colorParams[1]), 
															Number(colorParams[2]), 
															Number(colorParams[3]), 
															Number(colorParams[4]));
					if (obj.hasOwnProperty("bitmapData")) {
						var bmd:BitmapData = obj["bitmapData"];
						bmd.applyFilter(bmd, bmd.rect, new Point(0,0), colorMatrix);
						obj["bitmapData"] = bmd;
					} else if (obj.hasOwnProperty("filters")) {
						var flt:Array = obj["filters"];
						flt.push(colorMatrix);
						obj["filters"] = flt;
					}
                    break;
                default:
                //assume it is a rgb color value string
                    var cv:Number = Number(colorParams[0]);
                    if (isNaN(cv)) cv = 0;
                    var clr:Color = new Color();
                    clr.setTint(cv, 0.5);
                    obj.transform.colorTransform = clr;
            }
        }
		
		public static function getColorMatrixFilterForBCSH(b:Number = 0,c:Number = 0,s:Number = 0,h:Number = 0):ColorMatrixFilter {
			return new ColorMatrixFilter(getColorMatrixArrayForBCSH(b, c, s, h));
		}
		
		public static function getColorMatrixArrayForBCSH(b:Number = 0,c:Number = 0,s:Number = 0,h:Number = 0):Array {
			var cf:AdjustColor = new AdjustColor();
			cf.brightness = b;
			cf.contrast = c;
			cf.saturation = s;
			cf.hue = h;
			return cf.CalculateFinalFlatArray();
		}
		
        
    }
}

