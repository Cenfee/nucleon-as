package com.miniGame.view.game.game
{
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.configs.GameConfig;
	import com.miniGame.managers.layer.LayerManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import gs.TweenMax;
	
	public class QuestionPanel extends Sprite
	{
		public var onItemSelect:Function;
		
		private var items:Vector.<QuestionItem> = new Vector.<QuestionItem>();
		private var itemsLayoutContainer:Sprite;
		
		private var _tween:TweenMax;
		
		private var tweenComplete:Function;
		
		public function QuestionPanel()
		{
			super();
		}
		
		public function dispose():void
		{
			disposeTween();
			
			var itemIndex:int=0;
			for(itemIndex = 0; itemIndex < items.length; ++itemIndex)
			{
				var item:QuestionItem = items[itemIndex];
				item.removeEventListener(MouseEvent.CLICK, itemHandler);
				item.dispose();
			}
			items.length = 0;
			
			onItemSelect = null;
			tweenComplete = null;
		}
		
		
		public function update(data:Vector.<ItemData>):void
		{
			LayerManager.getInstance().unableAllLayer();
			var itemCount:int = data.length;
			
			if(!itemsLayoutContainer)
			{
				itemsLayoutContainer = new Sprite();
				addChild(itemsLayoutContainer);
			}
			itemsLayoutContainer.scaleX = itemsLayoutContainer.scaleY = 1;
			
			/**X偏移值**/
			var deviantX:Number;
			/**Y偏移值**/
			var deviantY:Number;
			/**item的最大高度**/
			var itemMaxHeight:Number;
			/**Item间是否需要添加间距**/
			var addItemGap:Boolean = true;
			
			var itemIndex:int=0;
			for(itemIndex = 0; itemIndex < items.length; ++itemIndex)
			{
				if(items[itemIndex].parent)
					itemsLayoutContainer.removeChild(items[itemIndex]);
			}
			
			for(itemIndex = 0; itemIndex < itemCount; ++itemIndex)
			{
				var item:QuestionItem;
				if(items.length <= itemIndex)
				{
					item = new QuestionItem();
					item.addEventListener(MouseEvent.CLICK, itemHandler);
					items.push(item);
				}
				else
				{
					item = items[itemIndex];
				}
				
				var row:int = itemIndex / 3;
				var col:int = itemIndex - row * 3;
				
				var itemData:ItemData = data[itemIndex];
				item.update(itemData.shape, itemData.bgColor, itemData.textureColor, itemData.texture);
				item.data = itemData;
				
				if(itemData.shape == ShapeType.Lollipop)
				{
					addItemGap = false;
				}
				
				if(itemIndex == 0)
				{
					deviantX = item.width * .5;
				}
				if(row == 0)
				{
					if(itemIndex == 0)
					{
						itemMaxHeight = item.shapeHeight;
					}
					else
					{
						itemMaxHeight = Math.max(itemMaxHeight, item.shapeHeight);
					}
					deviantY = itemMaxHeight * .5;
				}
				
//				trace("maxHeight:" + maxHeight, item.shapeHeight);
				var itemGapX:Number = addItemGap ? GameConfig.itemGapX : 0;
				var itemGapY:Number = addItemGap ? GameConfig.itemGapY : 0;
				item.x = col * (180 + itemGapX);
				item.y = row * (itemMaxHeight + itemGapY);//行号*(物品高 +行间距)
				itemsLayoutContainer.addChild(item);
			}
			
//			trace(itemsLayoutContainer.width, itemsLayoutContainer.height);
			if(itemsLayoutContainer.height > 480)
			{
				itemsLayoutContainer.height = 480;
				itemsLayoutContainer.scaleX = itemsLayoutContainer.scaleY;
			}
			
			itemsLayoutContainer.x = -itemsLayoutContainer.width * 0.5 + deviantX;
			itemsLayoutContainer.y = -itemsLayoutContainer.height * 0.5 + deviantY;
		}
		
		public function itemTween(recall:Function = null):void
		{
			tweenComplete = recall;
			
			_tween = TweenMax.from(this, 0.3, 
				{y:ConfigManager.GAME_HEIGHT + this.height + this.height * .5, 
					delay:0.3, 
					onComplete:onItemTweenComplete
				});
		}
		
		public function getItemPos(item:QuestionItem):Point
		{
			var pos:Point = new Point();
			pos.x = item.x + itemsLayoutContainer.x + this.x;
			pos.y = item.y + itemsLayoutContainer.y + this.y;
			return pos;
		}

		private function onItemTweenComplete():void
		{
			LayerManager.getInstance().enableAllLayer();
			
			if(tweenComplete != null)
			{
				tweenComplete();
			}
		}
		
		private function itemHandler(event:MouseEvent):void
		{
			var item:QuestionItem = event.currentTarget as QuestionItem;
			onItemSelect(item);
		}
		
		private function disposeTween():void
		{
			if(_tween)
			{
				TweenMax.killTweensOf(_tween, true);
				_tween = null;
			}
		}
	}
}