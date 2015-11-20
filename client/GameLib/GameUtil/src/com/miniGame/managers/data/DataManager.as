package com.miniGame.managers.data
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	

	public class DataManager
	{
		private static var _instance:DataManager;
		public static function getInstance():DataManager
		{
			if(!_instance)
				_instance = new DataManager();
			
			return _instance;
		}
		
		private var _packageId:String;
		public function DataManager()
		{
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;  
			var ns:Namespace = appXml.namespace();  
			_packageId = appXml.ns::id;
		}
		
		public function writeObject(data:Object, url:String, onComplete:Function=null):void
		{
			var dataStr:String = JSON.stringify(data);
			var shareObject:SharedObject = SharedObject.getLocal(url); 
			shareObject.data.data = dataStr; 
			
			onComplete();
		}
		public function readObject(url:String, onComplete:Function=null):void
		{
			var shareObject:SharedObject = SharedObject.getLocal(url); 
			var data:String = shareObject.data.data; 
			var dataObject:Object;
			try
			{
				dataObject = data ? JSON.parse(data) : null
			}
			catch(e:Error)
			{
				return;
			}
			
			onComplete(dataObject);
		}
		
		public function writeData(data:String, url:String, onComplete:Function=null):void
		{
			var file:File = new File(File.applicationDirectory.resolvePath(url).nativePath);
			var fs:FileStream = new FileStream();
			
			fs.open(file,FileMode.WRITE);
			fs.position = 0;
			fs.writeUTFBytes(data);
			fs.close();
			if(onComplete) onComplete();
		}
		public function readData(url:String, onComplete:Function=null):void
		{
			var file:File = new File(File.applicationDirectory.resolvePath(url).nativePath);
			if(!file.exists)
			{
				onComplete(null);
				return;
			}
			
			var fs:FileStream = new FileStream();
			try
			{
				fs.openAsync(file,FileMode.READ);
			}
			catch(e:Error)
			{
				onComplete(null);
				return;
			}
			
			fs.addEventListener(Event.COMPLETE, fileStreamHandler);
			function fileStreamHandler(event:Event):void
			{
				fs.removeEventListener(Event.COMPLETE, fileStreamHandler);
				var data:String = "";
				try
				{
					fs.position = 0;
					data = fs.readUTF();
				}
				catch(e:Error)
				{
					
				}
				fs.close();
				if(onComplete) onComplete(data);
			}
		}
	}
}