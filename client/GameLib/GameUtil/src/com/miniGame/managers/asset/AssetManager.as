package com.miniGame.managers.asset
{
	import com.miniGame.managers.debug.DebugManager;
	import com.miniGame.managers.memory.DestroyUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class AssetManager
	{
		private static var _instance:AssetManager;
		public static function getInstance():AssetManager
		{
			if(!_instance)
				_instance = new AssetManager();
			
			return _instance;
		}
		
		public static const GLOBLE:String = "globle";
		
		private var _viewAssets:Object = {};
		
		private var _assetsLib:Object={};
		
		
		
		public function AssetManager()
		{
		}
		
		public function loadViewAsset(viewName:String, res:Array, progress:Function, complete:Function, isDisplay:Boolean=false):void
		{
			if(!_viewAssets[viewName])
				_viewAssets[viewName] = [];
			
			_viewAssets[viewName] = _viewAssets[viewName].concat(res);
			
			if(!_assetsLib[viewName])
				_assetsLib[viewName] = {};
			
			var storager:Object = _assetsLib[viewName];
			
			if(isDisplay)
				loadWidthDisplay(res, storager, progress, complete);
			else
				load(res, storager, progress, complete);
		}
		
		public function unloadViewAssets(viewName:String):void
		{
			if (!_viewAssets[viewName])
			{
				DebugManager.getInstance().warn("AssetManager:unloadViewAssets " + "没有" + viewName);
				return;
			}
			
			var moduleAsset:Array = _viewAssets[viewName];
			var storager:Object = _assetsLib[viewName];
			unload(moduleAsset, storager);
			
			delete _viewAssets[viewName];
			delete _assetsLib[viewName];
		}
		
		private function loadWidthDisplay(assets:Array, storager:Object, onProgress:Function=null, onComplete:Function=null):void
		{
			load(assets, storager, onProgress, onComplete);
		}
		
		private function load(assets:Array, storager:Object, onProgress:Function=null, onComplete:Function=null):void
		{
			for(var assetIndex:int = 0; assetIndex < assets.length; ++assetIndex)
			{
				loadOne(assets[assetIndex], storager, onOneComplete);
			}
			
			var counter:int;
			function onOneComplete(url:String):void
			{
				++counter;
				
				if(onProgress)
					onProgress(counter / assets.length);
				
				if(counter >= assets.length)
				{
					if(onComplete)
						onComplete();
				}
			}
		}
		
		private function unload(assets:Array, storager:Object):void
		{
			for(var assetIndex:int = 0; assetIndex < assets.length; ++assetIndex)
			{
				unloadOne(assets[assetIndex], storager);
			}
		}
		
		private function loadOne(url:String, storager:Object, onComplete:Function):void
		{
			if(storager[url])
			{
				onComplete(url);
				return;
			}
				
			var extension:String = url.slice(url.lastIndexOf(".") + 1, url.length);
			
			var loader:Loader;
			var urlLoader:URLLoader;
			if(extension == "png")
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function imageCompleteHandler(e:Event):void
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageCompleteHandler);
					storager[url] = (loader.content as Bitmap).bitmapData;
					
					onComplete(url);
				});
				loader.load(new URLRequest(url));
			}
			else if(extension == "swf")
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function swfCompleteHandler(e:Event):void
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfCompleteHandler);
					
					storager[url] = loader;
					
					onComplete(url);
				});
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.applicationDomain = ApplicationDomain.currentDomain;
				loader.load(new URLRequest(url), loaderContext);
			}
			else if(extension == "mp3")
			{
				var sound:Sound = new Sound( );
				sound.addEventListener(Event.COMPLETE, function soundCompleteHandler(e:Event):void
				{
					sound.removeEventListener(Event.COMPLETE, soundCompleteHandler);
					
					storager[url] = sound;
					
					onComplete(url);
				});
				sound.load(new URLRequest(url));
			}
			else if(extension == "xml")
			{
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, function xmlCompleteHandler(e:Event):void
				{
					urlLoader.removeEventListener(Event.COMPLETE, xmlCompleteHandler);
					
					storager[url] = XML(urlLoader.data);
					
					onComplete(url);
				});
				urlLoader.load(new URLRequest(url));
			}
			else if(extension == "json")
			{
				urlLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, function xmlCompleteHandler(e:Event):void
				{
					urlLoader.removeEventListener(Event.COMPLETE, xmlCompleteHandler);
					
					storager[url] = JSON.parse(urlLoader.data);
					
					onComplete(url);
				});
				urlLoader.load(new URLRequest(url));
			}
		}
		
		private function unloadOne(url:String, storager:Object):void
		{
			if(!storager[url])
			{
				return;
			}

			var extension:String = url.slice(url.lastIndexOf(".") + 1, url.length);
			
			if(extension == "png")
			{
				DestroyUtil.destroyBitmapData(storager[url]);
			}
			else if(extension == "swf")
			{
				DestroyUtil.destroyLoader(storager[url]);
			}
			else if(extension == "mp3")
			{
				DestroyUtil.destroySound(storager[url]);
			}
			else if(extension == "xml")
			{
				
			}

			delete storager[url];
		}
		
		public function getAsset(viewName:String, url:String):*
		{
			var storager:Object = _assetsLib[viewName];
			return storager[url];
		}
		
		public function getAssetSwfClass(viewName:String, swfUrl:String, className:String):Class
		{
			var storager:Object = _assetsLib[viewName];
			
			var loader:Loader = storager[swfUrl];
			return loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
		}
	}
}