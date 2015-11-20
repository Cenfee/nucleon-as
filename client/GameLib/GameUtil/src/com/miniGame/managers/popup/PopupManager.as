package com.miniGame.managers.popup
{
	import com.miniGame.managers.layer.LayerManager;
	import com.miniGame.managers.response.ResponseManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	public class PopupManager
	{
		
		private static var _instance:PopupManager;
		public static function getInstance():PopupManager
		{
			if(!_instance)
				_instance = new PopupManager();
			
			return _instance;
		}
		
		public function PopupManager()
		{
		}
		
		private var _gameWidth:Number;
		private var _gameHeight:Number;
		private var _cover:Sprite;
		
		public function init(gameWidth:Number, gameHeight:Number):void
		{
			_gameWidth = gameWidth;
			_gameHeight = gameHeight;
		}
		
		public function add(object:DisplayObject, x:Number=0, y:Number=0):void
		{
			object.x = x;
			object.y = y;
			LayerManager.getInstance().getPopupLayer().addChild(object);
			
			addCover();
		}
		public function remove(object:DisplayObject):void
		{
			LayerManager.getInstance().getPopupLayer().removeChild(object);
			
			if(LayerManager.getInstance().getPopupLayer().numChildren < 2)
			{
				removeCover();
			}
		}
		
		public function addCover():void
		{
			if(!_cover)
			{
				_cover = new Sprite();
				_cover.graphics.beginFill(0x000000, 0.8);
				_cover.graphics.drawRect(
					ResponseManager.getInstance().fullScreenBoundScale.x, 
					ResponseManager.getInstance().fullScreenBoundScale.y, 
					ResponseManager.getInstance().fullScreenBoundScale.width, 
					ResponseManager.getInstance().fullScreenBoundScale.height);
				_cover.graphics.endFill();
			}
			LayerManager.getInstance().getPopupLayer().addChildAt(_cover, 0); 
		}
		
		public function removeCover():void
		{
			if(_cover.parent)
			{
				LayerManager.getInstance().getPopupLayer().removeChild(_cover);
			}
		}
	}
}