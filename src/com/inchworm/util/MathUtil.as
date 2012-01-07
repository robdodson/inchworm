package com.inchworm.util
{
	public class MathUtil
	{
		public static function degToRad(degrees:Number):Number
		{
			return (degrees * Math.PI / 180);
		}
	
		public static function radToDeg(radians:Number):Number
		{
			return (radians * 180 / Math.PI);
		}
		
		public static function xVector(angleInRadians:Number, speed:Number):Number
		{
			return speed * Math.cos(angleInRadians);
		}
		
		public static function yVector(angleInRadians:Number, speed:Number):Number
		{
			return speed * Math.sin(angleInRadians);
		}
	}
}
