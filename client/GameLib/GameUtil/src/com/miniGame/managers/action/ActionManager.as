package com.miniGame.managers.action
{
	
	

	public class ActionManager
	{
		private static var _instance:ActionManager;
		public static function getInstance():ActionManager
		{
			if(!_instance)
				_instance = new ActionManager();
			
			return _instance;
		}
		
		public function ActionManager()
		{
		}
		private var _viewActions:Object={};
		
		public function addViewAction(viewName:String, actionName:String, actionClass:Class):void
		{
			if(!_viewActions[viewName])
			{
				_viewActions[viewName] = {};
			}
			
			if(!_viewActions[viewName][actionName])
			{
				_viewActions[viewName][actionName] = actionClass;
			}
		}
		public function removeViewAction(viewName:String):void
		{
			delete _viewActions[viewName];
		}
		public function createViewAction(viewName:String, actionName:String, target:Object, data:Object=null):IAction
		{
			var actionClass:Class = _viewActions[viewName][actionName];
			
			var action:IAction = new ScaleAction();
			action.create(target, data);
			
			return action;
		}
		
		
		public function scaleObject(target:Object,  scaleTo:Number, data:Object=null):IAction
		{
			var scaleAction:ScaleAction = new ScaleAction();
			scaleAction.scaleTo = scaleTo;
			scaleAction.create(target);
			
			return scaleAction;
		}
	}
}