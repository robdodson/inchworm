package com.inchworm.fsm
{
	import com.inchworm.character.Miner;
	
	import flash.utils.Dictionary;
	
	public class StateMachine
	{
		//--------------------------------------------
		// a reference to the entity who owns this state machine
		private var _owner					:*;

		// the currently running state
		private var _currentState			:IState;
	
		// a record of the last state the entity was in
		private var _previousState			:IState;
	
		// this state logic is called every time the FSM updates
		private var _globalState			:IState;
		
		//--------------------------------------------
	
		public function StateMachine(owner:*)
		{
			_owner = owner;
		}
	
		public function setCurrentState(state:IState):void
		{
			_currentState = state;
		}
	
		public function setGlobalState(state:IState):void
		{
			_globalState = state;
		}
	
		public function setPreviousState(state:IState):void
		{
			_previousState = state;
		}
	
		public function update():void
		{
			// if a global state exists call its update method
			if (_globalState)
			{
				_globalState.execute();
			}
	
			// same for current state
			if (_currentState)
			{
				_currentState.execute();
			}
		}
	
		public function changeState(newState:IState):void
		{
			// verify both states are valid before moving on
			if (_currentState && newState)
			{
				_previousState = _currentState;
				_currentState.exit();
				_currentState = newState;
				_currentState.enter();
			}
		}
	
		public function revertToPreviousState():void
		{
			changeState(_previousState);
		}
	
		public function isInState(stateType:Class):Boolean
		{
			return (_currentState is stateType);
		}
	
		public function get currentState():IState
		{
			return _currentState;
		}
	
		public function get previousState():IState
		{
			return _previousState;
		}
	
		public function get globalState():IState
		{
			return _globalState;
		}
	}
}
