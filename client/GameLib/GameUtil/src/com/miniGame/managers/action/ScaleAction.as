package com.miniGame.managers.action
{
	import gs.TweenMax;

	public class ScaleAction implements IAction
	{
		public function ScaleAction()
		{
		}
		
		private var _tweenMax:TweenMax;
		
		public var scaleTo:Number;
		
		public function create(target:Object, data:Object=null):void
		{
			_tweenMax = TweenMax.to(target, 1, {scaleX:scaleTo, scaleY:scaleTo, loop:0 , onComplete:function():void
			{
				
				if(data)
				{
					if(data["onComplete"])
						data["onComplete"]();
				}
				dispose();
			
			}});
		}
		
		public function dispose():void
		{
			TweenMax.removeTween(_tweenMax);
		}
		
		
		
		
		public function resume():void
		{
		}
		
		public function pause():void
		{
		}
	}
}