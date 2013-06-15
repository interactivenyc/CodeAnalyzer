package com.inyc.utils
{
	import com.inyc.utils.debug.Logger;
	
	public class PagingUtils
	{
		public function PagingUtils()
		{
			
		}
		
		/** 
		 * function initPageLayouts()
		 * 
		 * This is where we setup an array that processes the number of items 
		 * we're going to display, and distributes them so that the pages are more
		 * balanced. We don't ever want to see a page with a single item on it, so
		 * if we have 7 items to display, we break it into two pages with 4 and 3 items
		 * instead of two pages with 6 and 1 item.
		 **/
		
		
		public static function initPageLayouts(numItems:int, maxItemsPerPage:int):Array{
			var numPages:int = Math.ceil(numItems/maxItemsPerPage);
			var remainder:int = numItems%maxItemsPerPage;
			
			var itemCounts:Array = new Array();
			var maxLoops:int = 8;
			
			var currentItemCount:int;
			var firstItemCount:int;
			var lastItemCount:int;
			var secondToLastItemCount:int;
			var condition1:Boolean;
			var condition2:Boolean;
			var condition3:Boolean;
			
//			lo/g("\n******** [ initPageLayouts ] *********");
			
//			log("numItems: "+numItems+", numPages: "+numPages+", remainder: "+remainder);
			
			//if we have just one page, it doesn't need to be balanced
			if (numItems <= maxItemsPerPage){
				itemCounts.push(numItems);
				return itemCounts;
			}
			
			//create original itemCounts array, soon to be balanced
			for (var i:int=0; i<numPages-1; i++){
				itemCounts.push(maxItemsPerPage);
			}
			
			if (remainder == 0) {
				itemCounts.push(maxItemsPerPage);
			}else{
				itemCounts.push(remainder);
			}
//			log("---> pages to balance  itemCounts: "+itemCounts);
			
			
			//second to last item - last item
			var spread:int = itemCounts[itemCounts.length-2] - itemCounts[itemCounts.length-1];
			
			
			//balance itemArray
			while (spread > 1 && maxLoops > 0){
				for (i=itemCounts.length-1; i>-1; i--){
					
					//update named values
					currentItemCount = itemCounts[i-1];
					firstItemCount = itemCounts[0];
					lastItemCount = itemCounts[itemCounts.length-1];
					secondToLastItemCount = itemCounts[itemCounts.length-2];
					
					
//					log("*********************************");
//					log("itemCounts: "+itemCounts);
//					log("currentIndex: "+i+", value: "+currentItemCount);
					
					
					condition1 = currentItemCount > (secondToLastItemCount - 2);
					condition2 = (secondToLastItemCount - lastItemCount) >= 1;
					condition3 = firstItemCount > (lastItemCount - 2);
					
//					log("conditions: "+condition1+" : "+condition2+" : "+condition3);
					
					
					//MODIFY ITEM COUNTS
					if (condition1 && condition2 && condition3){
//						log("currentItem: "+itemCounts[i-1]+", lastItem: "+lastItemCount+", spread: "+spread);
						itemCounts[i-1]--;  //currentItemCount
						itemCounts[itemCounts.length-1]++;   //lastItemCount
						
					}else{
//						log("break");
						break;
					}
					
					//start loop over when index reaches zero
					if (i==0) i = itemCounts.length-1
				}
				
				
				
				//update modified values
				lastItemCount = itemCounts[itemCounts.length-1];
				secondToLastItemCount = itemCounts[itemCounts.length-2];
				
				//second to last item - last item
				spread = secondToLastItemCount - lastItemCount;
				
				maxLoops--;
				
			}
			
			
//			log("*********************************");
//			log("pageLayout: "+itemCounts);
//			log("****** [ /initPageLayouts ] *******\n");
//			log("");
			
			return itemCounts;
		}
		
		
		
		private static function log(logItem:*):void {
			Logger.log(logItem,["PagingUtils"],true);
		}
	}
}