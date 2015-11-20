package com.miniGame.managers.configs
{
	public class LevelConfig
	{
		public var level:int;
		public var color:String;
		public var shape:String;
		public var texture:String;
		public var quantity_max:int;
		public var quantity_min:int;
		
		public function LevelConfig(info:Object)
		{
			for(var key:* in info)
			{
				this[key] = info[key];
			}
		}
	}
}