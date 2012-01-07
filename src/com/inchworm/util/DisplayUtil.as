package com.inchworm.util
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * A scaling utility which provides a number of convenience methods
	 * to help properly resize DisplayObjects
	 * 
	 * @author Justin Gaussoin
	 * 
	 */	
	public class DisplayUtil
	{
		/**
		 * Scale a DisplayObject so that it meets either the height or
		 * the width of a predefined area (depending on whichever one is larger).
		 * This method preserves the aspect ratio of the DisplayObject
		 * 
		 * @param displayObject: The DisplayObject to be scaled
		 * @param areaWidth: The width of the area
		 * @param areaHeight: The height of the area
		 * 
		 */		
		public static function aspectFill(displayObject:DisplayObject, areaWidth:Number, areaHeight:Number):void {
			var newHeight:Number, newWidth:Number, newRatio:Number;
			var orgWidth:Number = displayObject.width;
			var orgHeight:Number = displayObject.height;
			var diffWidth:Number = areaWidth - orgWidth;
			var diffHeight:Number = areaHeight - orgHeight;
			if (diffHeight > diffWidth)
			{
				// Scale the item until the height of the area is met
				newHeight = areaHeight;
				newRatio = newHeight/orgHeight;
				newWidth = orgWidth*newRatio;
			}
			else if (diffWidth >= diffHeight)
			{
				// Scale the item until the width of the area is met
				newWidth = areaWidth;
				newRatio = newWidth/orgWidth;
				newHeight = orgHeight*newRatio;
			}
			displayObject.width = Math.floor(newWidth);
			displayObject.height = Math.floor(newHeight);
		}
		
		/**
		 * Scale a DisplayObject so that it fits within a predefined area
		 * while preserving its aspect ratio.
		 * 
		 * @param displayObject: The DisplayObject to be scaled
		 * @param areaWidth: The width of the area
		 * @param areaHeight: The height of the area
		 * 
		 */		
		public static function aspectFit(displayObject:DisplayObject, areaWidth:Number, areaHeight:Number):void {
			var newHeight:Number, newWidth:Number, newRatio:Number;
			var orgWidth:Number = displayObject.width;
			var orgHeight:Number = displayObject.height;
			var diffWidth:Number = areaWidth - orgWidth;
			var diffHeight:Number = areaHeight - orgHeight;
			if (diffHeight < diffWidth)
			{
				newHeight = areaHeight;
				newRatio = newHeight/orgHeight;
				newWidth = orgWidth*newRatio;
			}
			else if (diffWidth <= diffHeight)
			{
				newWidth = areaWidth;
				newRatio = newWidth/orgWidth;
				newHeight = orgHeight*newRatio;
			}
			displayObject.width = newWidth;
			displayObject.height = newHeight;
		}
		
		/**
		 * Scale a DisplayObject so that it fits within a predefined area
		 * based on that area's width
		 *  
		 * @param displayObject: The DisplayObject to be scaled
		 * @param areaWidth: The width of the area
		 * 
		 */		
		public static function fitOnWidth(displayObject:DisplayObject, areaWidth:Number):void
		{
			var newHeight:Number, newWidth:Number, newRatio:Number;
			var orgWidth:Number = displayObject.width;
			var orgHeight:Number = displayObject.height;
			newWidth = areaWidth;
			newRatio = newWidth/orgWidth;
			newHeight = orgHeight*newRatio;
			displayObject.width = newWidth;
			displayObject.height = newHeight;
		}
		
		/**
		 * Scale a Rectangle so that it fits within a predefined area
		 * while preserving its aspect ratio.
		 * 
		 * @param rect: The Rectangle to be scaled
		 * @param areaWidth: The width of the area
		 * @param areaHeight: The height of the area
		 * 
		 */	
		public static function aspectFitRectangle(rect:Rectangle, areaWidth:Number, areaHeight:Number):void
		{
			var newHeight:Number, newWidth:Number, newRatio:Number;
			var orgWidth:Number = rect.width;
			var orgHeight:Number = rect.height;
			var disW:Number = areaWidth-orgWidth;
			var disH:Number = areaHeight-orgHeight;
			if (disH < disW) {
				newHeight = areaHeight;
				newRatio = newHeight/orgHeight;
				newWidth = orgWidth*newRatio;
			} else if (disW <= disH) {
				newWidth = areaWidth;
				newRatio = newWidth/orgWidth;
				newHeight = orgHeight*newRatio;
			}
			rect.width = newWidth;
			rect.height = newHeight;
		}
		
		/**
		 * Scale a Rectangle so that it fits within a predefined area
		 * based on that area's height
		 * 
		 * @param rect: The Rectangle to be scaled
		 * @param areaWidth: The width of the area
		 * @param areaHeight: The height of the area
		 * 
		 */		
		public static function fitRectangleOnHeight(rect:Rectangle, areaWidth:Number, areaHeight:Number):void
		{
			var newHeight:Number, newWidth:Number, newRatio:Number;
			var orgWidth:Number = rect.width;
			var orgHeight:Number = rect.height;
			newHeight = areaHeight;
			newRatio = newHeight/orgHeight;
			newWidth = orgWidth*newRatio;
			rect.width = newWidth;
			rect.height = newHeight;
		}
	}
}