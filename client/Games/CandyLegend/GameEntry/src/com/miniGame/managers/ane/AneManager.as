package com.miniGame.managers.ane
{
	

	public class AneManager
	{
		private static var _instance:AneManager;
		public static function getInstance():AneManager
		{
			if(!_instance)
				_instance = new AneManager();
			
			return _instance;
		}
		
		public function AneManager()
		{
			_getUdid = new GetUdid();
		}
		
		private var _getUdid:GetUdid;
		
		public function getGetUdid():GetUdid
		{
			return _getUdid;
		}
	}
}