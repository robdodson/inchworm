package com.inchworm.display
{
	import com.inchworm.core.IDestroyable;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;
	
	/**
	 * A Sprite which implements the IDestroyable interface. All listeners and signals added to this clip
	 * should be available for cleanup by calling its destroy method.
	 * 
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class DestroyableSprite extends Sprite implements IDestroyable
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		public var extra							:Object = {}; // convenience VO
		protected var _listeners					:Dictionary;
		protected var _isDestroyed					:Boolean = false;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A Sprite which implements the IDestroyable interface. All listeners and signals added to this clip
		 * should be available for cleanup by calling its destroy method.
		 * 
		 * @see #destroy() 
		 * 
		 */	
		public function DestroyableSprite()
		{
			super();
			_listeners = new Dictionary();
			this.tabEnabled=false;
		}
		
		/**
		 * addEventLisetener override to  add the listener to a Vector list that will be destroyed up calling the destroy method 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_listeners[type] = listener;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			if(_listeners && _listeners[type]) delete _listeners[type];
		}

		/**
		 * Utility method to remove all listeners from the sprite 
		 * 
		 */		
		public function removeAllListeners():void
		{
			for (var type:String in _listeners)
			{
				this.removeEventListener(type, _listeners[type]);
				delete _listeners[type];
			}
		}
		
		/**
		 * Utility method to remove all signals from the sprite 
		 * 
		 */		
		public function removeAllSignals():void
		{
			var type:XML = describeType(this);
			
			var signalList:XMLList = type..variable.( /osflash\.signals.*Signal/.test(@type) );
			var len:int = signalList.length();
			var target:String;
			for (var i:int=0;i<len;i++)
			{
				target = signalList[i].@name;
				if (this[target] != null)
				{
					if(this[target] is Signal)
						Signal(this[target]).removeAll();	
					
					if(this[target] is DeluxeSignal)
						DeluxeSignal(this[target]).removeAll();	
					
					if(this[target] is NativeSignal)
						NativeSignal(this[target]).removeAll();
					
					this[target] = null;
				}
			}
		}
		
		/**
		 * Determines if the object has been destroyed
		 * 
		 * @return Boolean indicating whether or not the current object has been destroyed
		 * 
		 * @see com.inchworm.core.IDestroyable
		 * 
		 */		
		public function get isDestroyed():Boolean
		{
			return this._isDestroyed;
		}

		/**
		 * Remove any event listeners and signals, stop all internal process, destroy all
		 * children which implement IDestroyable and remove the DisplayObject from its
		 * parent. 
		 * 
		 * @see com.inchworm.core.IDestroyable
		 * 
		 */				
		public function destroy():void
		{
			removeAllListeners();
			_listeners = null;
			
			removeAllSignals();
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:DisplayObject = this.getChildAt(0);
				if (child)
				{
					if (child is IDestroyable)
					{
						IDestroyable(child).destroy();
					}
				}
			}
			
			if (this.parent != null)
				this.parent.removeChild(this);
			
			this._isDestroyed = true;
		}
	}
}