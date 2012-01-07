package com.inchworm.media.video
{
	/**
	 * Defines the video player methods implemented by the
	 * VideoPlayer state objects
	 * 
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public interface IVideoState
	{
		function init():void;
		function play():void;
		function stop():void;
		function pause():void;
		function buffer():void;
	}
}