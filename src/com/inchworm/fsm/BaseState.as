package com.inchworm.fsm
{
	/**
	 * Basic state that imeplements IState interface. This is
	 * an abstract class and should be extended. 
	 * 
	 */	
	public class BaseState implements IState
	{
		public function BaseState()
		{
		}
		
		public function enter():void
		{
			// The enter method is called whenever setCurrentState()
			// or changeState() are called on the StateMachine.
		}
		
		public function execute():void
		{
			// The execute method is called whenever someone
			// calls update() on the StateMachine. It's where you would
			// put repetative actions like updating an item's position
			// on screen.
		}
		
		public function exit():void
		{
			// The exit method is called whenever changeState is called on
			// the StateMachine. It's a good place to do any cleanup before
			// moving to the next state.
		}
	}
}