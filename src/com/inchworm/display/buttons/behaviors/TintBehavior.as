package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;

	public class TintBehavior implements IStrategyButtonBehavior
	{
		protected var _duration			:Number;
		protected var _tint				:Number;
		protected var _tintAmount 		:Number;
		protected var _exposure			:Number;
		protected var _brightness		:Number;
		protected var _redMultiplier	:Number;
		protected var _redOffset		:Number;
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function TintBehavior(duration:Number = .5,tint:Number=0xcccccc,tintAmount:Number=.8,exposure:Number =0, brightness:Number = 0, redMultiplier:Number = 0, redOffset:Number = 0)
		{
			TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);
			
			_duration = duration;
			_tint = tint;
			_tintAmount = tintAmount;
			_exposure = exposure;
			_brightness = brightness;
			_redMultiplier = redMultiplier;
			_redOffset = redOffset;
		}
		/*
		Method: animateOver
		Parameters:
		Returns:
		*/
		public function animateOver(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, _duration, {colorTransform:{tint:_tint, tintAmount:_tintAmount, exposure:_exposure, brightness:_brightness, redMultiplier:_redMultiplier, redOffset:_redOffset}}));
			return tl;
		}
		/*
		Method: animateOut
		Parameters:
		Returns:
		*/
		public function animateOut(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, .5, {removeTint:true}));
			return tl;
		}
	}
}