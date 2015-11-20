package com.miniGame.view.login
{
	import com.miniGame.controls.ArtNumber;
	import com.miniGame.controls.SoundButton;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.popup.PopupManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.managers.scene.SceneManager;
	import com.miniGame.managers.sound.SoundManager;
	import com.miniGame.managers.statistics.StatisticsManager;
	import com.miniGame.managers.view.IView;
	import com.miniGame.model.MainModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LoginView extends Sprite implements IView
	{
		
		private var _bg:DisplayObject;
		private var _startBtn:SoundButton;
		private var _settingBtn:SoundButton;
		private var _record:DisplayObjectContainer;
		
		private var _settingPanel:SettingPanel;
		private var _artNum:ArtNumber;
		
		public function LoginView()
		{
			
		}
		public function create(data:Object=null):void
		{
		}
		public function dispose():void
		{
			if(_settingPanel)
			{
				_settingPanel.backBtn.removeEventListener(MouseEvent.CLICK, closeSettingHandler);
				_settingPanel.dispose();
			}
			
			if(_startBtn)
			{
				_startBtn.dispose();
			}
			if(_settingBtn)
			{
				_settingBtn.dispose();
			}
			_artNum.dispose();
		}
		public function show(data:Object=null):void
		{
			playSound();
			
			var backgroundClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.LOGIN_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/start.swf", 
				"start.Background");
			
			_bg = new backgroundClass();
			addChild(_bg);
			
			MainModel.getInstance().requestData(loadCompleteHandler);
		}
		public function hide():void
		{
			_startBtn.removeEventListener(MouseEvent.CLICK, startHandler);
			_settingBtn.removeEventListener(MouseEvent.CLICK, settingHandler);
			_record.removeEventListener(MouseEvent.CLICK, recordHandler);
		}
		
		private function loadCompleteHandler():void
		{
			var startBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.LOGIN_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/start.swf", 
				"start.StartBtn");
			var settingBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.LOGIN_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/start.swf",
				"start.SettingBtn");
			var recordClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.LOGIN_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/start.swf", 
				"start.Record");
			var artNumClass:Class = AssetManager.getInstance().getAssetSwfClass(
				AssetManager.GLOBLE,
				ConfigManager.getInstance().entryAssetsUrl + "/number.swf",
				"number.artNum");
			
			
			_startBtn = new SoundButton(new startBtnClass());
			_startBtn.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.5);
			_startBtn.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.84);
			_startBtn.addEventListener(MouseEvent.CLICK, startHandler);
			addChild(_startBtn);
			
			_settingBtn =  new SoundButton(new settingBtnClass());
			_settingBtn.x = ResponseManager.getInstance().getXLeftMarginOfVisible(80);
			_settingBtn.y = ResponseManager.getInstance().getYTopMarginOfVisible(80);
			_settingBtn.addEventListener(MouseEvent.CLICK, settingHandler);
			addChild(_settingBtn);
			
			_record = new recordClass();
			_record.x = ResponseManager.getInstance().getXRightMarginOfVisible(120);
			_record.y = ResponseManager.getInstance().getYTopMarginOfVisible(110);
			_record.addEventListener(MouseEvent.CLICK, recordHandler);
			addChild(_record);
			
			_artNum = new ArtNumber(new artNumClass());
			_record.addChild(_artNum);
			_artNum.scaleX = _artNum.scaleY = 0.8;
			_artNum.x = _record["point_mc"].x;
			_artNum.y = _record["point_mc"].y;
			_artNum.rotation = _record["point_mc"].rotation;
			
			if(MainModel.getInstance().getMaxLevel())
			{
				_artNum.update(String(MainModel.getInstance().getMaxLevel()));
//				(_record["label"] as TextField).text = String(MainModel.getInstance().getMaxLevel());
//				_artNum.update("123");
				
				_record.visible = true;
			}
			else
			{
				_record.visible = false;
			}
			
			StatisticsManager.getInstance().send(true);
		}
		
		private function playSound():void
		{
			var soundRoot:String = ConfigManager.getInstance().entryAssetsUrl + "/sounds/";
			SoundManager.getInstance().stopCategorySounds(SoundManager.MUSIC_MIXER_CATEGORY);
			SoundManager.getInstance().stream(soundRoot + ConfigManager.LOGIN_VIEW_BG_SOUND_URL, 
											  SoundManager.MUSIC_MIXER_CATEGORY, 
											  0, 
											  int.MAX_VALUE);
		}
		
		//-----------------timeup start
		public function showSetting():void
		{
			if(!_settingPanel)
			{
				_settingPanel = new SettingPanel();
				_settingPanel.create();
				_settingPanel.backBtn.addEventListener(MouseEvent.CLICK, closeSettingHandler);
			}
			PopupManager.getInstance().add(_settingPanel, 0, 0);
		}
		
		private function closeSettingHandler(event:MouseEvent):void
		{
			hideSetting();
		}
		public function hideSetting():void
		{
			PopupManager.getInstance().remove(_settingPanel);
		}
		
		private function startHandler(event:MouseEvent):void
		{
			if(MainModel.getInstance().getGuide() > 0)
				SceneManager.getInstance().switchScene(ConfigManager.GAME_VIEW, null, {unloadAssets:false});
			else
				SceneManager.getInstance().switchScene(ConfigManager.GUIDE_VIEW, null, {unloadAssets:false});
			
			//TODO: [调试]快速切换View
//			SceneManager.getInstance().switchScene(ConfigManager.GAME_OVER_VIEW);
		}
		
		private function settingHandler(event:MouseEvent):void
		{
			showSetting();
		}
		
		private function recordHandler(event:MouseEvent):void
		{
			
		}
	}
}