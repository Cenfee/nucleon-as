package com.miniGame.view.game
{
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.popup.PopupManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.managers.scene.SceneManager;
	import com.miniGame.managers.view.IView;
	import com.miniGame.view.game.ctrl.GameSoundCtrl;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import gs.TweenMax;

	public class GameView extends Sprite implements IView
	{
		private var _backgoundLayer:BackgroundLayer;
		private var _uiLayer:UILayer;
		private var _animLayer:AnimLayer;
		private var _gameLayer:GameLayer;
		private var _timeupPanel:DisplayObject;
		private var _pausePanel:PausePanel;
		
		
		public function GameView()
		{
		}
		
		public function create(data:Object=null):void
		{
		}
		public function dispose():void
		{
		}
		
		//----------------base
		public function show(data:Object=null):void
		{
			_backgoundLayer = new BackgroundLayer();
			addChild(_backgoundLayer);
			_backgoundLayer.create();
			
			_animLayer = new AnimLayer();
			addChild(_animLayer);
			_animLayer.create();
			
			_uiLayer = new UILayer();
			addChild(_uiLayer);
			_uiLayer.create();
			_uiLayer.pauseBtn.addEventListener(MouseEvent.CLICK, pauseHandler);
			
			_gameLayer = new GameLayer();
			this.addChildAt(_gameLayer, 1);
			_gameLayer.gameSoundCtrl = new GameSoundCtrl();
			_gameLayer.onTimeup = timeupHandler;
			_gameLayer.onTimeCounter = timeCounterHandler;
			_gameLayer.onUpLevel = onUpLevelHand;
			_gameLayer.onPlayAnim = onPlayAnimHand;
			_gameLayer.create();
		}
		public function hide():void
		{
			_backgoundLayer.dispose();
			removeChild(_backgoundLayer);
			
			_gameLayer.dispose();
			removeChild(_gameLayer);
			
			_animLayer.dispose();
			removeChild(_animLayer);
			
			_uiLayer.dispose();
			_uiLayer.pauseBtn.removeEventListener(MouseEvent.CLICK, pauseHandler);
			removeChild(_uiLayer);
			
			
			if(_timeupPanel && _timeupPanel.parent) 
			{
				PopupManager.getInstance().remove(_timeupPanel);
			}
			
			if(_pausePanel)
			{
				_pausePanel.dispose();
				if(_pausePanel.parent)
					PopupManager.getInstance().remove(_pausePanel);
			}
		}
		
		//-----------------timeup start
		public function showTimeup():void
		{
			if(!_timeupPanel)
			{
				var timeupClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					ConfigManager.getInstance().entryAssetsUrl + "/timeup.swf", "timeup.Timeup");
				_timeupPanel = new timeupClass();
			}
			PopupManager.getInstance().add(
				_timeupPanel,
				ResponseManager.getInstance().getXLeftPercentOfVisible(0.5),
				ResponseManager.getInstance().getYTopPercentOfVisible(0.5));
			
			_gameLayer.gameSoundCtrl.playTimesupSound();
		}
		
		public function hideTimeup():void
		{
			PopupManager.getInstance().remove(_timeupPanel);
		}
		
		//-----------------pausepanel start
		public function showPausePanel():void
		{
			if(!_pausePanel)
			{
				_pausePanel = new PausePanel();
				_pausePanel.create();
				_pausePanel.restartBtn.addEventListener(MouseEvent.CLICK, restartHandler);
				_pausePanel.resumeBtn.addEventListener(MouseEvent.CLICK, resumeHandler);
				_pausePanel.homeBtn.addEventListener(MouseEvent.CLICK, homeHandler);
			}
			PopupManager.getInstance().add(
				_pausePanel,
				0,
				0);
		}
		private function restartHandler(event:MouseEvent):void
		{
			SceneManager.getInstance().switchScene(ConfigManager.GAME_VIEW, null, {unloadAssets:false});
		}
		private function resumeHandler(event:MouseEvent):void
		{
			resume();
		}
		private function homeHandler(event:MouseEvent):void
		{
			SceneManager.getInstance().switchScene(ConfigManager.LOGIN_VIEW, null, {unloadAssets:false});
		}
		
		public function hidePausePanel():void
		{
			PopupManager.getInstance().remove(_pausePanel);
		}
		
		
		//-----------------main 
		private function assetsCompleteHandler():void
		{
			
		}
		
		private function timeupHandler(level:int, recordBreaking:Boolean):void
		{
			showTimeup();
			TweenMax.delayedCall(2, function():void
			{
				hideTimeup();
				SceneManager.getInstance().switchScene(ConfigManager.GAME_OVER_VIEW, null, {unloadAssets:false, level:level});
				
				_gameLayer.gameSoundCtrl.playGameOverSound(recordBreaking);
			});
		}
		private function timeCounterHandler(time:Number, total:Number):void
		{
			_uiLayer.setCountDown(time, total);
		}
		
		private function onUpLevelHand(level:int, answerData:Object):void
		{
			_animLayer.updateQuestion(answerData);
			_uiLayer.setLevelUI(level);
			_backgoundLayer.update(level);
		}
		
		private function onPlayAnimHand(state:String, onPlayAnimComplete:Function = null, data:Object = null):void
		{
			_animLayer.playAnim(state, onPlayAnimComplete, data);
		}
		
		private function resume():void
		{
			_gameLayer.resume();
			
			hidePausePanel();
		}
		
		private function pauseHandler(event:MouseEvent):void
		{
			_gameLayer.pause();
			

			showPausePanel();
		}
	}
}