package com.miniGame.view.game
{
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import gs.TweenMax;
	

	public class BackgroundLayer extends Sprite
	{
		public var bg:MovieClip;
		public var itemPanel:MovieClip;

		private var _itemPanelTween:TweenMax;
		
		public function BackgroundLayer()
		{
		}
		
		public function dispose():void
		{
			disposeTween();
		}
		public function create():void
		{
			var backgroundClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/game.swf", "game.Background");
			bg = new backgroundClass() as MovieClip;
			bg.stop();
			addChild(bg);
			
			var itemPanelClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/game.swf", "game.itemPanel");
			itemPanel = new itemPanelClass();
			itemPanel.stop();
			itemPanel.x = 750;
			itemPanel.y = 420;
			addChild(itemPanel);
		}
		
		public function update(level:int):void
		{
			if(level == 1)
			{
				bg.gotoAndStop(1);
				itemPanel.gotoAndStop(1);
			}
			else if(level == 26)
			{
				bg.gotoAndStop(2);
				itemPanel.gotoAndStop(2);
			}
			
			itemPanelTween();
		}

		private function itemPanelTween():void
		{
			if(!_itemPanelTween)
			{
				_itemPanelTween = TweenMax.from(itemPanel, 0.3, {y:ConfigManager.GAME_HEIGHT + itemPanel.height * 0.5});
			}
			else
			{
				_itemPanelTween.restart();
			}
		}
		
		private function disposeTween():void
		{
			if(_itemPanelTween)
			{
				TweenMax.killTweensOf(_itemPanelTween, true);
				_itemPanelTween = null;
			}
		}
	}
}