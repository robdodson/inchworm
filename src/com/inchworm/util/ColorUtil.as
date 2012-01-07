package com.inchworm.util
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	/**
	 * Utility for converting hex, rgb and hsb colors
	 * @author Justin Gaussoin
	 * 
	 */	
	public class ColorUtil
	{
		/**
		 * Easily transform the color of a DisplayObject 
		 * @param target The DisplayObject to be transformed
		 * @param color The desired color
		 * 
		 */		
		public static function transformColor(target:DisplayObject, color:uint):void
		{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			target.transform.colorTransform = colorTransform;
		}
		
		/**
		 * Convert a hex value into an RGB object
		 * @param value: Hex value to be converted to RGB object
		 * @return Returns an Object containing r, g, and b properties
		 * 
		 */		
		public static function hex2rgb(value:int):Object
		{
			var rgb:Object = new Object();
			rgb.r = (value >> 16) & 0xFF
			rgb.g = (value >> 8) & 0xFF
			rgb.b = value & 0xFF			
			return rgb;
		}
		
		/**
		 * Convert RGB values to an HSB Object 
		 * @param r: Red value
		 * @param g: Green value
		 * @param b: Blue value
		 * @return Returns an Object containg h, s and b properties
		 * 
		 */		
		public static function rgb2hsb(r:int, g:int, b:int):Object
		{
			var hsb:Object = new Object();
			var _max:Number = Math.max(r,g,b);
			var _min:Number = Math.min(r,g,b);

			hsb.s = (_max != 0) ? (_max - _min) / _max * 100: 0;
			hsb.b = _max / 255 * 100;
			if(hsb.s == 0){
				hsb.h = 0;
			}else{
				switch(_max)
				{
					case r:
						hsb.h = (g - b)/(_max - _min)*60 + 0;
						break;
					case g:
						hsb.h = (b - r)/(_max - _min)*60 + 120;
						break;
					case b:
						hsb.h = (r - g)/(_max - _min)*60 + 240;
						break;
				}
			}
			
			hsb.h = Math.min(360, Math.max(0, Math.round(hsb.h)));
			hsb.s = Math.min(100, Math.max(0, Math.round(hsb.s)));
			hsb.b = Math.min(100, Math.max(0, Math.round(hsb.b)));
			return hsb;
		}
	}
}