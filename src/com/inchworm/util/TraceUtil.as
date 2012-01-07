package com.inchworm.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class TraceUtil
	{
		//————————————————————————————————————————————————————————————————
		// NAME
		public static const NAME				:String = 'TraceUtil';
		
		// CLASS MEMBERS
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Work in progress. Recursion doesn't currently work 
		 * @param obj
		 * @param isRecursive
		 * @param padding
		 * 
		 */				
		public static function traceProps(obj:Object, isRecursive:Boolean = false, padding:int = 1):void
		{
			var pad:String = '    ';
			for (var prop:String in obj)
			{
				if(isRecursive && obj[prop] is Object)
				{
					++padding;
					traceProps(obj[prop], true, padding);
				}
				else
				{
					var padString:String = '';
					trace(padString + obj + '.' + prop + ' = ' + obj[prop]);
				}
			}			
		}
		
		/**
		 * From: http://play.blog2t.net/finding-the-missing-child/ 
		 * @param container
		 * @param options
		 * @param indentString
		 * @param depth
		 * @param childAt
		 * 
		 */		
		public static function traceDisplay(container:DisplayObjectContainer, options:* = undefined, indentString:String = "", depth:int = 0, childAt:int = 0):void
		{
			if (typeof options == "undefined") options = Number.POSITIVE_INFINITY;
			
			if (depth > options) return;
			
			const INDENT:String = "   ";
			var i:int = container.numChildren;
			
			while (i--)
			{
				var child:DisplayObject = container.getChildAt(i);
				var output:String = indentString + (childAt++) + ": " + child.name + " ➔ " + child;
				
				// debug alpha/visible properties
				output += "\t\talpha: " + child.alpha.toFixed(2) + "/" + child.visible;
				
				// debug x and y position
				output += ", @: (" + child.x + ", " + child.y + ")";
				
				// debug transform properties
				output += ", w: " + child.width + "px (" + child.scaleX.toFixed(2) + ")";
				output += ", h: " + child.height + "px (" + child.scaleY.toFixed(2) + ")"; 
				output += ", r: " + child.rotation.toFixed(1) + "°";
				
				if (typeof options == "number") trace(output);
				else if (typeof options == "string" && output.match(new RegExp(options, "gi")).length != 0)
				{
					trace(output, "in", container.name, "➔", container);
				}
				
				if (child is DisplayObjectContainer) traceDisplay(DisplayObjectContainer(child), options, indentString + INDENT, depth + 1);
			}
		}
	}
}