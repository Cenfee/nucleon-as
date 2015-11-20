package com.miniGame.managers.http
{
	import com.miniGame.managers.debug.DebugManager;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	

	public class HttpManager
	{
		
		private static var _instance:HttpManager;
		public static function getInstance():HttpManager
		{
			if(!_instance)
				_instance = new HttpManager();
			
			return _instance;
		}
		
		public function HttpManager()
		{
		}
		
		public function send(url:String, data:Object, onCallback:Function=null, type:String=URLRequestMethod.POST):void
		{
			var requestVars:URLVariables = new URLVariables();
			requestVars.data = data;
			
			var request:URLRequest = new URLRequest();
			request.url = url;
			request.method = type;
			request.data = requestVars;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				loader.load(request);
			}
			catch (error:Error)
			{
				DebugManager.getInstance().warn("Unable to load URL"); 
			}
			
			function loaderCompleteHandler(e:Event):void
			{
				var variables:URLVariables = new URLVariables( e.target.data );
				if(onCallback)
					onCallback(variables.data);
			}
			function httpStatusHandler (e:Event):void
			{
				DebugManager.getInstance().warn("HttpManager:", "httpStatusHandler" + e);
			}
			function securityErrorHandler (e:Event):void
			{
				DebugManager.getInstance().warn("HttpManager:", "securityErrorHandler:" + e);
			}
			function ioErrorHandler(e:Event):void
			{
				DebugManager.getInstance().warn("HttpManager:", "ioErrorHandler: " + e);
			}

		}
	}
}