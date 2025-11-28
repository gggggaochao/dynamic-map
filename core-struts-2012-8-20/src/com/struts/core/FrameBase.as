package com.struts.core
{
import com.struts.events.AppEvent;
import com.struts.events.FrameEvent;

import flash.events.Event;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.events.EffectEvent;

import spark.effects.Fade;

public class FrameBase extends LayoutBase
{
	
	public var newChild : IVisualElement;
	
	public var currChild : IVisualElement;
	
	private var removeFade : Fade;
	
	private var addFade : Fade;
	
	public function FrameBase()
	{
		super();
	}
	
	
	
	private var _contendGroup : IVisualElementContainer;

	/**
	 *  加载模块的组件
	 * 
	 * */
	public function get contendGroup():IVisualElementContainer
	{
		if(!_contendGroup)
			_contendGroup = this as IVisualElementContainer;
		
		return _contendGroup;
	}

	public function set contendGroup(value:IVisualElementContainer):void
	{
		_contendGroup = value;
		
		
	}
	
	private var _isPlayEffect : Boolean = true;

	/**
	 *  是否执行加载时动画
	 * 
	 * */
	public function get isPlayEffect():Boolean
	{
		return _isPlayEffect;
	}

	public function set isPlayEffect(value:Boolean):void
	{
		_isPlayEffect = value;
		
		if(value) {
			loadFade();
		} else {
			removeFade = addFade = null;
		}
	}

	protected override function createChildren():void
	{
		super.createChildren();
		
		if(_isPlayEffect) {
			loadFade();
		}
	}
	
	private function loadFade() : void
	{
		removeFade = new Fade();
		removeFade.duration = 300;
		removeFade.alphaFrom = 1;
		removeFade.alphaTo = 0;
		removeFade.addEventListener(EffectEvent.EFFECT_END,removeFadeEffectEndHandler);
		
		addFade = new Fade();
		addFade.duration = 300;
		addFade.alphaFrom = 0;
		addFade.alphaTo = 1;	
	}
	
	private function removeFadeEffectEndHandler(event : Event) : void
	{
		if(contendGroup.numElements)
		{
			currChild = contendGroup.getElementAt(0);
			
			//dispatchEvent(new FrameEvent(FrameEvent.MODULE_REMOVE_FRAME,currChild));
			
			contendGroup.removeElement(currChild);	
			
		}
		
		if(newChild)
		{
			
			//dispatchEvent(new FrameEvent(FrameEvent.MODULE_ADD_FRAME,newChild));
			
			contendGroup.addElementAt(newChild,0);
			
			if(isPlayEffect) 
			{
				newChild.alpha = 0;
				addFade.target = newChild;
				addFade.play();
			}
			
		}			
		
	}

	
	override public function addComponents(child:IVisualElement):void
	{
		if(contendGroup)
		{
			newChild = child;
			playEffect();
		}
	}
	
	
	private function playEffect() : void
	{
		
		if(contendGroup.numElements)
		{
			if(isPlayEffect) 
			{
				currChild = contendGroup.getElementAt(0);
				removeFade.target = currChild;
				removeFade.play();
			} 
			else 
			{
				removeFadeEffectEndHandler(null);
			}
		}
		else
		{
			removeFadeEffectEndHandler(null);
		}
		
	}
}
}


















