package com.miniGame.view.guide
{
	import com.miniGame.controls.SoundButton;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.managers.scene.SceneManager;
	import com.miniGame.managers.sound.SoundManager;
	import com.miniGame.managers.view.IView;
	import com.miniGame.model.MainModel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GuideView extends Sprite implements IView
	{
		
		private var _guideAnim:MovieClip;
//		private var _skipBtn:SoundButton;
		
		public function GuideView()
		{
			
		}
		public function create(data:Object=null):void
		{
			playSound();
		}
		public function dispose():void
		{
			/*if(_skipBtn)
			{
				_skipBtn.dispose();
			}*/
			
			this.removeEventListener(MouseEvent.CLICK, skipHandler);
		}
		public function show(data:Object=null):void
		{
			var GuideAnimClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GUIDE_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/help.swf", 
				"help.GuideAnim");
			var SkinBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GUIDE_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/help.swf",
				"help.BackBtn");
			
			_guideAnim = new GuideAnimClass();
			addChild(_guideAnim);
			
			/*_skipBtn = new SoundButton(new SkinBtnClass());
			_skipBtn.x = ResponseManager.getInstance().getXRightMarginOfVisible(70);
			_skipBtn.y = ResponseManager.getInstance().getYBottomMarginOfVisible(70);
			_skipBtn.addEventListener(MouseEvent.CLICK, skipHandler);
			addChild(_skipBtn);*/
			
			this.addEventListener(MouseEvent.CLICK, skipHandler);
		}
		public function hide():void
		{
			MainModel.getInstance().setGuide();
			MainModel.getInstance().sendData();
		}
		
		private function skipHandler(event:MouseEvent):void
		{
			SceneManager.getInstance().switchScene(ConfigManager.GAME_VIEW, null, {unloadAssets:false});
		}
		
		private function playSound():void
		{
			var soundRoot:String = ConfigManager.getInstance().entryAssetsUrl + "/sounds/";
			SoundManager.getInstance().stopCategorySounds(SoundManager.MUSIC_MIXER_CATEGORY);
			SoundManager.getInstance().stream(soundRoot + ConfigManager.GUIDE_VIEW_BG_SOUND_URL, 
											  SoundManager.MUSIC_MIXER_CATEGORY, 
											  0, 
											  int.MAX_VALUE);
		}
	}
}