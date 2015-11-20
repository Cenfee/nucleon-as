package com.miniGame.managers.ane
{
	import com.miniGame.managers.debug.DebugManager;
	
	import flash.utils.getDefinitionByName;

	public class GetUdid
	{
		private var _commonClass:Class;
		//private var _androidClass:Class;
		//private var _iosClass:Class;
		
		private var _commonInstance:*;
		
		public function GetUdid()
		{
			try
			{
				_commonClass = getDefinitionByName("commmonClassName") as Class;
			}
			catch(e:Error)
			{
				DebugManager.getInstance().warn("GetUdid:", "找不到commmonClassName");
			}
		}
		
		public function getUdid():String
		{
			if(_commonInstance)
				return _commonInstance.getUdid();
			
			return "";
		}
	}
}