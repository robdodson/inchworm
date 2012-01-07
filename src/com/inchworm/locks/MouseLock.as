package com.inchworm.locks
{
	
	import com.inchworm.core.IDestroyable;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	/**
	 * MouseLock lets you specify an array of locking and unlocking signals which will tell the Object
	 * when to invoke mouseChildren = false/true on its target. You can use this to easily lock
	 * and unlock your views instead of having to sprinkle the page with mouseEnabled = false / mouseChildren = false
	 * If you choose not to use Signals then you can explicitly call the lock/unlock
	 * methods yourself
	 * 
	 * @author Rob Dodson
	 * 
	 */	
	public class MouseLock implements IDestroyable
	{
		//----------------------------------------------------------------
		// CLASS MEMBERS
		private var _target					:DisplayObjectContainer;
		private var _lockSignals			:Array;
		private var _unlockSignals			:Array;
		private var _isDestroyed			:Boolean;
		private var _listeners				:Dictionary
		
		//----------------------------------------------------------------
		
		/**
		 * Pass in an array of Signals to indicate when the view should have its mouse actions disabled,
		 * and another array of Signals to indicate when it should have its mouse actions reinstated.
		 *  
		 * @param target: The Movieclip which will have its mouse actions disabled/enabled 
		 * @param lockSignals: An array of Signals to listen to which indicate when the target should have its mouse actions disabled
		 * @param unlockSignals: An array of Signals to listen to which indicate when the target should have its mouse actions enabled
		 * 
		 */		
		public function MouseLock(target:DisplayObjectContainer, lockSignals:Array = null, unlockSignals:Array = null)
		{
			_target = target;
			_lockSignals = lockSignals;
			_unlockSignals = unlockSignals;
			_listeners = new Dictionary();
			
			if (lockSignals && lockSignals.length)
			{
				_addListeners(_lockSignals, lock);
				_addListeners(_unlockSignals, unlock);
			}
		}
		
		private function _addListeners(signals:Array, listener:Function):void
		{
			var len:int = signals.length;
			for(var i:int = 0; i < len; ++i)
			{
				Signal(signals[i]).add(listener);
				_listeners[signals[i]] = listener;
			}
		}
		
		private function _removeListeners():void
		{
			for each ( var signal:Signal in _listeners )
			{
				signal.remove( _listeners[signal] );
			}
		}
		
		public function lock():void
		{
			_target.mouseChildren = false;
			_target.mouseEnabled = false;
		}
		
		public function unlock():void
		{
			_target.mouseChildren = true;
			_target.mouseEnabled = true;
		}
		
		public function destroy():void
		{
			_removeListeners();
			_isDestroyed = true;
		}

		public function get isDestroyed():Boolean
		{
			return _isDestroyed;
		}
	}
}
