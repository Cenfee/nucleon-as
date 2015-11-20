package com.miniGame.managers.response
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	public class ResponseManager
	{
		private static var _instance:ResponseManager;
		public static function getInstance():ResponseManager
		{
			if(!_instance)
				_instance = new ResponseManager();
			
			return _instance;
		}
		
		
		public var gameBoundOriginal:Rectangle;
		
		public var fullScreenBoundNative:Rectangle;
		public var gameBoundNative:Rectangle;
		
		public var gameBoundScale:Rectangle;
		public var fullScreenBoundScale:Rectangle;
		
		
		public var gameScale:Number;
		public var container:Sprite;
		
		public function ResponseManager()
		{
		}
		
		public function init(gameWidth:Number, gameHeight:Number, fullScreenWidth:Number, fullScreenHeight:Number):void
		{
			
			gameScale = getGameScale("small", gameWidth, gameHeight, fullScreenWidth, fullScreenHeight);
			
			gameBoundOriginal = new Rectangle(0, 0, gameWidth, gameHeight);
			
			fullScreenBoundNative = new Rectangle(0, 0, fullScreenWidth, fullScreenHeight);
			gameBoundNative = getGameBoundNative();
			
			
			
			gameBoundScale = new Rectangle(0, 0, gameWidth, gameHeight);
			fullScreenBoundScale = getFullScreenBoundScale();
			
			container = new Sprite();
			container.x = gameBoundNative.x;
			container.y = gameBoundNative.y;
			container.scaleX = gameScale;
			container.scaleY = gameScale;
		}
		
		private function getGameScale(type:String, gameWidth:Number, gameHeight:Number, fullScreenWidth:Number, fullScreenHeight:Number):Number
		{
			var gameRatioOriginal:Number = gameWidth / gameHeight;
			var gameRatioFull:Number = fullScreenWidth / fullScreenHeight;
			
			var gameScale:Number;
			
			if(type == "big")
			{
				gameRatioOriginal > gameRatioFull ? 
					gameScale = fullScreenHeight / gameHeight :
					gameScale = fullScreenWidth / gameWidth;
			}
			else
			{
				gameRatioOriginal > gameRatioFull ?
					gameScale = fullScreenWidth / gameWidth :
					gameScale = fullScreenHeight / gameHeight;
			}
			
			
			return gameScale;
		}
		
		private function getGameBoundNative(type:String="small"):Rectangle
		{
			var bound:Rectangle = new Rectangle();
			bound.width = gameBoundOriginal.width * gameScale;
			bound.height = gameBoundOriginal.height * gameScale;
			bound.x = -(bound.width - fullScreenBoundNative.width) * 0.5;
			bound.y = -(bound.height - fullScreenBoundNative.height) * 0.5;
			return bound;
		}
		private function getFullScreenBoundScale(type:String="small"):Rectangle
		{
			var bound:Rectangle = new Rectangle();
			bound.width = (fullScreenBoundNative.width - gameBoundNative.width) / gameScale + gameBoundOriginal.width;
			bound.height = (fullScreenBoundNative.height - gameBoundNative.height) / gameScale + gameBoundOriginal.height;
			bound.x = -(bound.width - gameBoundScale.width) * 0.5;
			bound.y = -(bound.height - gameBoundScale.height) * 0.5;
			return bound;
		}
		
		
		public function getXLeftPercentOfVisible(value:Number):Number
		{
			return ((-container.x) + fullScreenBoundNative.width *　value) / gameScale;
		}
		public function getXRightPercentOfVisible(value:Number):Number
		{
			return ((-container.x) + fullScreenBoundNative.width - fullScreenBoundNative.width *　value) / gameScale;
		}
		public function getYTopPercentOfVisible(value:Number):Number
		{
			return ((-container.y) + fullScreenBoundNative.height *　value) / gameScale;
		}
		public function getYBottomPercentOfVisible(value:Number):Number
		{
			return ((-container.y) + fullScreenBoundNative.height - fullScreenBoundNative.height *　value) / gameScale;
		}
		
		public function getXLeftMarginOfVisible(marginLeft:Number):Number
		{
			return ((-container.x) + marginLeft * gameScale) / gameScale;
		}
		public function getXRightMarginOfVisible(marginRight:Number):Number
		{
			return ((-container.x) + fullScreenBoundNative.width - marginRight * gameScale) / gameScale;
		}
		public function getYTopMarginOfVisible(marginTop:Number):Number
		{
			return ((-container.y) + marginTop * gameScale) / gameScale;
		}
		public function getYBottomMarginOfVisible(marginBottom:Number):Number
		{
			return ((-container.y) + fullScreenBoundNative.height - marginBottom * gameScale) / gameScale;
		}
	}
}