package com.miniGame.view.game
{
	import com.miniGame.controls.ArtNumber;
	import com.miniGame.controls.SoundButton;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.math.TimeUtil;
	import com.miniGame.managers.response.ResponseManager;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class UILayer extends Sprite
	{
		public var level:MovieClip;
		public var countDown:MovieClip;
		public var pauseBtn:InteractiveObject;
		
		private var _artNumInLevel:ArtNumber;
		private var _artNumInCountDown:ArtNumber;
		
		public function UILayer()
		{
		}
		
		public function create():void
		{
			var levelClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/game.swf", "game.Level");
			var countDownClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/game.swf", "game.Countdown");
			var pauseBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/game.swf", "game.PauseBtn");
			var artNumClass:Class = AssetManager.getInstance().getAssetSwfClass(
				AssetManager.GLOBLE,
				ConfigManager.getInstance().entryAssetsUrl + "/number.swf", "number.artNum");
			
			
			level = new levelClass();
			level.x = ResponseManager.getInstance().getXLeftMarginOfVisible(100);
			level.y = ResponseManager.getInstance().getYTopMarginOfVisible(90);
			level.stop();
			level.addFrameScript(level.totalFrames - 1, onPlayUpLevelEffectCompleteHand);
			addChild(level);
			
			countDown = new countDownClass();
			countDown.x = ResponseManager.getInstance().getXLeftPercentOfVisible(0.5);
			countDown.y = ResponseManager.getInstance().getYTopMarginOfVisible(70);
			addChild(countDown);
			
			pauseBtn = new SoundButton(new pauseBtnClass());
			pauseBtn.x = ResponseManager.getInstance().getXRightMarginOfVisible(70);
			pauseBtn.y = ResponseManager.getInstance().getYTopMarginOfVisible(70);
			addChild(pauseBtn);
			
			_artNumInLevel = new ArtNumber(new artNumClass());
			level["point_mc"].addChild(_artNumInLevel);
			_artNumInLevel.scaleX = _artNumInLevel.scaleY = 0.8;
			
			_artNumInCountDown = new ArtNumber(new artNumClass(), 5);
			countDown["time_mc"].addChild(_artNumInCountDown);
			_artNumInCountDown.scaleX = _artNumInCountDown.scaleY = 0.8;
			_artNumInCountDown.x = countDown["time_mc"]["point_mc"].x;
			_artNumInCountDown.y = countDown["time_mc"]["point_mc"].y;
			_artNumInCountDown.rotation = countDown["time_mc"]["point_mc"].rotation;
			
			setCountDown(1, 1);
		}
		public function dispose():void
		{
			level.addFrameScript(level.totalFrames - 1, null);
			
			_artNumInLevel.dispose();
			_artNumInCountDown.dispose();
		}
		
		/**更新时间条**/
		public function setCountDown(value:Number, total:Number):void
		{
			var timeUtil:TimeUtil = TimeUtil.fromSeconds(value);
//			trace(timeUtil.formatString2);
			_artNumInCountDown.update(timeUtil.formatString2);
			
			var totalFrames:int = (countDown as MovieClip).totalFrames;
			var frame:int = totalFrames - value / total * totalFrames;
			if(frame < 1) frame = 1;
			if(frame >= totalFrames) frame = totalFrames;
			
			(countDown as MovieClip).gotoAndStop(frame);
		}
		
		/**更新当前Level**/
		public function setLevelUI(_level:int):void
		{
			_artNumInLevel.update(_level + "");
			if(_level > 1)
				level.play();
//			(level["label"] as TextField).text = String(_level);
		}
		
		private function onPlayUpLevelEffectCompleteHand():void
		{
			level.gotoAndStop(1);
		}
	}
}