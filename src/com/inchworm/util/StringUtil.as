package com.inchworm.util
{
	public class StringUtil
	{
		/**
		 * Changes the first letter of a string to Uppercase.
		 *  
		 * @param str: The String to be changed
		 * @return Returns a new String with the first letter capitalized
		 * 
		 */		
		public static function uppercaseFirst(str:String):String
		{
			var firstChar:String = str.substr(0,1);
			var restOfString:String = str.substr(1, str.length);
			return firstChar.toUpperCase()+restOfString.toLowerCase();
		}
		
		/**
		 *  Trims any whitespace after a string.
		 *  
		 * @param str: The String to be changed
		 * @return Returns a new String without any whitespace at the end
		 * 
		 */		
		public static function trimRight(str:String):String {
			if (str == null) { return ''; }
			return str.replace(/\s+$/, '');
		}
		
		public static function truncate(str:String, trailing:uint = 1):String {
			if (str == null) {
				throw new ArgumentError('Argument str:String is null');
			}
			
			str = str.substring(0, str.length - trailing);
			return str;
		}
	}
}