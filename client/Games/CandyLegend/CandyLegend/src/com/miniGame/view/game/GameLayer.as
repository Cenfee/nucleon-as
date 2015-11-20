package com.miniGame.view.game
{
	
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.configs.GameConfig;
	import com.miniGame.managers.configs.LevelConfig;
	import com.miniGame.managers.layer.LayerManager;
	import com.miniGame.managers.math.MathUtil;
	import com.miniGame.managers.update.IUpdate;
	import com.miniGame.managers.update.UpdateManager;
	import com.miniGame.model.MainModel;
	import com.miniGame.view.game.ctrl.GameSoundCtrl;
	import com.miniGame.view.game.game.ItemData;
	import com.miniGame.view.game.game.QuestionItem;
	import com.miniGame.view.game.game.QuestionPanel;
	
	import flash.display.Sprite;
	
	public class GameLayer extends Sprite implements IUpdate
	{
		public var gameSoundCtrl:GameSoundCtrl;
		
		/**时间到**/
		public var onTimeup:Function;
		/**倒计时**/
		public var onTimeCounter:Function;
		/**升级**/
		public var onUpLevel:Function;
		/**播放动画**/
		public var onPlayAnim:Function;
		
		private var _timeCounter:Number;
		private var _timeTotal:Number;
		
		private var _level:int;
		private var _levelConfig:LevelConfig;
		
		private var _questionPanel:QuestionPanel;
		private var answerData:Object;
		
		private var _comboCounter:int = 0;
		
		public function GameLayer()
		{
		}
		
		public function create():void
		{
			_questionPanel = new QuestionPanel();
			_questionPanel.x = 755;
			_questionPanel.y = 400;
			_questionPanel.onItemSelect = itemSelectHandler;
			addChild(_questionPanel);
			
			//显示_questionPanel的中心点
			/*this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(_questionPanel.x, _questionPanel.y, 10, 10);
			this.graphics.endFill();*/
						
			startLevel();
		}
		
		public function dispose():void
		{
			
			UpdateManager.getInstance().remove(this);
			
			_questionPanel.dispose();
			
			onTimeup = null;
			onTimeCounter = null;
			onUpLevel = null;
			onPlayAnim = null;
		}
		
		private function startLevel():void
		{
			_timeTotal = GameConfig.totalTime;
			_timeCounter = _timeTotal;
			_level = 0;
			UpdateManager.getInstance().add(this);
			
			newLevel();
		}
		
		private function playBgSound():void
		{
			if(_level == 1)
			{
				gameSoundCtrl.playBgSound();
			}
			else if(_level == 26)
			{
				gameSoundCtrl.playBgSound(true);
			}
		}
		
		private function newLevel():void
		{
			++_level;
			//TODO: [调试]跳关
			if(_level == 1)
			{
				_level = 25;
			}
			
			resume();
			playBgSound();
			gameSoundCtrl.playPlateChangeSound();
			
			//超过最大关卡，读取最后一关数据
			var newLevelConfig:LevelConfig = ConfigManager.getInstance().getLevelConfig(_level-1, LevelConfig);
			_levelConfig = (newLevelConfig && newLevelConfig.shape) ? newLevelConfig : _levelConfig;
			
			//获取配置数据
			var shapeArr:Array = _levelConfig.shape.split(",");
			var colorArr:Array = _levelConfig.color.split(",");
			var textureArr:Array = _levelConfig.texture.split(",");
			
			var quantityMin:int = _levelConfig.quantity_min;
			var quantityMax:int = _levelConfig.quantity_max;
			var itemCount:int = quantityMin + (quantityMax - quantityMin + 1) * Math.random();
			
			var answerIndex:int;
			//种类数少于最大数量,抽取相同值(排除答案)
			var canTotalCount:int = shapeArr.length * colorArr.length * textureArr.length;
			if(canTotalCount >= itemCount)
				answerIndex = int(itemCount * Math.random());
			else
				answerIndex = int(canTotalCount * Math.random());
			
			//生成本关卡的选择子项的数据
			var itemsData:Vector.<ItemData> = new Vector.<ItemData>();
			for(var itemIndex:int = 0; itemIndex < itemCount; ++itemIndex)
			{
				var itemData:ItemData;
				
				//种类数少于最大数量,抽取相同值(排除答案)
				if(itemIndex < canTotalCount - 1)
				{
					itemData = getItemData(itemIndex, shapeArr, colorArr, textureArr, itemsData);
				}
				else
				{
					var repeatIndex:int = MathUtil.getRandomNoOne(0, itemsData.length - 1, answerIndex);
					itemData = itemsData[repeatIndex];
				}
				
				itemsData.push(itemData);
			}
			
			//生成答案子项数据
			answerData = itemsData[answerIndex];
			
			_questionPanel.update(itemsData);
			_questionPanel.itemTween(function():void
									 {
										 if(_level == 1)
										 {//播放倒计时
											 pause();
											 LayerManager.getInstance().unableAllLayer();
											 gameSoundCtrl.playCountdownSound();
											 onPlayAnim(AnimLayer.COUNTDOWN, onCountdownAnimPlayCompleteHand);
										 }
									 });
			onUpLevel(_level, answerData);
		}
		
		private function onCountdownAnimPlayCompleteHand():void
		{
			LayerManager.getInstance().enableAllLayer();
			resume();
		}
		
		private function itemSelectHandler(item:QuestionItem):void
		{
			LayerManager.getInstance().unableAllLayer();
			
			
			var itemData:Object = item.data;
			var comboMax:int = GameConfig.comboMax;
			
			if(itemData["index"] == answerData["index"])
			{
				pause();
				_comboCounter++;
				gameSoundCtrl.playRightWrong(true, _comboCounter, comboMax);
				
				var itemInfo:Object = _questionPanel.getItemPos(item);
				item.alpha = 0;
				onPlayAnim(AnimLayer.ITEM_ANIM,
				function():void
				{
					if(_comboCounter >= comboMax)
					{
	//					_comboCounter = 0;
						if(_comboCounter % comboMax == 0)
						{
							onPlayAnim(AnimLayer.SUPER_GOOD, newLevel);
						}
						else
						{
							onPlayAnim(AnimLayer.GOOD, newLevel);
						}
					}
					else
					{
						onPlayAnim(AnimLayer.GOOD, newLevel);
					}
				},
				{itemData:itemData, itemInfo:itemInfo});
			}
			else
			{
				gameSoundCtrl.playRightWrong(false);
				_comboCounter = 0;
				onPlayAnim(AnimLayer.BAD, onPlayAnimCompleteHand);
			}
		}
		
		private function onPlayAnimCompleteHand():void
		{
			LayerManager.getInstance().enableAllLayer();
		}
		
		public function update(delteTime:Number):void
		{
			onTimeCounter(_timeCounter, _timeTotal);
			
			_timeCounter -= delteTime * 0.001;
			if(_timeCounter <= 0)
			{
				_timeCounter = 0;
				doTimeup();
			}
		}
		
		private function doTimeup():void
		{
			pause();
			onTimeup(_level, recordBreaking);
		}
		
		//游戏中的暂停和恢复功能必须要使用add和remove,不然会出现暂停游戏并隐藏游戏,然后重新打开UpdateManager会自动执行
		public function resume():void
		{
			UpdateManager.getInstance().add(this);
		}
		
		public function pause():void
		{
			UpdateManager.getInstance().remove(this);
		}
		
		/**是否破纪录**/
		public function get recordBreaking():Boolean
		{
			if(_level > MainModel.getInstance().getMaxLevel())
				return true;
			
			return false;
		}
		
		//---------------工具函数-----------------
		private function getItemData(index:int, shapeArr:Array, colorArr:Array, textureArr:Array, itemsData:Vector.<ItemData>):ItemData
		{
			var shape:int = shapeArr[int(shapeArr.length * Math.random())];
			
			var bgColorIndex:int = int(colorArr.length * Math.random());
			var bgColor:uint = GameConfig.colors[colorArr[bgColorIndex]];
			var textureColorIndex:uint = MathUtil.getRandomNoOne(0, colorArr.length - 1, bgColorIndex);
			var textureColor:uint = GameConfig.colors[colorArr[textureColorIndex]];
			var texture:int = textureArr[int(textureArr.length * Math.random())];
			
			var itemData:ItemData = new ItemData(index,shape,bgColor,textureColor,texture);
			
			if(checkItemInItemArr(itemData, itemsData))
			{
				return getItemData(index, shapeArr, colorArr, textureArr, itemsData);
			}
			else
				return itemData;
		}
		private function checkItemInItemArr(itemData:ItemData, itemsData:Vector.<ItemData>):Boolean
		{
			if(!itemData)
				return true;
			
			for(var itemIndex:int = 0; itemIndex < itemsData.length; ++itemIndex)
			{
				var tempItemData:ItemData = itemsData[itemIndex];
				
				if(
					tempItemData.shape == itemData.shape &&
					tempItemData.bgColor == itemData.bgColor &&
					tempItemData.textureColor == itemData.textureColor &&
					tempItemData.texture == itemData.texture
				
				)
				{
					return true;
				}
			}
			return false;
		}
	}
}