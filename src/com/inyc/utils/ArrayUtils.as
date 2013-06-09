package com.inyc.utils {	import flash.display.MovieClip;
	/**	 * @author stevewarren	 */	public class ArrayUtils {				public function ArrayUtils() {		}						public static function arrayContainsValue(arr:Array, value:Object):Boolean		{			return (arr.indexOf(value) != -1);		}								public static function removeValueFromArray(arr:Array, value:Object):void		{			var len:uint = arr.length;						for(var i:Number = len; i > -1; i--)			{				if(arr[i] === value)				{					arr.splice(i, 1);				}			}							}				public static function clearArray(arr:Array):Array{			//trace("clearArray");						var item:Object;			for (var i:int=0;i<arr.length;i++){				item = arr.pop();								if (item is MovieClip){					item.removeChildren();					if (item.parent){						item.parent.removeChild(item);					}				}												item = null;				//trace("item"+item);			}			return arr;		}				public static function createUniqueCopy(a:Array):Array		{			var newArray:Array = new Array();						var len:Number = a.length;			var item:Object;						for (var i:uint = 0; i < len; ++i)			{				item = a[i];								if(ArrayUtils.arrayContainsValue(newArray, item))				{					continue;				}								newArray.push(item);			}						return newArray;		}								public static function copyArray(arr:Array):Array		{				return arr.slice();		}							public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean		{			if(arr1.length != arr2.length)			{				return false;			}						var len:Number = arr1.length;						for(var i:Number = 0; i < len; i++)			{				if(arr1[i] !== arr2[i])				{					return false;				}			}						return true;		}	}}