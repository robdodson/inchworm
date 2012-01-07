package com.inchworm.shapes
{
	import com.inchworm.display.DestroyableSprite;
	
	/**
	 * A simple Box with a few dynamic properties. Good for roughing out
	 * animations and particle ideas.
	 * @author Rob Dodson
	 * 
	 */	
	public class Box extends DestroyableSprite
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _width					:Number;
		protected var _height					:Number;
		protected var _color					:uint;
		protected var _isCentered				:Boolean;
		protected var _marker					:Boolean;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A simple Box with a few dynamic properties. Good for roughing out
		 * animations and particle ideas.
		 * @param boxWidth: Defines the width of the Box
		 * @param boxHeight: Defines the height of the Box
		 * @param color: Defines the color of the Box
		 * @param isCentered: Defines whether or not the Box should be drawn from its
		 * center point. If true, then the Box's registration will be its center. Otherwise
		 * it is in the top-left corner.
		 * 
		 */		
		public function Box(boxWidth:Number = 40, boxHeight:Number = 40, color:uint = 0xded3d1, isCentered:Boolean = true, marker:Boolean = true)
		{
			super();
			this._width = boxWidth;
			this._height = boxHeight;
			this._color = color;
			this._isCentered = isCentered;
			this._marker = marker;
			_draw();
		}
		
		/**
		 * @private 
		 * 
		 */		
		public function _draw():void
		{
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRect(_isCentered ? -(width >> 1) : 0, _isCentered ? -(height >> 1) : 0 , _width, _height);
			graphics.endFill();
			if (_marker)
			{
				graphics.lineStyle(1, 0x5d504f);
				graphics.moveTo(_isCentered ? 0 : width / 2, _isCentered ? 0 : height / 2);
				graphics.lineTo(_isCentered ? width / 2 : width, _isCentered ? 0 : height / 2);
			}
		}
		
		/**
		 * Width of the Box 
		 * @return Returns the width value
		 * 
		 */		
		override public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * @private 
		 */		
		override public function set width(value:Number):void
		{
			this._width = value;
			super.width = value;
			_draw();
		}

		/**
		 * Height of the Box 
		 * @return Returns the height value
		 * 
		 */		
		override public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * @private 
		 */		
		override public function set height(value:Number):void
		{
			this._height = value;
			super.height = value;
			_draw();
		}

		/**
		 * Color of the Box 
		 * @return Returns the color of the Box
		 * 
		 */		
		public function get color():uint
		{
			return _color;
		}

		/**
		 * @private 
		 */		
		public function set color(value:uint):void
		{
			_color = value;
			_draw();
		}

		/**
		 * Whether or not the Box's registration point is centered 
		 * @return Returns a Boolean indicating whether or not the Box's registration is centered
		 * 
		 */		
		public function get isCentered():Boolean
		{
			return _isCentered;
		}

		/**
		 * @private
		 */		
		public function set isCentered(value:Boolean):void
		{
			_isCentered = value;
			_draw();
		}
	}
}