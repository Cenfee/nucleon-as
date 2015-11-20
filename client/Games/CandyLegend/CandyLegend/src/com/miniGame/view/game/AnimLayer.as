package com.miniGame.view.game
{
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.popup.PopupManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.view.game.game.QuestionItem;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import gs.TweenMax;
	
	public class AnimLayer extends Sprite
	{
		public static const BAD:String = "0";
		public static const GOOD:String = "1";
		public static const ASK:String = "2";
		public static const SUPER_GOOD:String = "3";
		public static const COUNTDOWN:String = "4";
		public static const ITEM_ANIM:String = "5";
		
		
		private var _badAnim:MovieClip;
		private var _goodAnim:MovieClip;
		private var _askAnim:MovieClip;
		private var _superGoodAnim:MovieClip;
		private var _countdownAnim:MovieClip;
		
		private var onPlayAnimComplete:Function;
		
		/**当前播放的动作**/
		private var _curAnim:MovieClip;
		/**问题容器**/
		private var _questionContainer:DisplayObjectContainer;
		/**问题实例**/
		private var _questionItem:QuestionItem;
		/**用于答对后曲线动画的Item实例**/
		private var _itemAnim:QuestionItem = new QuestionItem();;
		
		private var data:Object;

		
		public function AnimLayer()
		{
			super();
		}
		
		public function create():void
		{
			playAskAnim();
			showQuestion();
		}
		
		public function dispose():void
		{
			TweenMax.killTweensOf(_itemAnim, true);
			_questionItem.dispose();
			
			data = null;
			_curAnim = null;
			_itemAnim = null;
			onPlayAnimComplete = null;
		}
		
		public function updateQuestion(answerData:Object):void
		{
			_questionItem.update(answerData["shape"], answerData["bgColor"], answerData["textureColor"], answerData["texture"]);
			_questionItem.data = answerData;
		}
		
		public function playAnim(state:String, onPlayAnimComplete:Function, data:Object):void
		{
			this.data = data;
			this.onPlayAnimComplete = onPlayAnimComplete;
			
			switch(state)
			{
				case BAD:
				{
					playBadAnim();
					break;
				}
				case GOOD:
				{
					playGoodAnim();
					break;
				}
				case ASK:
				{
					playAskAnim();
					break;
				}
				case SUPER_GOOD:
				{
					playSuperGoodAnim();
					break;
				}
				case COUNTDOWN:
				{
					playCountdownAnim();
					break;
				}
				case ITEM_ANIM:
				{
					playItemAnim();
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		/**答对后Item的曲线动画**/
		public function playItemAnim():void
		{
			var itemData:Object = data.itemData;
			var itemInfo:Object = data.itemInfo;
			
			_itemAnim.update(itemData.shape, itemData.bgColor, itemData.textureColor, itemData.texture);
			_itemAnim.data = itemData;
			this.addChild(_itemAnim);
			_itemAnim.x = itemInfo.x
			_itemAnim.y = itemInfo.y;
			
			var endPos:Point = new Point(_questionContainer.x + _questionContainer.width * .5, 
										 _questionContainer.y + _questionContainer.height * .5);
			var controlX:Number = endPos.x + Math.abs(endPos.x - itemInfo.x) * .5;
			var controlY:Number = endPos.y + Math.abs(endPos.y - itemInfo.y) * .5 - 150;
			TweenMax.to(_itemAnim, 0.4, 
						{bezierThrough:[{x:controlX, y:controlY, scaleX:0.87, scaleY:0.87}, 
							            {x:endPos.x, y:endPos.y, scaleX:0.75, scaleY:0.75}],
						 onComplete:onItemAnimTweenCompleteHand,
						 onCompleteParams:[_itemAnim]});
		}
		
		public function playCountdownAnim():void
		{
			if(!_countdownAnim)
			{
				var AnimClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					"assets/countdown.swf", 
					"countdown.countdownAnim"
				);
				
				_countdownAnim = new AnimClass();
			}
			PopupManager.getInstance().add(_countdownAnim,
										   ResponseManager.getInstance().getXLeftPercentOfVisible(0.5),
										   ResponseManager.getInstance().getYTopPercentOfVisible(0.5));
			
			_curAnim = _countdownAnim;
			_countdownAnim.play();
			_countdownAnim.addFrameScript(_curAnim.totalFrames - 1, animPlayCompleteHandler);
		}
		
		public function playBadAnim():void
		{
			removeAllAnim();
			
			if(!_badAnim)
			{
				var AnimClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					ConfigManager.getInstance().entryAssetsUrl + "/game.swf", 
					"game.BadAnim"
					);
				
				_badAnim = new AnimClass();
				_badAnim.x = ResponseManager.getInstance().getXLeftMarginOfVisible(150);
				_badAnim.y = ResponseManager.getInstance().getYBottomMarginOfVisible(180);
			}
			
			addChildAt(_badAnim, 0);
			_curAnim = _badAnim;
			_badAnim.play();
			_curAnim.addFrameScript(_curAnim.totalFrames - 1, animPlayCompleteHandler);
		}
		public function playGoodAnim():void
		{
			removeAllAnim();
			
			if(!_goodAnim)
			{
				var AnimClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					ConfigManager.getInstance().entryAssetsUrl + "/game.swf", 
					"game.GoodAnim");
				
				_goodAnim = new AnimClass();
				_goodAnim.x = ResponseManager.getInstance().getXLeftMarginOfVisible(150);
				_goodAnim.y = ResponseManager.getInstance().getYBottomMarginOfVisible(180);
			}
			
			addChildAt(_goodAnim, 0);
			_curAnim = _goodAnim;
			_goodAnim.play();
			_curAnim.addFrameScript(_curAnim.totalFrames - 1, animPlayCompleteHandler);
		}
		public function playAskAnim():void
		{
			removeAllAnim();
			
			if(!_askAnim)
			{
				var AnimClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					ConfigManager.getInstance().entryAssetsUrl + "/game.swf", 
					"game.AskAnim");
				
				_askAnim = new AnimClass();
				_askAnim.x = ResponseManager.getInstance().getXLeftMarginOfVisible(150);//160
				_askAnim.y = ResponseManager.getInstance().getYBottomMarginOfVisible(180);//135
			}
			
			if(_questionContainer)
			{
				_questionContainer.visible = true;
			}
			
			addChildAt(_askAnim, 0);
			_curAnim = _askAnim;
			_askAnim.play();
		}
		public function playSuperGoodAnim():void
		{
			removeAllAnim();
			
			if(!_superGoodAnim)
			{
				var AnimClass:Class = AssetManager.getInstance().getAssetSwfClass(
					ConfigManager.GAME_VIEW,
					ConfigManager.getInstance().entryAssetsUrl + "/game.swf", 
					"game.SuperGoodAnim");
				
				_superGoodAnim = new AnimClass();
				_superGoodAnim.scaleX = _superGoodAnim.scaleY = 2.3;
			}
			_questionContainer.visible = false;			
			PopupManager.getInstance().add(_superGoodAnim,
										   ResponseManager.getInstance().getXLeftPercentOfVisible(0.5),
										   ResponseManager.getInstance().getYBottomMarginOfVisible(115));
			
			_curAnim = _superGoodAnim;
			_superGoodAnim.play();
			_curAnim.addFrameScript(_curAnim.totalFrames - 1, animPlayCompleteHandler);
		}
		
		public function removeAllAnim():void
		{
			if(_curAnim)
				_curAnim.addFrameScript(_curAnim.totalFrames - 1, null);
			
			if(_countdownAnim) 
			{
				_countdownAnim.stop();
				if(_countdownAnim.parent)
					PopupManager.getInstance().remove(_countdownAnim);
			}
			
			if(_badAnim) 
			{
				_badAnim.stop();
				if(_badAnim.parent)
					removeChild(_badAnim);
			}
			
			if(_goodAnim) 
			{
				_goodAnim.stop();
				if(_goodAnim.parent)
					removeChild(_goodAnim);
			}
			
			if(_askAnim) 
			{
				_askAnim.stop();
				if(_askAnim.parent)
					removeChild(_askAnim);
			}
			
			if(_superGoodAnim) 
			{
				_superGoodAnim.stop();
				if(_superGoodAnim.parent)
					PopupManager.getInstance().remove(_superGoodAnim);
			}
		}
		
		/**动画播放完**/
		private function animPlayCompleteHandler():void
		{
			_curAnim.addFrameScript(_curAnim.totalFrames - 1, null);
			_curAnim.stop();
			
			if(onPlayAnimComplete != null)
			{
				onPlayAnimComplete();
				onPlayAnimComplete = null;
			}
			playAskAnim();
		}
		
		/**答对后的曲线TweenMax动画播放完**/
		private function onItemAnimTweenCompleteHand(item:QuestionItem):void
		{
			if(_itemAnim.parent)
			{
				this.removeChild(_itemAnim);
			}
			
			if(onPlayAnimComplete != null)
			{
				onPlayAnimComplete();
			}
		}
		
		private function showQuestion():void
		{
			var questionClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.GAME_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/game.swf", "game.Question");
			_questionContainer = new questionClass();
			_questionContainer.x = ResponseManager.getInstance().getXLeftMarginOfVisible(100);
			_questionContainer.y = ResponseManager.getInstance().getYBottomMarginOfVisible(500);
			addChild(_questionContainer);
			
			_questionItem = new QuestionItem();
			_questionItem.mouseEnabled = _questionItem.mouseChildren = false;
			_questionItem.scaleX = _questionItem.scaleY = 0.75;
			_questionItem.x = _questionContainer.width * .5;
			_questionItem.y = _questionContainer.height * .5;
			_questionContainer.addChild(_questionItem);
		}
	}
}