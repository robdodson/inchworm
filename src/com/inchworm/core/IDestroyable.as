package com.inchworm.core
{
	/**
	 * Interface for destroyable objects
	 * 
	 * @author Rob Dodson
	 * @author Justin Gaussoin
	 * 
	 */	
	public interface IDestroyable
	{
		/**
		 * Remove any event listeners and signals, stop all internal process, destroy all
		 * children which implement IDestroyable and remove the DisplayObject from its
		 * parent. 
		 * 
		 */		
		function destroy():void;
		
		/**
		 * Determines if the object has been destroyed
		 * @return Boolean indicating whether or not the current object has been destroyed 
		 * 
		 */		
		function get isDestroyed():Boolean;
	}
}