package com.miniGame.view.gameOver
{
	import com.miniGame.controls.ArtNumber;
	import com.miniGame.controls.SoundButton;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.managers.scene.SceneManager;
	import com.miniGame.managers.view.IView;
	import com.miniGame.model.MainModel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GameOverView extends Sprite implements IView
	{
		private var _bg:DisplayObject;
		private var _homeBtn:SoundButton;
		private var _backBtn:SoundButton;
		private var _label:MovieClip;
		private var _record:DisplayObjectContainer;
		
		private var _artNumInRecord:ArtNumber;
		private var _artNumInLabel:ArtNumber;
		
		public function GameOverView()
		{
		}
		public function create(data:Object=null):void
		{
		}
		public function dispose():void
		{
			if(_homeBtn)
			{
				_homeBtn.dispose();
			}
			if(_backBtn)
			{
				_backBtn.dispose();
			}
			
			_artNumInRecord.dispose();
			_artNumInLabel.dispose();
			_label.addFrameScript(_label.totalFrames - 1, null);
			_bg["lion_mc"].addFrameScript(_bg["lion_mc"].totalFrames - 1, null);
		}
		
		public function show(data:Object=null):void
		{
			if(data)
				MainModel.getInstance().setCurLevel(data["level"]);
			
			MainModel.getInstance().sendData(function():void
			{
				trace("数据保存成功");
			});
			
			var backgroundClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_OVER_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/end.swf", 
				"end.Background");
			var labelClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_OVER_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/end.swf", "end.Label");
			var homeBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_OVER_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/end.swf", "end.HomeBtn");
			var backBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_OVER_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/end.swf", "end.BackBtn");
			var recordClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_OVER_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/end.swf", "end.Record");
			var artNumClass:Class = AssetManager.getInstance().getAssetSwfClass(
				AssetManager.GLOBLE,
				ConfigManager.getInstance().entryAssetsUrl + "/number.swf",
				"number.artNum");
			
			
			_bg = new backgroundClass();
			_bg["lion_mc"].addFrameScript(_bg["lion_mc"].totalFrames - 1, onStopLionAnimHand);
			addChild(_bg);
			
			_label = new labelClass();
			_label.x = 585;
			_label.y = 76;
			_label.addFrameScript(_label.totalFrames - 1, onStopLabelAnimHand);
			addChild(_label);
			
			_homeBtn = new SoundButton(new homeBtnClass());
			_homeBtn.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.35);
			_homeBtn.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.8);
			_homeBtn.addEventListener(MouseEvent.CLICK, homeHandler);
			addChild(_homeBtn);
			
			_backBtn = new SoundButton(new backBtnClass());
			_backBtn.x = ResponseManager.getInstance().getXRightPercentOfVisible(0.35);
			_backBtn.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.8);
			_backBtn.addEventListener(MouseEvent.CLICK, backHandler);
			addChild(_backBtn);
			
			_record = new recordClass();
			_record.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.9);
			_record.y = ResponseManager.getInstance().getYTopPercentOfVisible(0.13);
			addChild(_record);
			
			_artNumInRecord = new ArtNumber(new artNumClass());
			_record.addChild(_artNumInRecord);
			_artNumInRecord.scaleX = _artNumInRecord.scaleY = 0.8;
			_artNumInRecord.x = _record["point_mc"].x;
			_artNumInRecord.y = _record["point_mc"].y;
			_artNumInRecord.rotation = _record["point_mc"].rotation;
			
			_artNumInLabel = new ArtNumber(new artNumClass());
			_label["point_mc"].addChild(_artNumInLabel);
			_artNumInLabel.scaleX = _artNumInLabel.scaleY = 1.2;
			
			_artNumInRecord.update(String(MainModel.getInstance().getMaxLevel()));
			_artNumInLabel.update(String(MainModel.getInstance().getCurLevel()));
			_label["word_mc"].x = _label["point_mc"].x + _artNumInLabel.width * .5;
			
//			(_label["label"] as TextField).text = String(MainModel.getInstance().getCurLevel()) + "关";
//			(_record["label"] as TextField).text = String(MainModel.getInstance().getMaxLevel());
		}
		public function hide():void
		{
		}
		
		private function onStopLabelAnimHand():void
		{
			_label.addFrameScript(_label.totalFrames - 1, null);
			_label.gotoAndStop(1);
		}
		
		private function onStopLionAnimHand():void
		{
			_bg["lion_mc"].addFrameScript(_bg["lion_mc"].totalFrames - 1, null);
//			_bg["lion_mc"].gotoAndStop(1);
		}
		
		private function homeHandler(event:MouseEvent):void
		{
			SceneManager.getInstance().switchScene(ConfigManager.LOGIN_VIEW, null, {unloadAssets:false});
		}
		private function backHandler(event:MouseEvent):void
		{
			SceneManager.getInstance().switchScene(ConfigManager.GAME_VIEW, null, {unloadAssets:false});
		}
	}
}