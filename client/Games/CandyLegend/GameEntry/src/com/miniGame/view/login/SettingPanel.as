package com.miniGame.view.login
{
	import com.miniGame.controls.SoundButton;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.configs.ConfigManager;
	import com.miniGame.managers.debug.DebugManager;
	import com.miniGame.managers.response.ResponseManager;
	import com.miniGame.managers.system.SystemUtil;
	import com.miniGame.model.MainModel;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	
	import gs.TweenLite;
	import gs.TweenMax;
	
	public class SettingPanel extends Sprite
	{
		private var _main:DisplayObject;
		public var backBtn:SoundButton;
		
		private var _bobiSBtn:InteractiveObject;
		private var _bobiMBtn:InteractiveObject;
		private var _bobiLBtn:InteractiveObject;
		
		public function SettingPanel()
		{
			super();
		}
		
		public function create():void
		{
			var mainClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.LOGIN_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/select.swf", "select.Background");
			var backBtnClass:Class = AssetManager.getInstance().getAssetSwfClass(
				ConfigManager.LOGIN_VIEW,
				ConfigManager.getInstance().entryAssetsUrl + "/select.swf", "select.BackBtn");
			
			
			_main = new mainClass();
			addChild(_main);
			
			backBtn = new SoundButton(new backBtnClass());
			backBtn.x = ResponseManager.getInstance().getXRightMarginOfVisible(70);
			backBtn.y = ResponseManager.getInstance().getYTopMarginOfVisible(70);
			addChild(backBtn);
			
			_bobiSBtn = _main["bobiSBtn"];
			_bobiMBtn = _main["bobiMBtn"];
			_bobiLBtn = _main["bobiLBtn"];
			
			_bobiSBtn.addEventListener(MouseEvent.CLICK, bobiHandler);
			_bobiMBtn.addEventListener(MouseEvent.CLICK, bobiHandler);
			_bobiLBtn.addEventListener(MouseEvent.CLICK, bobiHandler);
		}
		public function dispose():void
		{
			if(backBtn)
			{
				backBtn.dispose();
			}
		}
		
		private var _bobiHash:Object = 
			{
				android:
				{
					l:"com.bobi.BobiPhoneL",
					m:"com.bobi.BobiPhoneM",
					s:"com.bobi.BobiPhoneS",
					
					l_url:"http://openbox.mobilem.360.cn/index/d/sid/2717389",
					m_url:"http://openbox.mobilem.360.cn/index/d/sid/2798385",
					s_url:"http://openbox.mobilem.360.cn/index/d/sid/2798387"
				},
				
				ipad:
				{
					l:"com.1bobi.bobibrainl",
					m:"com.1bobi.bobibrainm",
					s:"com.1bobi.bobibrains",
					
					l_l:"yes3d.1bobi.Lite",
					m_l:"com.1bobi.bobimLite",
					s_l:"com.1bobi.bobisLite",
					
					l_url:"https://itunes.apple.com/cn/app/bo-bi-quan-nao-da-ban-ru-men/id898171449?l=zh&ls=1&mt=8",
					m_url:"https://itunes.apple.com/cn/app/bo-bi-quan-nao-zhong-ban-ru/id930812258?l=zh&ls=1&mt=8",
					s_url:"https://itunes.apple.com/cn/app/bo-bi-quan-nao-xiao-ban-ru/id930812629?l=zh&ls=1&mt=8"
				},
				
				iphone:
				{
					l:"com.1bobi.BobiPhoneLF",
					m:"com.1bobi.BobiPhoneMF",
					s:"com.1bobi.BobiPhoneSF",
					
					l_l:"com.1bobi.BobiPhoneL",
					m_l:"com.1bobi.BobiPhoneM",
					s_l:"com.1bobi.BobiPhoneS",
					
					l_url:"https://itunes.apple.com/cn/app/bo-bi-quan-nao-da-ban-ru-men/id935194433?l=zh&ls=1&mt=8",
					m_url:"https://itunes.apple.com/cn/app/bo-bi-quan-nao-zhong-ban-ru/id935194610?l=zh&ls=1&mt=8",
					s_url:"https://itunes.apple.com/cn/app/bo-bi-quan-nao-xiao-ban-ru/id935194584?l=zh&ls=1&mt=8"
				}
			};
		private var _targetBobiKey:String;
		private var _delayCallToUrl:TweenMax;
		private var _delayCallToUrl2:TweenMax;
		
		private function bobiHandler(event:MouseEvent):void
		{
			if(_delayCallToUrl)
			{
				DebugManager.getInstance().warn("SettingPanel 正在打开中");
				return;
			}
			
			
			var bobiBtn:InteractiveObject = event.currentTarget as InteractiveObject;
			
			if(bobiBtn == _bobiSBtn)
			{
				_targetBobiKey = "s";
			}
			else if(bobiBtn == _bobiMBtn)
			{
				_targetBobiKey = "m";
			}
			else if(bobiBtn == _bobiLBtn)
			{
				_targetBobiKey = "l";
			}
			
			//统计
			MainModel.getInstance().addBobiClick(_targetBobiKey);
			MainModel.getInstance().sendData();
			
			ready();
			navigateToBobi();
		
			var deactivateTime:Number;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activateHandler);
			function activateHandler(event:Event):void
			{
				NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, activateHandler);
				
				//小于1秒，非跳转软件成功，  跳转软件 失败 在 某些设备也可能导致失效事件
				var interval:Number = flash.utils.getTimer() - deactivateTime;
				if(interval < 1000)
				{
					ready();
				}
			}
			
			function ready():void
			{
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivateHandler);
				_delayCallToUrl = TweenMax.delayedCall(2, navigateToBobiUrl);
				_delayCallToUrl2 = TweenMax.delayedCall(4, navigateToBobiUrl2);
			}
			function clear():void
			{
				NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, deactivateHandler);
				TweenLite.removeTween(_delayCallToUrl, true);
				TweenLite.removeTween(_delayCallToUrl2, true);
				_delayCallToUrl = null;
				_delayCallToUrl2 = null;
			}
			function deactivateHandler(event:Event):void
			{
				clear();
				deactivateTime = flash.utils.getTimer();
			}
		
			function navigateToBobi():void
			{
				var url:String;
				if(SystemUtil.isAndroid())
				{
					url = (_bobiHash["android"][_targetBobiKey] as String).split(".").join("") + "://me=cenfee&you=cenfee";
				}
				else
				{
					if(SystemUtil.isIPad())
					{
						url = (_bobiHash["ipad"][_targetBobiKey] as String).split(".").join("") + "://me=cenfee&you=cenfee";
					}
					else
					{
						url = (_bobiHash["iphone"][_targetBobiKey] as String).split(".").join("") + "://me=cenfee&you=cenfee";
					}
					
				}
				//url = "comcenfeetest1://me=cenfee&you=cenfee"
				navigateToURL(new URLRequest(url));
			}
			
			function navigateToBobiUrl():void
			{
				var url:String;
				if(SystemUtil.isAndroid())
				{
					url = _bobiHash["android"][_targetBobiKey + "_url"];
				}
				else
				{
					if(SystemUtil.isIPad())
					{
						url = (_bobiHash["ipad"][_targetBobiKey + "_l"] as String).split(".").join("") + "://me=cenfee&you=cenfee";
					}
					else
					{
						url = (_bobiHash["iphone"][_targetBobiKey + "_l"] as String).split(".").join("") + "://me=cenfee&you=cenfee";
					}
				}
				
				//url = "comcenfeetest1://me=cenfee&you=cenfee"
				navigateToURL(new URLRequest(url));
			}
			
			function navigateToBobiUrl2():void
			{
				var url:String;
				if(SystemUtil.isAndroid())
				{
					
				}
				else
				{
					if(SystemUtil.isIPad())
					{
						url = _bobiHash["ipad"][_targetBobiKey + "_url"];
					}
					else
					{
						url = _bobiHash["iphone"][_targetBobiKey + "_url"];
					}
				}
				
				navigateToURL(new URLRequest(url));
				
				clear();
			}
		}
	}
}