package com.miniGame.controls
{
	import com.miniGame.managers.debug.DebugManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ArtNumber extends Sprite
	{
		/**数字间的间隔**/
		public var gap:Number = 0;
		/**数字MC,注册点在中间**/
		private var skin:MovieClip;
		/**数字对象池**/
		private var artNumPool:Vector.<MovieClip> = new Vector.<MovieClip>;
		
		public function ArtNumber(skin:MovieClip, poolSize:int = 4)
		{
			super();
			
			this.skin = skin;
			createArtNumPool(poolSize);
		}
		
		public function dispose():void
		{
			removeAll();
			artNumPool.length = 0;
			
			skin = null;
		}
		
		public function createArtNumPool(size:int = 4):void
		{
			var artNumClass:Class = getDefinitionByName(getQualifiedClassName(skin)) as Class;
			
			if(artNumPool.length > 0)
				artNumPool.length = 0;
			for (var i:int = 0; i < size; i++) 
			{
				artNumPool.push(new artNumClass() as MovieClip);
			}
		}
		
		/**
		 * 可支持时间格式[00:00:00],通过检测是否存在冒号来判断数字的显示格式
		 * @param numStr
		 * 
		 */		
		public function update(numStr:String):void
		{
			var numLen:int = numStr.length;
			var artNumClone:MovieClip;
			//artNum在容器内部居中显示
//			-(numLen * artNumPool[0].width) * .5 + artNumPool[0].width * .5;
			var startX:Number = -(numLen - 1) * artNumPool[0].width * .5;
			var numberStr:String;
			
			removeAll();
			try
			{
				for (var i:int = 0; i < numLen; i++) 
				{
					artNumClone = artNumPool[i];
					numberStr = numStr.substr(i, 1);
					if(numberStr == ":")
					{
						artNumClone.gotoAndStop(11);
					}
					else
					{
						artNumClone.gotoAndStop(int(numberStr) + 1);
					}
					artNumClone.x = startX + i * (artNumClone.width + gap);
					this.addChild(artNumClone);
				}
			}
			catch(e:Error)
			{
				if(numLen > artNumPool.length)
					DebugManager.getInstance().error("com.miniGame.controls.ArtNumber类 -> create():" +
						"对象池(artNumPool)对象不足");
			}
		}
		
		public function removeAll():void
		{
			if (this.numChildren > 0)
			{
				while (this.numChildren)
				{
					this.removeChildAt(0);
				}
			}
		}
	}
}