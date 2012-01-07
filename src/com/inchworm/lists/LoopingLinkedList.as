package com.inchworm.lists
{
	/**
	 * A tool for creating a looping linked list of Objects. The tail of the list
	 * will refer back to the head and the head of the list will refer back to the tail.
	 * 
	 * @author Rob Dodson
	 * 
	 */	
	public class LoopingLinkedList extends LinkedList
	{
		/**
		 * A tool for creating a looping linked list of Objects. The tail of the list
		 * will refer back to the head and the head of the list will refer back to the tail.
		 * 
		 */		
		public function LoopingLinkedList()
		{
			super();
		}
		
		/**
		 * Create the linked list. The first object inserted will become the head of the list.
		 * As additional objects are inserted they become the tail and
		 * the object which used to be the tail gets a next reference
		 * to the new tail object. The new tail object also gets a previous
		 * reference to the tail it just replaced.
		 * 
		 * There is also an additional feature of the head of the list referring to the tail
		 * and vice versa. Hence the list loops as you can continually refer to the next or prev
		 * property of any list item 
		 * 
		 * @param item: The Object to be added to the list
		 * 
		 */		
		override public function addItem(item:Object):void
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
				_head.prev = item;
				_tail.next = _head;
			}
			
			_items.push(item);
		}
	}
}