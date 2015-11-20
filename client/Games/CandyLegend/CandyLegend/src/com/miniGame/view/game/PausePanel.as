package com.miniGame.view.game
{
	import com.miniGame.controls.SoundButton;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.response.ResponseManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class PausePanel extends Sprite
	{
		private var _bg:DisplayObject;
		public var restartBtn:SoundButton;
		public var resumeBtn:SoundButton;
		public var homeBtn:SoundButton;
		
		public function PausePanel()
		{
			super();
		}
		
		public function create():void
		{
			var bgClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/stop.swf", "stop.Background");
			var restartBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/stop.swf", "stop.RestartBtn");
			var resumeBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/stop.swf", "stop.ContinueBtn");
			var homeBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/stop.swf", "stop.HomeBtn");
			
			_bg = new bgClass();
			_bg.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.5);
			_bg.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.5);
			addChild(_bg);
			
			restartBtn = new SoundButton(new restartBtnClass());
			restartBtn.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.3);
			restartBtn.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.5);
			addChild(restartBtn);
			
			resumeBtn = new SoundButton(new resumeBtnClass());
			resumeBtn.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.5);
			resumeBtn.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.5);
			addChild(resumeBtn);
			
			homeBtn = new SoundButton(new homeBtnClass());
			homeBtn.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.7);
			homeBtn.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.5);
			addChild(homeBtn);
		}
		public function dispose():void
		{
			if(restartBtn)
			{
				restartBtn.dispose();
			}
			if(resumeBtn)
			{
				resumeBtn.dispose();
			}
			if(homeBtn)
			{
				homeBtn.dispose();
			}
		}
	}
}