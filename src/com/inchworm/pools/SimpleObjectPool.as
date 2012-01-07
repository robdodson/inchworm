/**
 * Thanks to Shane McCartney of the Lost in Actionscript blog for
 * demonstrating this technique.
 * 
 * http://code.google.com/p/lostinactionscript/source/browse/trunk/library/com/lia/utils/SimpleObjectPool.as 
 */

package com.inchworm.pools
{
	public class SimpleObjectPool
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		public var minSize:					int;
		public var size:					int = 0;
		
		public var create:					Function;
		public var clean:					Function;
		public var length:					int = 0;
		
		private var list:					Array = [];
		private var disposed:				Boolean = false;
		
		//————————————————————————————————————————————————————————————————
		
		
		//————————————————————————————————————————————————————————————————
		//
		// CONSTRUCTOR
		//
		//————————————————————————————————————————————————————————————————
		public function SimpleObjectPool(create : Function, clean : Function = null, minSize : int = 0)
		{
			this.create = create;
			this.clean = clean;
			this.minSize = minSize;
			
			var i:int = 0;
			for(i; i < minSize; i++) add();
		}

		//————————————————————————————————————————————————————————————————
		//
		// Add Object
		//
		//————————————————————————————————————————————————————————————————
		public function add() : void
		{
			list[length++] = create();
			size++;
		}

		//————————————————————————————————————————————————————————————————
		//
		// Checkout Object
		//
		//————————————————————————————————————————————————————————————————
		public function checkOut() : *
		{
			if(length == 0)
			{
				size++;
				return create();
			}
			
			return list[--length];
		}
	
		//————————————————————————————————————————————————————————————————
		//
		// Checkin Object
		//
		//————————————————————————————————————————————————————————————————
		public function checkIn(item : *) : void
		{
			if(clean != null) clean(item);
			list[length++] = item;
		}
	
		//————————————————————————————————————————————————————————————————
		//
		// Dispose ObjectPool
		//
		//————————————————————————————————————————————————————————————————
		public function dispose() : void
		{
			if(disposed) return;
			
			disposed = true;
			
			create = null;
			clean = null;
			list = null;
		}
	}
}