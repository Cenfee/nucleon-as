package com.miniGame.managers.file
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	

	public class FileManager
	{
		private static var _instance:FileManager;
		public static function getInstance():FileManager
		{
			if(!_instance)
				_instance = new FileManager();
			
			return _instance;
		}
		
		public function FileManager()
		{
		}
		
		public function writeObject(data:Object, url:String, onComplete:Function=null):void
		{
			var dataStr:String = JSON.stringify(data);
			writeUtf8(dataStr, url, onComplete);
			
		}
		public function readObject(url:String, onComplete:Function=null):void
		{
			readUtf8(url, function(data:String):void
			{
				try
				{
					onComplete(data ? JSON.parse(data) : null);
				}
				catch(e:Error)
				{
					onComplete(null);
					return;
				}
			});
		}
		
		public function writeUtf8(data:String, url:String, onComplete:Function=null):void
		{
			var file:File = new File(File.applicationDirectory.resolvePath(url).nativePath);
			var fs:FileStream = new FileStream();
			
			fs.open(file,FileMode.WRITE);
			fs.position = 0;
			fs.writeUTFBytes(data);
			fs.close();
			if(onComplete) onComplete();
		}
		public function readUtf8(url:String, onComplete:Function=null):void
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