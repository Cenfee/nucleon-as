package com.miniGame.managers.scene
{
	import com.miniGame.managers.layer.LayerManager;
	import com.miniGame.managers.view.ViewManager;
	
	import flash.display.Sprite;
	
	

	public class SceneManager
	{
		private static var _instance:SceneManager;
		public static function getInstance():SceneManager
		{
			if(!_instance)
				_instance = new SceneManager();
			
			return _instance;
		}
		
		public function SceneManager()
		{
		}
		
		private var _currentSceneName:String;
		private var _lastSceneName:String;
		
		public function switchScene(sceneName:String, onComplete:Function=null, data:Object=null):void
		{
			if(_lastSceneName)
			{
				var dispose:Boolean;
				var unloadAssets:Boolean;
				if(data)
				{
					dispose = data.hasOwnProperty("dispose") ? data["dispose"] : true;
					unloadAssets = data.hasOwnProperty("unloadAssets") ? data["unloadAssets"] : true;
				}
				LayerManager.getInstance().getGameLayer().removeChild(
					ViewManager.getInstance().hideView(_lastSceneName, dispose, unloadAssets) as Sprite
				);
			}
			
			LayerManager.getInstance().getGameLayer().addChild(
				ViewManager.getInstance().showView(sceneName, onComplete, data) as Sprite
				);
			
			
			_currentSceneName = sceneName;
			_lastSceneName = _currentSceneName;
		}
	}
}