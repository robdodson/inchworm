package com.inchworm.display.buttons
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.inchworm.core.IDestroyable;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class StrategyButton implements IDestroyable
	{
		
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		public var clicked						:Signal;
		
		private var _button						:MovieClip;
		private var _enabled					:Boolean;
		private var _mouseEnabled				:Boolean;
		private var _mouseChildren				:Boolean;
		private var _isDestroyed				:Boolean;
		public var behaviors					:Array;
		public var vars							:Object; // Store extra stuffs in here! It's like a mo'fuckin backpack!
		
		//————————————————————————————————————————————————————————————————
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function StrategyButton(targetButton:MovieClip, buttonBehavior:Array)
		{
			clicked = new Signal();
			vars = {};
			
			_button = targetButton;
			behaviors = buttonBehavior;
			
			addListeners();
		}
		
		// TODO: Allow timeline or code states
		
		/*
		Method: selected
		Parameters:
		Returns:
		*/
		public function selected(disableListeners:Boolean = true):void
		{
			if(disableListeners) removeListeners();

			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOver(_button) );
			}
		}
		
		/*
		Method: reset
		Parameters:
		Returns:
		*/
		public function reset(enableListeners:Boolean = true):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOut(_button) );
			}

			if(enableListeners) addListeners();
			
		}

		/*
		Method: enable
		Parameters:
		Returns:
		*/
		public function enable(enableListeners:Boolean = true):void
		{
			var tl:TimelineLite = new TimelineLite();
			/*
			tl.insert( TweenLite.to(_button, 0, {alpha: 1, removeTint: true}));
			*/
			if(enableListeners) addListeners();
			
			this._enabled = true;
		}
		
		/*
		Method: disable
		Parameters:
		Returns:
		*/
		public function disable(disableListeners:Boolean = true):void
		{
			if(disableListeners) removeListeners();
			/*
			var tl:TimelineLite = new TimelineLite();
			
			tl.insert( TweenLite.to(_button, 0, {alpha: .7, colorTransform:{ 
				tint: 0xCCCCCC,
				tintAmount: 0.5
			}}));
			*/
			this._enabled = false;
		}
		
		/*
		Method: addListeners
		Parameters:
		Returns:
		*/
		public function addListeners():void
		{
			_button.buttonMode = true;
			_button.addEventListener(MouseEvent.ROLL_OVER, _onRollOver, false, 0, true);
			_button.addEventListener(MouseEvent.ROLL_OUT, _onRollOut, false, 0, true);
			_button.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
		}
		
		/*
		Method: removeListeners
		Parameters:
		Returns:
		*/
		public function removeListeners():void
		{
			_button.buttonMode = false;
			_button.removeEventListener(MouseEvent.ROLL_OVER, _onRollOver);
			_button.removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			_button.removeEventListener(MouseEvent.CLICK, _onClick);
		}
		
		/*
		Method: _onRollOver
		Parameters:
		e:MouseEvent
		Returns:
		*/
		protected function _onRollOver(e:MouseEvent):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOver(_button));
			}
		}
		
		/*
		Method: _onRollOut
		Parameters:
		e:MouseEvent
		Returns:
		*/
		protected function _onRollOut(e:MouseEvent):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOut(_button));
			}
		}

		private function _onClick(e:MouseEvent):void
		{
			clicked.dispatch({dispatcher: this, button: _button, vars: vars});
		}
		
		public function destroy():void
		{
			if(_button)
			{
				removeListeners();
			}
			
			clicked.removeAll();
			
			_isDestroyed = true;
		}
		
		//————————————————————————————————————————————————————————————————
		// GETTER: BUTTON
		//————————————————————————————————————————————————————————————————
		public function get button():MovieClip
		{
			return _button;
		}
		
		//————————————————————————————————————————————————————————————————
		// GETTER: ENABLED
		//————————————————————————————————————————————————————————————————
		public function get enabled():Boolean
		{
			return _enabled;
		}

		//————————————————————————————————————————————————————————————————
		// GETTER: MOUSE ENABLED
		//————————————————————————————————————————————————————————————————
		public function get mouseEnabled():Boolean
		{
			return _mouseEnabled;
		}

		//————————————————————————————————————————————————————————————————
		// SETTER: MOUSE ENABLED
		//————————————————————————————————————————————————————————————————
		public function set mouseEnabled(value:Boolean):void
		{
			_mouseEnabled = value;
			_button.mouseEnabled = _mouseEnabled;
		}

		//————————————————————————————————————————————————————————————————
		// GETTER: MOUSE CHILDREN
		//————————————————————————————————————————————————————————————————
		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}

		//————————————————————————————————————————————————————————————————
		// SETTER: MOUSE CHIDLREN
		//————————————————————————————————————————————————————————————————
		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren = value;
			_button.mouseChildren = _mouseChildren;
		}
		
		//————————————————————————————————————————————————————————————————
		// GETTER: IS DESTROYED
		//————————————————————————————————————————————————————————————————
		public function get isDestroyed():Boolean
		{
			return this._isDestroyed;
		}
	}
}