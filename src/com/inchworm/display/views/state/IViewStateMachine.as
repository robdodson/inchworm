package com.inchworm.display.views.state
{
	import org.osflash.signals.Signal;

	public interface IViewStateMachine
	{
		function get state():String;
		function get addViewsStarted():Signal;
		function get addViewsCompleted():Signal;
		function get removeViewsStarted():Signal;
		function get removeViewsCompleted():Signal;
		function updateViewState(updateParams:Object):void;
	}
}