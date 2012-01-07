package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Sprite;

	public class AlphaBehavior implements IStrategyButtonBehavior
	{
		protected var _duration	:Number;
		protected var _alpha	:Number;
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function AlphaBehavior(duration:Number = .3, alpha:Number =.5 )
		{
			_duration = duration;
			_alpha = alpha;
		}

		public function animateOver(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, _duration, {alpha:_alpha, ease: Cubic.easeOut}));
			return tl;
		}

		public function animateOut(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, _duration, {alpha: 1, ease: Cubic.easeIn}));
			return tl;
		}
	}
}