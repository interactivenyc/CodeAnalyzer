﻿package com.inyc.components{	import com.inyc.core.CoreMovieClip;		import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Rectangle;
	public class ListingsPanel extends CoreMovieClip	{				public var container:MovieClip;		public var panelMask:DisplayObject;		public var bg:MovieClip;		private var _listings:Array;		private var _listingsType:Class;		private var _mcLoaded:Boolean = false;						public function ListingsPanel(){			log("constructor");		}						override protected function onAddedToStage(e:Event):void{			super.onAddedToStage(e);			container.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);			_mcLoaded = true;			if (_listings != null) update();		}				override protected function onRemovedFromStage(e:Event):void{			super.onAddedToStage(e);			}				public function getListings():Array{			return _listings;		}				public function setListings(listings:Array, listingsType:Class = null):void{			if (listingsType == null){				_listingsType = ListingsItem;			}else{				_listingsType = listingsType;			}			_listings = listings;			if(_mcLoaded) update();		}				private function update():void{						log("updating");			var listingsItem:ListingsItem;						for (var i:int=0; i<_listings.length; i++){				listingsItem = new _listingsType();				listingsItem.listingsData = _listings[i];				listingsItem.y = listingsItem.height * i;				container.addChild(listingsItem);			}		}				private function startDragging(e:MouseEvent):void{			if (container.height < panelMask.height) return;			container.startDrag(false, new Rectangle(container.x, 0, 0, -(container.height - panelMask.height)));			container.addEventListener(MouseEvent.MOUSE_MOVE, onDragging);			container.addEventListener(MouseEvent.MOUSE_UP, stopDragging);			container.addEventListener(MouseEvent.RELEASE_OUTSIDE, stopDragging);		}				private function onDragging(e:MouseEvent):void{			//log(container.x + " : " + container.y);		}				private function stopDragging(e:MouseEvent):void{			container.stopDrag();			container.removeEventListener(MouseEvent.MOUSE_MOVE, onDragging);			container.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);			container.removeEventListener(MouseEvent.RELEASE_OUTSIDE, stopDragging);		}								public function deleteListing(searchStr:String):void{						var len:int = _listings.length;			if(!len){				log("_listings array is empty");				return;			}						var found:Boolean = false;						//TODO			/*			make this more generic so it doesn't refer to 'slug'			*/						for(var i:int = len-1; i >= 0; i--){				log("current listing: " + i + "slug: '" + _listings[i].slug + "' searchStr: '" + searchStr + "'");				if(_listings[i].slug == searchStr){					_listings.splice(i,1);					container.removeChildAt(i);					log("deleted slug:" + searchStr + ", item: " + i);										found = true;					log("found...breaking...");										break;				}			}						if(found){				log("refreshing...");				refresh();			}			else				log("could not find slug: " + searchStr + "in _listings array");					}				public function refresh():void{						//TODO			/*				improve this.  it's too expensive			*/			log("refresh");			container.removeChildren();			update();		}							}}