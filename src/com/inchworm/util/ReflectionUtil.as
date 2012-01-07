package com.inchworm.util
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;

	/**
	 * Utility for extracting Class objects from instantiated objects or the ApplicationDomain
	 * @author Justin Gaussoin
	 * 
	 */	
	public class ReflectionUtil
	{
		/**
		 * Pass in an object and get that object's class returned as a Class object 
		 * @param object: The Object whose class is to be returned
		 * @param domain: An Application Domain
		 * @return Returns a Class object for the type of Object passed in
		 * 
		 */		
		public static function getObjectClass(object:Object,domain:ApplicationDomain=null):Class
		{
			var description:XML = describeType(object);
			var fullClassPath:String = String(description.@name).split("::").join(".");
			return (domain==null) ? getClassByName(fullClassPath) : domain.getDefinition(fullClassPath) as Class;
		}
		
		/**
		 * Pull a Class object from the specificed ApplicationDomain 
		 * @param name: The name of the Class to be returned. For example: 'MovieClip'
		 * @param domain: The Application Domain from which to pull the Class object
		 * @return Returns a Class object which matches the String passed in
		 * 
		 */		
		public static function getClassByName(name:String,domain:ApplicationDomain=null):Class
		{
			var theDomain:ApplicationDomain = (domain==null) ? ApplicationDomain.currentDomain : domain;
			if (theDomain.hasDefinition(name)) {
				var theClass:Class = Class(theDomain.getDefinition(name));
			} else {
				throw new Error("Class does not exist in the currentDomain:",theDomain.parentDomain);
			}
			
			
			if (theClass==null) throw new Error("Class does not exist in the currentDomain:",theDomain.parentDomain);
			return theClass;
		}
	}
}