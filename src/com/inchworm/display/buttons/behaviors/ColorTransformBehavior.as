package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	
	public class ColorTransformBehavior implements IStrategyButtonBehavior
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _duration			:Number;
		protected var _redMultiplier	:Number;
		protected var _redOffset		:Number;
		protected var _greenMultiplier	:Number;
		protected var _greenOffset		:Number;
		protected var _blueMultiplier	:Number;
		protected var _blueOffset		:Number;
		
		//————————————————————————————————————————————————————————————————
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function ColorTransformBehavior(
			duration:Number = .3,
			redMultiplier:Number = 1,
			redOffset:Number = 0,
			greenMultiplier:Number = 1,
			greenOffset:Number = 0,
			blueMultiplier:Number = 1,
			blueOffset:Number = 0
		)
			
		{
			TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);
			
			_duration = duration;
			_redMultiplier = redMultiplier;
			_redOffset = redOffset;
			_greenMultiplier = greenMultiplier;
			_greenOffset = greenOffset;
			_blueMultiplier = blueMultiplier;
			_blueOffset = blueOffset;
		}
		
		/*
		Method: animateOver 
		Parameters: target:Sprite
		Returns:
		*/
		public function animateOver(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, _duration, {colorTransform:{ 
				redMultiplier: _redMultiplier,
				redOffset: _redOffset,
				greenMultiplier: _greenMultiplier,
				greenOffset: _greenOffset, 
				blueMultiplier: _blueMultiplier,
				blueOffset: _blueOffset
			}}));
			
			return tl;
		}
		
		/*
		Method: animateOut
		Parameters: target:Sprite
		Returns:
		*/
		public function animateOut(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, _duration, {colorTransform:{ 
				redMultiplier: 1,
				redOffset: 0,
				greenMultiplier: 1,
				greenOffset: 0, 
				blueMultiplier: 1,
				blueOffset: 0
			}}));
			return tl;
		}
	}
}