package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.Sprite;

	public class PulseBehavior implements IStrategyButtonBehavior
	{
		
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _duration			:Number;
		protected var _scale_x			:Number;
		protected var _scale_y			:Number;
		
		//————————————————————————————————————————————————————————————————
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function PulseBehavior(duration:Number=.6,scaleX:Number = 1.1, scaleY:Number=1.1)
		{
			_duration = duration;
			_scale_x = scaleX;
			_scale_y = scaleY;
		}
		/*
		Method: animateOver 
		Parameters: target:Sprite
		Returns:
		*/
		public function animateOver(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, _duration, {scaleX: _scale_x, scaleY: _scale_y, ease: Elastic.easeOut}));
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
			tl.insert( TweenLite.to(target, _duration, {scaleX: 1, scaleY: 1, ease: Elastic.easeOut}));
			return tl;
		}
	}
}