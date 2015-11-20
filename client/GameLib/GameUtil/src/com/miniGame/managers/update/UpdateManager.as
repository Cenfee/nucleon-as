package com.miniGame.managers.update
{
	import com.miniGame.managers.debug.DebugManager;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	

	public class UpdateManager
	{
		private static var _instance:UpdateManager;
		public static function getInstance():UpdateManager
		{
			if(!_instance)
				_instance = new UpdateManager();
			
			return _instance;
		}
		
		public function UpdateManager()
		{
			
		}
		
		private var _lastTime:Number;
		private var _stage:Stage;
		private var _objects:Array=[];
		
		public function init(stage:Stage):void
		{
			_stage = stage;
		}
		public function add(object:IUpdate):void
		{
			var index:int = _objects.indexOf(object);
			if(index > -1)
			{
				DebugManager.getInstance().warn("UpdateManager:", object, "已加入");
				return;
			}
			
			_objects.push(object);
			if(_objects.length > 0)
			{
				_lastTime = flash.utils.getTimer();
				_stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		public function remove(object:IUpdate):void
		{
			var index:int = _objects.indexOf(object);
			if(index < 0)
			{
				DebugManager.getInstance().warn("UpdateManager:", object, "找不到");
				return;
			}
			_objects.splice(index, 1);
			if(_objects.length <= 0)
			{
				_stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		private function enterFrameHandler(event:Event):void
		{
			for(var i:int = 0; i < _objects.length; ++i)
			{
				(_objects[i] as IUpdate).update(flash.utils.getTimer() - _lastTime);
			}
			
			_lastTime = flash.utils.getTimer();
		}
		
		public function resume():void
		{
			_lastTime = flash.utils.getTimer();
			_stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		public function pause():void
		{
			_stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
	}
}