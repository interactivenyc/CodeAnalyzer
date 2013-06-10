package com.speakaboos.ipad.view{	import com.speakaboos.ipad.controller.AppController;	import com.speakaboos.ipad.events.AppEvents;	import com.speakaboos.ipad.events.GenericDataEvent;	import com.speakaboos.ipad.events.NavEvents;	import com.speakaboos.ipad.models.services.SpeakaboosService;	import com.speakaboos.ipad.utils.ColorUtil;	import com.speakaboos.ipad.utils.MovieClipUtils;	import com.speakaboos.ipad.utils.PagingUtils;	import com.speakaboos.ipad.view.holders.CoreMovieClipHolder;	import com.speakaboos.story.utils.AnimationPlayer;	import com.speakaboos.story.utils.AudioPlayer;		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.events.Event;

	public class CoreListingsView extends CoreMovieClipHolder	{		protected var _pageLayouts:PageLayouts;				protected var _pageFlip:PageFlip;				protected var _itemCounts:Array;		protected var _pageDirection:int = 1;		protected var _fromForwardBackButton:Boolean;				public var numPages:int;		protected var _maxItemsPerPage:int = 6;				protected var _listingsItems:Array;						protected var nextLeftBitmap:Bitmap;		protected var nextRightBitmap:Bitmap;		private var _nextPageIndex:int;		private var _itemCount:int;		private var _frameCounter:int=4;		private var _book:BookView;						public function CoreListingsView(){			super(new MovieClip());					}				override public function onAddedToStage(e:Event = null):void{			super.onAddedToStage(e);						var listings:Array = getListings();			var numItems:int = listings.length;						log("AppController.viewMode: "+AppController.MODE_CATEGORIES);			log("initPageLayouts _numItems: "+numItems+", _maxItemsPerPage: "+_maxItemsPerPage);						_itemCounts = PagingUtils.initPageLayouts(numItems, _maxItemsPerPage);						log("itemCounts: "+_itemCounts);						_book = BookView.getInstance();			setPage();		}									override public function onRemovedFromStage(e:Event = null):void{			super.onRemovedFromStage(e);//			mc.removeChildren();//			destroyListingsItems();			destroy();		}				private function getListings():Array{			log("getListings "+ AppController.viewMode);			var listings:Array;			var service:SpeakaboosService = SpeakaboosService.getInstance();						//Set Listings Type here with AppController.viewMode			if (AppController.viewMode == AppController.MODE_CATEGORIES){				listings = service.categories;			}else{				listings = service.stories;			}			return listings;		}				public function turnPage(pageDirection:int):void{			log("turnPage: "+pageDirection);			_pageDirection = pageDirection;			var currentPageIndex:int = _book.getPageIndex();						_nextPageIndex = currentPageIndex + pageDirection;						if (_nextPageIndex == -1) {				return;			}			if (_nextPageIndex == numPages) {				return;			}						_itemCount = _itemCounts[currentPageIndex];			_eventDispatcher.addEventListener(AppEvents.UPDATED_BITMAPS, skipAnimOut);						log("*** Event: CAPTURE_LAYOUT_BITMAPS");			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.CAPTURE_LAYOUT_BITMAPS));					}		protected function animOutFinished(e:Event):void{			_frameCounter --;									if (_frameCounter == 0){				_frameCounter = 4;				removeEventListener(Event.ENTER_FRAME, animOutFinished);				BookView.getInstance().setPageIndex(_nextPageIndex);				setPage(true);			}					}				protected function skipAnimOut(e:GenericDataEvent = null):void{			log("skipAnimOut");			_eventDispatcher.removeEventListener(AppEvents.UPDATED_BITMAPS, skipAnimOut);			BookView.getInstance().setPageIndex(_nextPageIndex);			setPage(true);		}						protected function setPage(fromForwardBack:Boolean = false):void{			var i:int;			var currentPageIndex:int = _book.getPageIndex();			log("setPageIndex: "+currentPageIndex+", "+(_listingsItems && _listingsItems.length));			destroyListingsItems();						var listing:CoreMovieClipHolder; //reused variable - each item on the page			_listingsItems = new Array(); //push items into this array that will appear on this page						_itemCount = _itemCounts[currentPageIndex] //the number of items on this page			var startIndex: int = 0; //start with this item in the _stories array, and count from there			var thisIndex:int; //use inside the for loop for counting up from startIndex						numPages = _itemCounts.length;						//count number of items on previous pages to find out which item we should start with			for (i = 0; i<currentPageIndex; i++){				startIndex += _itemCounts[i];			}			var listings:Array = getListings();			//log("setpage startIndex: "+startIndex);			for(i=0; i<_itemCount; i++){				thisIndex = i + startIndex;								//Set Listings Type here with AppController.viewMode				if (AppController.viewMode == AppController.MODE_CATEGORIES){					listing = new HomeCategoryListing(listings[thisIndex], _pageDirection);										//set title.visible to false					//listing.mc.title.visible = false;										_listingsItems.push(listing);				}else if (AppController.viewMode == AppController.MODE_STORIES){					listing = new StoryListing(listings[thisIndex], _pageDirection);					_listingsItems.push(listing);				}			}						log("\n***************** [ setPage ] ********************");			log("*** setPage page: " + (currentPageIndex+1) + " of "+numPages + " :: _pageDirection: "+_pageDirection+", itemCount: "+_itemCount);			log("***************** [ /setPage ] ********************\n");						setupPageLayouts(fromForwardBack);						_eventDispatcher.dispatchEvent(new GenericDataEvent(NavEvents.SET_PAGE, {pageIndex:currentPageIndex, numPages:numPages}));					}				protected function setupPageLayouts(fromForwardBack:Boolean = false):void{			//log("setupPageLayouts AppController.viewMode: "+AppController.viewMode);						if (_pageLayouts != null){				removeChild(_pageLayouts);				_pageLayouts.destroy();				_pageLayouts = null;			}						if (AppController.viewMode == AppController.MODE_CATEGORIES){				_pageLayouts = new HomePageLayouts();			}else{				_pageLayouts = new CategoryPageLayouts();			}						if (_book.suppressPageFlips == true){				skipPageFlips();			}else{				createPageFlips(fromForwardBack);			}		}				private function skipPageFlips():void{			log("* skipPageFlips");			var currentPageIndex:int = _book.getPageIndex();			addPageLayouts();			AnimationPlayer.getInstance().killAnimationMonitors();			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.PAGE_FLIP_FINISHED));			AppController.newSection = false;			AppController.categoryBack = false;						var rightMC:MovieClip = new MovieClip();			var leftMC:MovieClip = new MovieClip();						if (AppController.viewMode == AppController.MODE_STORIES){				log("colorize book pages: "+SpeakaboosService.getInstance().category.category_screen_page_color);								rightMC.addChild(MovieClipUtils.getLibraryMC("path_"+_itemCounts[currentPageIndex]+"_right"));				leftMC.addChild(MovieClipUtils.getLibraryMC("path_"+_itemCounts[currentPageIndex]+"_left"));												var rightMCBitmapData:BitmapData = MovieClipUtils.getBitmapDataFromMC(rightMC);				var leftMCBitmapData:BitmapData = MovieClipUtils.getBitmapDataFromMC(leftMC);				var rightMCBitmap:Bitmap = new Bitmap(rightMCBitmapData);				var leftMCBitmap:Bitmap = new Bitmap(leftMCBitmapData);								ColorUtil.colorize(rightMCBitmap, SpeakaboosService.getInstance().category.category_screen_page_color);				ColorUtil.colorize(leftMCBitmap, SpeakaboosService.getInstance().category.category_screen_page_color);			}			_book.setPages(leftMCBitmap, rightMCBitmap);		}				private function createPageFlips(fromForwardBack:Boolean = false):void{			log("*** createPageFlips _pageDirection: "+_pageDirection+" AppController.newSection: "+AppController.newSection);			var currentPageIndex:int = _book.getPageIndex();												/**			 * SKIP THE FIRST PAGE FLIP			 **/			if (AppController.categoryPageInitialized == false){				log("* AppController.categoryPageInitialized = false");				AppController.categoryPageInitialized = true;				AppController.newSection = false;				addPageLayouts();				_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.SHOW_PAGE_BUTTONS));								return;			}												/**			 * Here is where we have the opportunity to override pageflip direction for backing out of stories and categories			 */						if (_pageDirection == 1 && AppController.categoryBack == false){				_pageFlip = MovieClipUtils.getLibraryMC("FlipForward") as PageFlip;			}else{				if (_pageDirection == 1) log (" newSection: "+AppController.newSection+" :: REVERSING PAGE DIRECTION");				_pageDirection == -1;				_pageFlip = MovieClipUtils.getLibraryMC("FlipBack") as PageFlip;			}									_pageFlip.numIcons = _itemCounts[currentPageIndex];			_pageFlip.direction = _pageDirection;			BookView.getInstance().addChild(_pageFlip);						_fromForwardBackButton = fromForwardBack;									//TODO: Need to add logic to switch to multi page turn			if(_fromForwardBackButton) {				AudioPlayer.getInstance().playInternalSound(AudioPlayer.SOUND_SINGLE_PAGE_TURN);			} else {				AudioPlayer.getInstance().playInternalSound(AudioPlayer.SOUND_MULTI_PAGE_TURN);			}						_pageFlip.addEventListener(AppEvents.ANIM_FINISHED, onFlipFinished);		}								private function onFlipFinished(e:Event):void{			log("onFlipFinished");									AppController.newSection = false;			AppController.categoryBack = false;						log("*** Event: ANIM_FINISHED");			_pageFlip.removeEventListener(AppEvents.ANIM_FINISHED, onFlipFinished);						copyPagesToBookView();			addPageLayouts();			BookView.getInstance().removeChild(_pageFlip);						AnimationPlayer.getInstance().killAnimationMonitors();			_eventDispatcher.dispatchEvent(new GenericDataEvent(AppEvents.PAGE_FLIP_FINISHED));		}				private function copyPagesToBookView():void{			log("*** copyPagesToBookView");						if (AppController.viewMode == AppController.MODE_STORIES){				var nextLeft:DisplayObject = _pageFlip.nextLeft.container.getChildAt(0);				var nextRight:DisplayObject = _pageFlip.nextRight.container.getChildAt(0);								BookView.getInstance().pageLeft.container.removeChildren();				BookView.getInstance().pageRight.container.removeChildren();				BookView.getInstance().pageLeft.container.addChild(nextLeft);				BookView.getInstance().pageRight.container.addChild(nextRight);			}else{				BookView.getInstance().pageLeft.container.removeChildren();				BookView.getInstance().pageRight.container.removeChildren();				BookView.getInstance().pageLeft.container.addChild(MovieClipUtils.getLibraryMC("left_category").container.getChildAt(0));				BookView.getInstance().pageRight.container.addChild(MovieClipUtils.getLibraryMC("right_category").container.getChildAt(0));			}		}								private function addPageLayouts():void{			log("addPageLayouts");			addChild(_pageLayouts);			_pageLayouts.setListings(_listingsItems, _pageDirection, _fromForwardBackButton);			_fromForwardBackButton = false;		}				private function destroyListingsItems():void {			log("destroyListingsItems");			var i:int;			if (_listingsItems) {				for (i = 0; i < _listingsItems.length; i++) {					if (_listingsItems[i]) {						_listingsItems[i].destroy;						_listingsItems[i] = null;					}				}			} 		}				override public function destroy():void {			//TODO: flesh this out			log("destroy");			AnimationPlayer.getInstance().killAnimationMonitors();			destroyListingsItems();			_pageLayouts.destroy();			super.destroy();		}	}}
