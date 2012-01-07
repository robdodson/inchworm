package com.inchworm.shapes 
{
	import com.inchworm.display.DestroyableSprite;
	
	/**
	 * A simple Ball with a few dynamic properties. Good for roughing out
	 * animations and particle ideas.
	 * @author Rob Dodson
	 * 
	 */	
	public class Ball extends DestroyableSprite
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		protected var _radius					:Number;		
		protected var _color					:uint;
		protected var _isCentered				:Boolean;
		protected var _marker					:Boolean;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A simple Ball with a few dynamic properties. Good for roughing out
		 * animations and particle ideas.
		 *  
		 * @param radius: Defines the radius of the Ball
		 * @param color: Defines the color of the Ball
		 * @param isCentered: Defines whether or not the Ball should be drawn from its
		 * center point. If true, then the Ball's registration will be its center. If false
		 * then the radius of the Ball is used, which places the registration in the top-left
		 * corner.
		 * 
		 */		
		public function Ball(radius:Number = 20, color:uint = 0xded3d1, isCentered:Boolean = true, marker:Boolean = true)
		{
			super();
			this._radius = radius;
			this._color = color;
			this._isCentered = isCentered;
			this._marker = marker;
			_draw();
		}
		
		/**
		 * @private 
		 * 
		 */		
		protected function _draw():void
		{
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawCircle(_isCentered ? 0 : _radius, _isCentered ? 0 : _radius, _radius);
			graphics.endFill();
			if (_marker)
			{
				graphics.lineStyle(0, 0x777777);
				_isCentered ? graphics.moveTo(0, 0) : graphics.moveTo(_radius, _radius);
				_isCentered ? graphics.lineTo(_radius, 0) : graphics.lineTo(_radius * 2, _radius);
			}
		}

		/**
		 * Radius value of the Ball
		 * @return Returns the radius value 
		 * 
		 */		
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 * Defines the radius value of the Ball 
		 * @param value: A radius as a floating point Number
		 * 
		 */		
		public function set radius(value:Number):void
		{
			_radius = value;
			_draw();
		}

		/**
		 * Color value of the Ball 
		 * @return Returns the color of the Ball
		 * 
		 */		
		public function get color():uint
		{
			return _color;
		}

		/**
		 * Defines the color value of the Ball 
		 * @param value: A color as a uint
		 * 
		 */		
		public function set color(value:uint):void
		{
			_color = value;
			_draw();
		}

		/**
		 * Whether or not the Ball's registration point is centered 
		 * @return Returns a Boolean indicating whether or not the Ball's registration is centered
		 * 
		 */		
		public function get isCentered():Boolean
		{
			return _isCentered;
		}

		/**
		 * Defines the registration point for the Ball 
		 * @param value: A Boolean value indicating whether or not the Ball's registration is centered
		 * 
		 */		
		public function set isCentered(value:Boolean):void
		{
			_isCentered = value;
			_draw();
		}
	}
}