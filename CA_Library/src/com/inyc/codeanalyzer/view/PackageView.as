package com.inyc.codeanalyzer.view
{
	import com.inyc.codeanalyzer.models.PackageItem;
	import com.inyc.core.CoreMovieClip;
	import com.inyc.utils.MovieClipUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PackageView extends CoreMovieClip{
		
		private var _packageItem:PackageItem;
		private var _classes:Vector.<ClassView> = new Vector.<ClassView>();
		
		public var bg:MovieClip;
		public var container:MovieClip;
		
		private var _packageLabel:MovieClip;
		
		public function PackageView(packageItem:PackageItem){
			super();
			_packageItem = packageItem;
			
			bg = MovieClipUtils.getFilledMC(100,100, 0xFFEEEE, true);
			addChildAt(bg, 0);
			
			
			
			_packageLabel = new TF_10pt_white_MC();
			_packageLabel.x = 5;
			_packageLabel.label.text = _packageItem.packageString;
			_packageLabel.mouseEnabled = false;
			_packageLabel.mouseChildren = false;
			
			
			var tfbg:MovieClip = MovieClipUtils.getFilledMC(_packageLabel.label.textWidth + 15, 26, 0x740000);
			addChild(tfbg);
			tfbg.addChild(_packageLabel);
			
			tfbg.addEventListener(MouseEvent.CLICK, onMouseEvent);
			tfbg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			tfbg.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			tfbg.addEventListener(MouseEvent.RELEASE_OUTSIDE, onMouseEvent);
			
			container = new MovieClip();
			container.x = AppView.CELLPADDING;
			container.y = AppView.CELLPADDING + _packageLabel.height;
			addChild(container);
		}
		
		override protected function onAddedToStage(e:Event):void{
			super.onAddedToStage(e);
			
		}
		
		public function addClass(classView:ClassView):void{
			_classes.push(classView);
			if (_classes.length > 1){
				classView.x = _classes[_classes.length-2].x + _classes[_classes.length-2].width + AppView.CELLPADDING;
			}
			
			classView.addEventListener(MouseEvent.MOUSE_DOWN, onClassViewClicked);
			
			container.addChild(classView);
			
			bg.width = container.width + (AppView.CELLPADDING*2);
			bg.height = container.y + container.height + (AppView.CELLPADDING*2);
			
			
		}
		
		protected function onClassViewClicked(e:MouseEvent):void{
			container.addChild(e.currentTarget as ClassView);
		}
		
		protected function onMouseEvent(e:MouseEvent):void{
			//log("onMouseEvent: "+e.type+" :: "+e.currentTarget);
			
			switch(e.type){
				case MouseEvent.CLICK:
					
					break
				case MouseEvent.MOUSE_DOWN:
					log("start dragging: MOUSE_DOWN name: "+name);
					startDrag();
					break;
				case MouseEvent.MOUSE_UP:
					log("stop dragging: MOUSE_UP name: "+name);
					stopDrag();
					break;
				case MouseEvent.RELEASE_OUTSIDE:
					log("stop dragging: RELEASE_OUTSIDE name: "+name);
					stopDrag();
					break;
			}
		}
		
	}
}