package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;

	public class ReverseTintBehavior implements IStrategyButtonBehavior
	{
		protected var _duration		:Number;
		protected var _tint			:Number;
		protected var _tintAmount 	:Number;
		protected var _exposure		:Number;
		protected var _brightness	:Number;
		protected var _redMultiplier	:Number;
		protected var _redOffset	:Number;
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function ReverseTintBehavior(duration:Number = .5,tint:Number = 0x000000, tintAmount:Number = 0.5,exposure:Number =0, brightness:Number = 0, redMultiplier:Number = 0, redOffset:Number = 0)
		{
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
			tl.insert( TweenLite.to(target, _duration, {removeTint:true}));
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
			tl.insert( TweenLite.to(target, _duration, {colorTransform:{tint:_tint, tintAmount:_tintAmount, exposure:_exposure, brightness:_brightness, redMultiplier:_redMultiplier, redOffset:_redOffset}}));
			return tl;
		}
	}
}