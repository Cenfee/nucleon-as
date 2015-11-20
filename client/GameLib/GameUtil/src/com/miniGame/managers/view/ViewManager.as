package com.miniGame.managers.view
{
	import com.miniGame.managers.action.ActionManager;
	import com.miniGame.managers.asset.AssetManager;
	import com.miniGame.managers.debug.DebugManager;
	

	public class ViewManager
	{
		private static var _instance:ViewManager;
		public static function getInstance():ViewManager
		{
			if(!_instance)
				_instance = new ViewManager();
			
			return _instance;
		}
		
		public function ViewManager()
		{
		}
		
		private var _viewInfo:Object = {};
		
		private var _viewCache:Object = {};
		
		
		
		public function registerViewInfo(name:String, viewClass:Class, assets:Array):void
		{
			_viewInfo[name] = {"classObject": viewClass, "assets":assets};
		}
		
		private function cacheView(name:String):IView
		{
			if(_viewCache[name]) return _viewCache[name];
			
			var classObject:Class = _viewInfo[name].classObject;
			_viewCache[name] = new classObject();
			return _viewCache[name];
		}
		
		public function showView(name:String, complete:Function=null, data:Object=null):IView
		{
			if(!_viewInfo[name])
			{
				DebugManager.getInstance().warn(name + "没有注册");
			}
			
			var cached:Boolean = _viewCache[name] ? true : false;
			var view:IView = cacheView(name);
			if(!cached)
				view.create(data);
			
			AssetManager.getInstance().loadViewAsset(name, _viewInfo[name]["assets"], null, 
				function():void
				{
					
					view.show(data);
					
					if(complete)
						complete(view);
				});
			
			return view;
 		}
		
		public function hideView(name:String, dispose:Boolean=true, unloadAssets:Boolean=true):IView
		{
			var view:IView = _viewCache[name];
			if(!view)
			{
				DebugManager.getInstance().log(name,"不在ViewManager缓存中");
				return null;
			}
			
			view.hide();
			
			if(dispose)
			{
				view.dispose();
				
				ActionManager.getInstance().removeViewAction(name);
				
				if(unloadAssets)
					AssetManager.getInstance().unloadViewAssets(name);
				
				delete _viewCache[name];
			}
			
			//LayerManager.getInstance().gameLayer.removeChild(view as Sprite);
			
			return view;
		}
		
	}
}