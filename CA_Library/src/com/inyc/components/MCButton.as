﻿package com.inyc.components{	import com.greensock.TweenMax;	import com.greensock.plugins.ColorTransformPlugin;	import com.greensock.plugins.TintPlugin;	import com.greensock.plugins.TweenPlugin;	import com.inyc.core.CoreButton;		import flash.events.Event;	import flash.events.MouseEvent;
	public class MCButton extends CoreButton	{		public function MCButton(){			super();			TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);		}				override protected function onAddedToStage(e:Event):void{			super.onAddedToStage(e);		}				override protected function onRemovedFromStage(e:Event):void{			super.onRemovedFromStage(e);		}				protected function set downState(down:Boolean):void{			//log("set downState: "+down + ", "+this);			if (down){				alpha = .5;			}else{				alpha = 1;			}		}						override protected function onMouseEvent(e:MouseEvent):void{			super.onMouseEvent(e);			switch(e.type){				case MouseEvent.MOUSE_DOWN:					downState = true;					break;				case MouseEvent.MOUSE_UP:					downState = false;					break;				case MouseEvent.RELEASE_OUTSIDE:					downState = false;					break;			}		}			}}