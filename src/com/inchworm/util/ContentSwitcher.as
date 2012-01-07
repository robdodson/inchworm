package com.inchworm.util
{
	import com.inchworm.display.views.AbstractView;
	
	import flash.display.Sprite;
	
	/**
	 * Provides a 1 to 1 view switcher
	 * @author Justin Gaussoin
	 * 
	 */	
	public class ContentSwitcher
	{
		/**
		 * @private 
		 */		
		protected var _container			:Sprite;
		
		/**
		 * @private 
		 */		
		protected var _newView				:AbstractView;
		
		/**
		 * @private 
		 */		
		protected var _oldView				:AbstractView;
		
		/**
		 * Creates a new ContentSwitcher
		 *  
		 * @param container: The container which will hold the old and new views
		 * 
		 */		
		public function ContentSwitcher(container:Sprite)
		{
			_container = container;
		}
		
		/**
		 * Setting a newView will cause the ContentSwitcher to remove the previous view
		 * and add the new one. 
		 * @param value: An AContentView object which will be added to the container
		 * @see  com.inchworm.ui.AContentView
		 * 
		 */		
		public function set newView(value:AbstractView):void
		{
			_newView = value;
			_switchView();
		}
		
		/**
		 * @private 
		 * 
		 */		
		private function _switchView():void
		{
			if (_oldView!=null)
			{
				_oldView.inComplete.addOnce(_addView);
				_oldView.animateOut();
				return;
			}
			_addView();
		}
		
		/**
		 * @private 
		 * 
		 */		
		private function _addView():void
		{
			if (_oldView)
			{
				_oldView.destroy();
				_oldView=null;
			}
			
			if (_newView==null) return;
			_container.addChild(_newView);
			_oldView=_newView;
			_newView.animateIn();
		}
	}
}