package com.inchworm.display.views
{
	import com.inchworm.display.animation.AnimationInOut;

	/**
	 * A destroyable view which implements an AnimationInOut object to keep track of its state.
	 * The InOutTimelineView is meant to be the base class for one of your view classes created
	 * in the Flash IDE. The view must include the following labels: 'INIT', 'IN_START', 'IN',
	 * 'OUT_START', 'OUT'
	 *  
	 * @author Rob Dodson
	 * 
	 */	
	public class InOutTimelineView extends AbstractView
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _inOut					:AnimationInOut;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A destroyable view which implements an AnimationInOut object to keep track of its state.
		 * The InOutTimelineView is meant to be the base class for one of your view classes created
		 * in the Flash IDE. The view must include the following labels: 'INIT', 'IN_START', 'IN',
		 * 'OUT_START', 'OUT'
		 * 
		 */		
		public function InOutTimelineView()
		{
			super();

			_inOut = new AnimationInOut(this);
			_inOut.animationInStart.add(_onAnimationInStart);
			_inOut.animationIn.add(_onAnimationIn);
			_inOut.animationOutStart.add(_onAnimationOutStart);
			_inOut.animationOut.add(_onAnimationOut);
		}
		
		/**
		 * Instruct the view to begin animating in. The view must implement an
		 * 'IN_START' and 'IN' label. 
		 * 
		 */		
		override public function animateIn(callback:Function = null):void
		{
			super.animateIn(callback);
			_inOut.animateIn();
		}
		
		/**
		 * Instruct the view to begin animating out. The view must implement an
		 * 'OUT_START' and 'OUT' label. 
		 * 
		 */		
		override public function animateOut(callback:Function = null):void
		{
			super.animateOut(callback);
			_inOut.animateOut();
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationInStart():void
		{
			this.inStart.dispatch();
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationIn():void
		{
			this.inComplete.dispatch();
			if (_inCallback != null) _inCallback.call(null, this);
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationOutStart():void
		{
			this.outStart.dispatch();
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationOut():void
		{
			this.outComplete.dispatch();
			if (_outCallback != null) _outCallback.call(null, this);
		}
	}
}