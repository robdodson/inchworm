package com.inchworm.display.buttons.behaviors
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.FrameLabelPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	
	public class LabelBehavior implements IStrategyButtonBehavior
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _overLabel					:String;
		protected var _outLabel						:String;
		
		//————————————————————————————————————————————————————————————————
		
		public function LabelBehavior(overLabel:String = 'OVER', outLabel:String = 'OUT')
		{
			TweenPlugin.activate([FrameLabelPlugin]);
			
			_overLabel = overLabel;
			_outLabel = outLabel;
		}
		
		public function animateOver(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, 0, {frameLabel: _overLabel}));
			return tl;
		}
		
		public function animateOut(target:Sprite):TimelineLite
		{
			var tl:TimelineLite = new TimelineLite();
			tl.insert( TweenLite.to(target, 0, {frameLabel: _outLabel}));
			return tl;
		}
	}
}