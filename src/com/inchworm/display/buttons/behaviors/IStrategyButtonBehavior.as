package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	
	import flash.display.Sprite;

	public interface IStrategyButtonBehavior
	{
		function animateOver(target:Sprite):TimelineLite;
		function animateOut(target:Sprite):TimelineLite;
	}
}