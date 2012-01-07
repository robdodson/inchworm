package com.inchworm.display.views
{
	import com.inchworm.display.DestroyableMovieClip;
	
	import flash.errors.IllegalOperationError;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;

	/**
	 * An abstract view which is designed to easily facilitate in and out animations.
	 * The view creates in and out signals but is otherwise meant to be extended.
	 * 
	 * @author Rob Dodson
	 * @author Justin Gaussion
	 * 
	 */	
	public class AbstractView extends DestroyableMovieClip
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		
		/**
		 * Dispatched when the view begins to animate in 
		 */		
		public var inStart						:Signal = new Signal();
		
		/**
		 * Dispatched when the view has finished animating in 
		 */		
		public var inComplete					:Signal = new Signal();
		
		/**
		 * Dispatched when the view begins to animate out 
		 */		
		public var outStart						:Signal = new Signal();
		
		/**
		 * Dispatched when the view has finished animating out 
		 */		
		public var outComplete					:Signal = new Signal();
		
		/**
		 * An optional callback function which a subclass can call when
		 * the view has finished animating in. 
		 */		
		protected var _inCallback				:Function;
		
		/**
		 * An optional callback function which a subclass can call when
		 * the view has finished animating out.
		 */		
		protected var _outCallback				:Function;
		
		//————————————————————————————————————————————————————————————————

		/**
		 * An abstract view which is designed to easily facilitate in and out animations.
		 * The view creates in and out signals but is otherwise meant to be extended.
		 * 
		 */		
		public function AbstractView()
		{
			super();
		}
		
		/**
		 * Abstract animateIn method for telling the view to begin its 'in' animation
		 * 
		 */		
		public function animateIn(callback:Function = null):void
		{
			_inCallback = callback;
		}

		/**
		 * Abstract animateOut method for telling the view to begin its 'out' animation
		 * 
		 */		
		public function animateOut(callback:Function = null):void
		{
			_outCallback = callback;
		}
	}
}