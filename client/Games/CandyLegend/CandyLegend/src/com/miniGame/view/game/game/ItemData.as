package com.miniGame.view.game.game
{
	public class ItemData
	{
		public var index:int;
		public var shape:int;
		public var bgColor:uint;
		public var textureColor:uint;
		public var texture:int;
		
		public function ItemData(index:int, shape:int, bgColor:uint, textureColor:uint, texture:int)
		{
			this.index = index;
			this.shape = shape;
			this.bgColor = bgColor;
			this.textureColor = textureColor;
			this.texture = texture;
			
		}
		
		public function toString():String
		{
			return index + " " + shape + " " +  bgColor + " " +  textureColor + " " + texture;
		}
	}
}