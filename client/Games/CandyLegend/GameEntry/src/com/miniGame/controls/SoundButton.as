package com.miniGame.controls
{
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.sound.SoundManager;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SoundButton extends Sprite
	{
		private var _target:InteractiveObject;
		
		public function SoundButton(target:InteractiveObject)
		{
			_target = target;
			addChild(_target);
			
			_target.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		
		public function dispose():void
		{
			_target.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			SoundManager.getInstance().play(
				AssetManager.getInstance().getAsset(AssetManager.GLOBLE, "entryAssets/sounds/button.mp3"));
		}
	}
}