package com.inchworm.display.views.state
{
	/**
	 * ViewSequence constants are used by the ViewStateMachine to tell if its 
	 * sequencers should run in parallel or sequentially
	 * 
	 * @author Rob Dodson
	 * 
	 */	
	public class ViewSequence
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		public static const SEQUENTIAL					:String = 'SEQUENTIAL';
		public static const PARALLEL					:String = 'PARALLEL';
		
		//————————————————————————————————————————————————————————————————
	}
}