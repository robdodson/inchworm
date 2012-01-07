package com.inchworm.display.buttons
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class TriggerButton extends StrategyButton
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _targetLabelClip					:MovieClip;
		
		//————————————————————————————————————————————————————————————————
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function TriggerButton(targetButton:MovieClip, buttonBehavior:Array, targetLabelClip:MovieClip = null)
		{
			super(targetButton, buttonBehavior);
			
			_targetLabelClip = targetLabelClip;
		}
		
		//————————————————————————————————————————————————————————————————
		//
		// SELECTED
		//
		//————————————————————————————————————————————————————————————————
		override public function selected(disableListeners:Boolean = true):void
		{
			_targetLabelClip.gotoAndStop('OVER');
			super.selected(disableListeners);
		}
		
		//————————————————————————————————————————————————————————————————
		//
		// RESET
		//
		//————————————————————————————————————————————————————————————————
		override public function reset(enableListeners:Boolean = true):void
		{
			_targetLabelClip.gotoAndStop('UP');
			super.reset(enableListeners);
		}
		
		//————————————————————————————————————————————————————————————————
		// ON ROLL OVER
		//————————————————————————————————————————————————————————————————
		override protected function _onRollOver(e:MouseEvent):void
		{
			_targetLabelClip.gotoAndStop('OVER');
			super._onRollOver(e);
		}

		//————————————————————————————————————————————————————————————————
		// ON ROLL OUT
		//————————————————————————————————————————————————————————————————
		override protected function _onRollOut(e:MouseEvent):void
		{
			_targetLabelClip.gotoAndStop('UP');
			super._onRollOut(e);
		}
	}
}