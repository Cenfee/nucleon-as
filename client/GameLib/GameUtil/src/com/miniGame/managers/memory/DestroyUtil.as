package com.miniGame.managers.memory
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.media.Sound;
	import flash.net.URLLoader;

	public class DestroyUtil
	{
		public function DestroyUtil()
		{
		}
		
		public static function destroySound(value:Sound):void
		{
			value.close();
		}
		
		public static function destroyBitmapData(value:BitmapData):void
		{
			value.dispose();
		}
		
		public static function clearLoader(loader:Loader):void
		{
			loader.stopAllMovieClips();
			loader.unload();
			loader.unloadAndStop(true);
		}
		public static function destroyLoader(loader:Loader):void
		{
			clearLoader(loader);
		}
		
		public static function clearUrlLoader(urlLoader:URLLoader):void
		{
			urlLoader.data = null;
		}
		public static function destroyUrlLoader(urlLoader:URLLoader):void
		{
			clearUrlLoader(urlLoader);
		}
	}
}