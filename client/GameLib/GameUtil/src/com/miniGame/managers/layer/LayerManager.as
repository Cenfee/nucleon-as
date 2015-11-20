package com.miniGame.managers.layer
{
	import flash.display.Sprite;
	

	public class LayerManager
	{
		private static var _instance:LayerManager;
		public static function getInstance():LayerManager
		{
			if(!_instance)
				_instance = new LayerManager();
			
			return _instance;
		}
		
		
		private var _gameLayer:Sprite;
		private var _popupLayer:Sprite;
		private var _alertLayer:Sprite;
		
		public function LayerManager()
		{
		}
		
		public function init(container:Sprite):void
		{
			_gameLayer = new Sprite();
			container.addChild(_gameLayer);
			
			_popupLayer = new Sprite();
			container.addChild(_popupLayer);
			
			_alertLayer = new Sprite();
			container.addChild(_alertLayer);
		}
		
		public function enableAllLayer():void
		{
			_gameLayer.mouseEnabled = true;
			_gameLayer.mouseChildren = true;
			
			_popupLayer.mouseEnabled = true;
			_popupLayer.mouseChildren = true;
			
			_alertLayer.mouseEnabled = true;
			_alertLayer.mouseChildren = true;
		}
		public function unableAllLayer():void
		{
			_gameLayer.mouseEnabled = false;
			_gameLayer.mouseChildren = false;
			
			_popupLayer.mouseEnabled = false;
			_popupLayer.mouseChildren = false;
			
			_alertLayer.mouseEnabled = false;
			_alertLayer.mouseChildren = false;
		}
		
		public function getGameLayer():Sprite
		{
			return _gameLayer;
		}
		
		public function getPopupLayer():Sprite
		{
			return _popupLayer;
		}
		
		public function getAlertLayer():Sprite
		{
			return _alertLayer;
		}
	}
}