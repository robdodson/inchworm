package com.inchworm.proxy
{
	import flash.display.Stage;

	public class StageProxy
	{
		//----------------------------------------------------------------
		// CLASS MEMBERS
		private static var _instance			:StageProxy;
		private var _stage						:Stage;
		
		//----------------------------------------------------------------
		
		public function StageProxy(lock:Class)
		{
			if (lock != SingletonLock)
			{
				throw new Error("Invalid Singleton access. Please use StageProxy.instance");
			}
		}
		
		//————————————————————————————————————————————————————————————————
		//
		// SINGLETON ENFORCER
		//
		//————————————————————————————————————————————————————————————————
		public static function get instance():StageProxy
		{
			if (_instance == null)
			{
				StageProxy._instance = new StageProxy(SingletonLock);
			}
			
			return StageProxy._instance;
		}
		
		public function addStage(stage:Stage):void
		{
			_stage = stage;
		}
		
		public function get stage():Stage
		{
			return _stage;
		}
	}
}

class SingletonLock {}