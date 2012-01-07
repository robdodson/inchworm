package com.inchworm.lists
{
	/**
	 * A tool for creating a simple linked list of Objects
	 * @author Rob Dodson
	 * 
	 */	
	public class LinkedList
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _head							:Object;
		protected var _tail							:Object;
		protected var _items						:Array;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A tool for creating a simple linked list of Objects 
		 * 
		 */				
		public function LinkedList()
		{
			_items = [];
		}
		
		/**
		 * Create the linked list. The first object inserted will become the head of the list.
		 * As additional objects are inserted they become the tail and
		 * the object which used to be the tail gets a next reference
		 * to the new tail object. The new tail object also gets a previous
		 * reference to the tail it just replaced.
		 * 
		 * @param item: The Object to be added to the list 
		 * 
		 */		
		public function addItem(item:Object):void
		{
			if (_tail == null)
			{
				_head = _tail = item;
			}
			else
			{
				_tail.next = item;
				item.prev = _tail;
				_tail = item;
			}
			
			_items.push(item);
		}

		/**
		 * Get the head of the list 
		 * @return Returns the first Object in the list
		 * 
		 */		
		public function get head():Object
		{
			return _head;
		}

		/**
		 * Get the tail of the list 
		 * @return Returns the last Object in the list
		 * 
		 */		
		public function get tail():Object
		{
			return _tail;
		}

		/**
		 * An Array of all the items in the list 
		 * @return Returns an Array of all the list items
		 * 
		 */		
		public function get items():Array
		{
			return _items;
		}
	}
}