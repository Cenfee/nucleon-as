package com.miniGame.managers.configs
{
	import com.miniGame.managers.asset.AssetManager;
	
	

	public class ConfigManager
	{
		public static const LOGIN_VIEW:String = "loginView";
		public static const GUIDE_VIEW:String = "guideView";
		public static const GAME_VIEW:String = "gameView";
		public static const GAME_OVER_VIEW:String = "gameOverView";
		
		public static const GAME_WIDTH:Number = 1136;
		public static const GAME_HEIGHT:Number = 640;
		
		public static const LOGIN_VIEW_BG_SOUND_URL:String = "music_01.mp3";
		public static const LOGIN_VIEW_WELCOME_BOBI_SOUND_URL:String = "welcome_bobi.mp3";
		public static const GUIDE_VIEW_BG_SOUND_URL:String = "music_02.mp3";
		
		
		public var gameAssets:Array;
		public var gameClass:Class;
		
		public var entryAssetsUrl:String;
		public var assetsUrl:String;
		
		public var fullScreenWidth:Number;
		public var fullScreenHeight:Number;
		
		public static const STATISTICS_URL:String = "http://baidu.com";
		
		
		private static var _instance:ConfigManager;
		public static function getInstance():ConfigManager
		{
			if(!_instance)
				_instance = new ConfigManager();
			
			return _instance;
		}
		
		
		public function ConfigManager()
		{
		}
		
		private var _levelConfigs:Object={};
		public function getLevelConfig(value:int, LevelConfigClass:Class):*
		{
			if(_levelConfigs[value])
				return _levelConfigs[value];
			
			var data:Object = AssetManager.getInstance().getAsset(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/level.json"
				);
			var levelConfig:* = new LevelConfigClass(data[value]);
			_levelConfigs[value] = levelConfig;
			
			return levelConfig;
		}
	}
}