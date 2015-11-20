package com.miniGame.managers.statistics
{
	import com.miniGame.managers.ane.AneManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.http.HttpManager;
	import com.miniGame.model.MainModel;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.system.Capabilities;
	

	public class StatisticsManager
	{
		private static var _instance:StatisticsManager;
		public static function getInstance():StatisticsManager
		{
			if(!_instance)
				_instance = new StatisticsManager();
			
			return _instance;
		}
		
		public function StatisticsManager()
		{
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activeHandler);
		}
		
		private function activeHandler(event:Event):void
		{
			try
			{
				if(MainModel.getInstance().getGuide() > 0)
				{
					send();
				}
			}
			catch(e:Error)
			{
				
			}
		}
		
		private var isFirst:Boolean = true;
		public function send(checkFirst:Boolean=false):void
		{
			if(checkFirst)
			{
				if(!isFirst)
				{
					return;
				}
			}
			
			var data:Object = {};
			
			
			data["score"] =
				{
					id:AneManager.getInstance().getGetUdid().getUdid(),
					device:Capabilities.os,
					maxLevel:MainModel.getInstance().getMaxLevel()
				};
			
			data["bobiClickRecord"] =
				MainModel.getInstance().getBobiClickRecord();
			
			HttpManager.getInstance().send(ConfigManager.STATISTICS_URL, JSON.stringify(data));
			
			MainModel.getInstance().clearBobiClickRecordRecord();
			MainModel.getInstance().sendData();
			
			/**
			 * data(JSON-String)
			 * ----score(Object)
			 * ---------id:(String)
			 * ---------device:(String)
			 * ---------maxLevel:(int)
			 * ----bobiClickRecord(Object)
			 * ---------count(Object)(点击跳转波比全脑的次数)
			 * --------------l(int)
			 * --------------m(int)
			 * --------------s(int)
			 * ---------record(Array)(每次点击跳转波比全脑的记录)
			 * --------------.....
			 * -------------------id(String)(Udid)
			 * -------------------device(String)(Capabilities.os)
			 * -------------------time(String)(年-月-日-小时-秒)
			 * -------------------type(String)(l/m/s)
			 */
		}
	}
}