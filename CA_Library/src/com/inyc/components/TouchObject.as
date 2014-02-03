package com.inyc.components {	import com.inyc.core.CoreMovieClip;	import com.inyc.events.AppEvents;	import com.inyc.events.GenericDataEvent;		import flash.events.MouseEvent;	import flash.events.TransformGestureEvent;
	/**	 * @author stevewarren	 */	public class TouchObject extends CoreMovieClip {				public function TouchObject(){			//log("TouchObject CONSTRUCTOR");						doubleClickEnabled = true;		}				override protected function init():void{			this.addEventListener(MouseEvent.CLICK, onMouseEvent);						stage.addEventListener(TransformGestureEvent.GESTURE_PAN, onGestureEvent);			stage.addEventListener(TransformGestureEvent.GESTURE_ROTATE, onGestureEvent);			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onGestureEvent);			stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onGestureEvent);		}						protected function onMouseEvent(e:MouseEvent):void{			//log("onMouseEvent e.type:"+e.type + "this:"+this + "this.parent.name:"+this.parent.name);			//log(this.parent.parent + ":" +this.parent.name+":"+this);						if (e.target == e.currentTarget){				switch (e.type){					case MouseEvent.CLICK:						stage.dispatchEvent(new GenericDataEvent(AppEvents.TOUCH_OBJECT_CLICKED, {touchObject:this}));											break;					case MouseEvent.DOUBLE_CLICK:						stage.dispatchEvent(new GenericDataEvent(AppEvents.TOUCH_OBJECT_DOUBLE_CLICKED, {touchObject:this}));											break;					default:				}			}		}										protected function onGestureEvent(e:TransformGestureEvent):void {			//log("onGestureEvent:"+e.type);			switch (e.type){				case TransformGestureEvent.GESTURE_PAN:					break;				case TransformGestureEvent.GESTURE_ROTATE:					break;				case TransformGestureEvent.GESTURE_SWIPE:					log("onGestureEvent "+TransformGestureEvent.GESTURE_SWIPE);					break;				case TransformGestureEvent.GESTURE_ZOOM:					break;			}		}					}}