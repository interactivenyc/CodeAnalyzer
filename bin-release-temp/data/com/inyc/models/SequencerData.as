package com.inyc.models {	import com.inyc.utils.debug.Logger;		/**	 * @author stevewarren	 */	public class SequencerData extends Object{				// SEQUENCER DATA IS AN ARRAY THAT FOLLOWS THIS MODEL:		//[{time:int, type:String, attributes:Object}] - pre-sorted by time		public var array:Array;				public function SequencerData(){			//log("constructor");		}				public function setDataArray(pData:Array):void{			array = pData;		}				protected function log(logItem:*):void {			Logger.log("[ SequencerData ] : " + logItem);		}					}}