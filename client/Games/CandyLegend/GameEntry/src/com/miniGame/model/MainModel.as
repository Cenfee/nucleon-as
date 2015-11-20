package com.miniGame.model
{
	import com.miniGame.managers.ane.AneManager;
	import com.miniGame.managers.data.DataManager;
	
	import flash.system.Capabilities;

	public class MainModel
	{
		private static var _instance:MainModel;
		public static function getInstance():MainModel
		{
			if(!_instance)
				_instance = new MainModel();
			return _instance;
		}
		
		
		private static const LAST_LEVEL:String = "lastLevel";
		private static const CUR_LEVEL:String = "curLevel";
		private static const MAX_LEVEL:String = "maxLevel";
		private static const GUIDE:String = "guide";
		
		private static const BOBI_CLICK_RECORD:String = "bobiClickRecord";
		
		
		private var _data:Object;
		
		public function MainModel()
		{
		}
		public function requestData(onComplete:Function=null):void
		{
			DataManager.getInstance().readObject("data/main.dat", function(data:Object):void
			{
				_data = data;
				
				if(!_data)
				{
					_data = {};
					_data[LAST_LEVEL] = 0;
					_data[CUR_LEVEL] = 0;
					_data[MAX_LEVEL] = 0;
					_data[GUIDE] = 0;
					
					_data[BOBI_CLICK_RECORD] = {};
				}
				if(onComplete)onComplete();
			});
		}
		public function sendData(onComplete:Function=null):void
		{
			DataManager.getInstance().writeObject(_data, "data/main.dat", function():void
			{
				if(onComplete)onComplete();
			});
		}
		
		public function getCurLevel():int
		{
			return _data[CUR_LEVEL] ? _data[CUR_LEVEL] : 0;
		}
		public function setCurLevel(value:int):void
		{
			_data[LAST_LEVEL] = _data[CUR_LEVEL];
			_data[CUR_LEVEL] = value;
			
			if(_data[CUR_LEVEL] > _data[MAX_LEVEL])
			{
				_data[MAX_LEVEL] = _data[CUR_LEVEL];
			}
		}
		
		public function getMaxLevel():int
		{
			return _data[MAX_LEVEL] ? _data[MAX_LEVEL] : 0;
		}
		public function getLastLevel():Number
		{
			return _data[LAST_LEVEL] ? _data[LAST_LEVEL] : 0;
		}
		
		public function setGuide():void
		{
			_data[GUIDE] = 1;
		}
		public function getGuide():int
		{	
			return _data[GUIDE] ? _data[GUIDE] : 0;
		}
		
		
		public function addBobiClick(type:String):void
		{
			if(!_data[BOBI_CLICK_RECORD]["count"])
			{
				_data[BOBI_CLICK_RECORD]["count"] = {};
			}
			if(!_data[BOBI_CLICK_RECORD]["count"][type])
			{
				_data[BOBI_CLICK_RECORD]["count"][type] = 0;
			}
			
			++_data[BOBI_CLICK_RECORD]["count"][type];
			
			
			
			if(!_data[BOBI_CLICK_RECORD]["record"])
			{
				_data[BOBI_CLICK_RECORD]["record"] = [];
			}
			
			var date:Date = new Date();
			
			_data[BOBI_CLICK_RECORD]["record"].push
				({
					id:AneManager.getInstance().getGetUdid(),
					device:Capabilities.os,
					time:
						date.getUTCFullYear()+"-"+
						date.getMonth()+"-"+
						date.getUTCDate()+"-"+
						date.getHours()+"-"+
						date.getUTCMinutes(),
					type:type
				});
		}
		public function getBobiClickRecord():Object
		{
			return _data[BOBI_CLICK_RECORD];
		}
		public function clearBobiClickRecordRecord():void
		{
			delete _data[BOBI_CLICK_RECORD]["record"];
		}
	}
}