package com.miniGame
{
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.layer.LayerManager;
	import com.miniGame.managers.popup.PopupManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.managers.scene.SceneManager;
	import com.miniGame.managers.sound.ISoundHandle;
	import com.miniGame.managers.sound.SoundManager;
	import com.miniGame.managers.statistics.StatisticsManager;
	import com.miniGame.managers.system.SystemUtil;
	import com.miniGame.managers.update.UpdateManager;
	import com.miniGame.managers.view.ViewManager;
	import com.miniGame.view.gameOver.GameOverView;
	import com.miniGame.view.guide.GuideView;
	import com.miniGame.view.login.LoginView;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ApplicationFacade
	{
		public function ApplicationFacade()
		{
		}
		
		public function start(gameClass:Class, entryAssetsUrl:String, assets:Array, container:Sprite):void
		{
			SystemUtil.initialize();
			

			StatisticsManager.getInstance();
			
			ConfigManager.getInstance().fullScreenWidth = container.stage.fullScreenWidth;
			ConfigManager.getInstance().fullScreenHeight = container.stage.fullScreenHeight;
			
			ConfigManager.getInstance().entryAssetsUrl = entryAssetsUrl;
			ConfigManager.getInstance().gameAssets = assets;
			ConfigManager.getInstance().gameClass = gameClass;
			
			ResponseManager.getInstance().init(
				ConfigManager.GAME_WIDTH, 
				ConfigManager.GAME_HEIGHT,
				ConfigManager.getInstance().fullScreenWidth, 
				ConfigManager.getInstance().fullScreenHeight);
				
			var responseContainer:Sprite = ResponseManager.getInstance().container;
			container.addChild(responseContainer);
			
			UpdateManager.getInstance().init(container.stage);
			
			SoundManager.getInstance();
			UpdateManager.getInstance().add(SoundManager.getInstance());
			
			LayerManager.getInstance().init(responseContainer);
			
			PopupManager.getInstance().init(ConfigManager.GAME_WIDTH, ConfigManager.GAME_HEIGHT);
			
			var globleAssets:Array = [
				"entryAssets/sounds/button.mp3",
				ConfigManager.getInstance().entryAssetsUrl + "/number.swf"
				];
			
			ViewManager.getInstance().registerViewInfo(ConfigManager.LOGIN_VIEW, LoginView, 
				[
					ConfigManager.getInstance().entryAssetsUrl + "/start.swf",
					ConfigManager.getInstance().entryAssetsUrl + "/select.swf"
				]);
			
			ViewManager.getInstance().registerViewInfo(ConfigManager.GUIDE_VIEW, GuideView, 
				[
					ConfigManager.getInstance().entryAssetsUrl + "/help.swf"
				]);
			
			ViewManager.getInstance().registerViewInfo(ConfigManager.GAME_VIEW, gameClass, 
				[
					ConfigManager.getInstance().entryAssetsUrl + "/game.swf",
					ConfigManager.getInstance().entryAssetsUrl + "/timeup.swf",
					ConfigManager.getInstance().entryAssetsUrl + "/stop.swf",
					ConfigManager.getInstance().entryAssetsUrl + "/level.json"
				].concat(ConfigManager.getInstance().gameAssets)
			
			);
			ViewManager.getInstance().registerViewInfo(ConfigManager.GAME_OVER_VIEW, GameOverView,
				[
					ConfigManager.getInstance().entryAssetsUrl + "/end.swf"
				]);
			
			AssetManager.getInstance().loadViewAsset(
				AssetManager.GLOBLE,
				globleAssets,
				null,
				function():void
				{
					SceneManager.getInstance().switchScene(ConfigManager.LOGIN_VIEW, null, {unloadAssets:false});
				});
			
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivateHandler);
		}
		
		private function activateHandler(event:Event):void
		{
			UpdateManager.getInstance().resume();
			
			var sounds:Array = [];
			SoundManager.getInstance().getSoundHandlesInCategory(SoundManager.MUSIC_MIXER_CATEGORY, sounds);
			for(var soundIndex:int=0; soundIndex < sounds.length; ++soundIndex)
			{
				var sound:ISoundHandle = sounds[soundIndex];
				sound.resume();
			}
		}
		private function deactivateHandler(event:Event):void
		{
			UpdateManager.getInstance().pause();
			
			var sounds:Array = [];
			SoundManager.getInstance().getSoundHandlesInCategory(SoundManager.MUSIC_MIXER_CATEGORY, sounds);
			for(var soundIndex:int=0; soundIndex < sounds.length; ++soundIndex)
			{
				var sound:ISoundHandle = sounds[soundIndex];
				sound.pause();
			}
		}
	}
}