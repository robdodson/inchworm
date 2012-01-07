package com.inchworm.display.animation
{
	import flash.events.Event;
	
	public class AnimationEvent extends Event
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		
		public static const INIT				:String = 'INIT';
		public static const IN_START			:String = 'IN_START';
		public static const IN					:String = 'IN';
		public static const OUT_START			:String = 'OUT_START';
		public static const OUT					:String = 'OUT';
		
		//————————————————————————————————————————————————————————————————
		
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new AnimationEvent(type, bubbles, cancelable);
		}
	}
}