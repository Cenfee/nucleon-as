package com.miniGame.managers.debug
{
	

	public class DebugManager
	{
		private static var _instance:DebugManager;
		public static function getInstance():DebugManager
		{
			if(!_instance)
				_instance = new DebugManager();
			
			return _instance;
		}
		
		public function DebugManager()
		{
		}
		
		public function log(...args):void
		{
			trace("[log]", args);
		}
		public function warn(...args):void
		{
			trace("[warn]", args);
		}
		public function error(...args):void
		{
			trace("[error]", args);
		}
	}
}