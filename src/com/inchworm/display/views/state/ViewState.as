package com.inchworm.display.views.state
{
	public class ViewState
	{
		//-----------------------------------------------------------------
		// CLASS MEMBERS
		private var _viewClass					:Class;
		private var _states						:Array;
		private var _depth						:int;
		
		//-----------------------------------------------------------------
		
		public function ViewState(viewClass:Class, states:Array, depth:int)
		{
			_viewClass = viewClass;
			_states = states;
			_depth = depth;
		}

		public function get viewClass():Class
		{
			return _viewClass;
		}
		
		public function get states():Array
		{
			return _states;
		}

		public function get depth():int
		{
			return _depth;
		}
		
		/**
		 * Check to see if any of the view states match the current one.
		 * @param state
		 * @return 
		 * 
		 */		
		public function doesViewBelongToState(state:String):Boolean
		{
			var doesViewBelongToState:Boolean;
			
			for (var i:int = 0; i < _states.length; i++) 
			{
				var viewState:String = String(_states[i]);
				var pattern:RegExp = new RegExp("\\b" + viewState + "\\b", "g");
				var result:Object = pattern.exec(state);
				if (result && result.length)
				{
					doesViewBelongToState = true;
				}
				
				// This should be a part of the regex but
				// for now we'll do it dirty
				if (viewState == "/")
				{
					doesViewBelongToState = true;
				}
				
				/*
				if (_isExactMatch(viewState, state) || _isWildCardMatch(viewState, state) || _isNestedMatch(viewState, state))
				{
					doesViewBelongToState = true;
					break;
				}
				*/
			}
			
			return doesViewBelongToState;
		}

		/*
		private function _isExactMatch(viewState:String, state:String):Boolean
		{
			// Example exact match: /red == /red
			
			return viewState == state;		
		}
		
		private function _isWildCardMatch(viewState:String, state:String):Boolean
		{
			// Example wildcard match: *///red == /first_state/second_state/red
		/*	
			var isWildCardMatch:Boolean;
			var viewStateArr:Array = viewState.split("/");
			var stateArr:Array = state.split("/");
			
			if (viewState.indexOf("*") != -1)
			{
				if(stateArr[stateArr.length - 1] == viewStateArr[viewStateArr.length - 1])
				{
					isWildCardMatch = true;
				}
			}
			
			return isWildCardMatch;
		}
		
		private function _isNestedMatch(viewState:String, state:String):Boolean
		{
			// Example nested match: /container == /container/nested_thing
			// WARNING: Realizing that there's the potential to do a nested
			// wildcard match like: *///container and this implementation would
			// not work with that.
		/*	
			var isNestedMatch:Boolean;
			var viewStateArr:Array = viewState.split("/");
			var stateArr:Array = state.split("/");
			
			for (var i:int = 0; i < viewStateArr.length; i++) 
			{
				if (viewStateArr[i] == stateArr[i])
				{
					isNestedMatch = true;
				}
				else
				{
					isNestedMatch = false;
				}
			}
			
			return isNestedMatch;
		}
		*/
	}
}