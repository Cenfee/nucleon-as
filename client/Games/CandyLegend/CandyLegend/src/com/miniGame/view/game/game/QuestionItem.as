package com.miniGame.view.game.game
{
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class QuestionItem extends Sprite
	{
		private var _shapeObjects:Object = {};
		private var _shapeObject:MovieClip;
		
		public var data:Object;
		
		public function QuestionItem()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			this.scaleX = this.scaleY = 1;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.scaleX = this.scaleY = 0.85;
		}
		
		public function dispose():void
		{
			data = null;
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		public function update(shape:int, bgColor:uint, textureColor:uint, texture:int):void
		{
			if(_shapeObject && _shapeObject.parent)
				removeChild(_shapeObject);
			
			_shapeObject = _shapeObjects[shape];
			
			if(!_shapeObject)
			{
				var shapeClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					"assets/texture" + shape + ".swf",
					"texture.Shape" + shape);
				
				_shapeObject = new shapeClass();
				
				_shapeObjects[shape] = _shapeObject;
			}
			
			
			_shapeObject.gotoAndStop(texture);
			var bgColorTf:ColorTransform = new ColorTransform();
			bgColorTf.color = bgColor;
			var textureColorTf:ColorTransform = new ColorTransform();
			textureColorTf.color = textureColor;
			
			var objectBg:DisplayObject = _shapeObject["bg"] as DisplayObject;
			var objectTexture:DisplayObject = _shapeObject["texture"] as DisplayObject;
			objectBg.transform.colorTransform = bgColorTf;
			objectTexture.transform.colorTransform = textureColorTf;
			
			if(shape == ShapeType.Lollipop)
			{//波板糖要倾斜显示
				_shapeObject.rotation = 30;
			}
			if(this.alpha == 0)
			{
				this.alpha = 1;
			}
			
			addChild(_shapeObject);
		}
		
		//=====================Getter And Setter=======================
		public function get shapeWidth():Number
		{
			return _shapeObject.getBounds(_shapeObject).width;
		}
		
		public function get shapeHeight():Number
		{
			return _shapeObject.getBounds(_shapeObject).height;
		}
		//=============================================================
	}
}