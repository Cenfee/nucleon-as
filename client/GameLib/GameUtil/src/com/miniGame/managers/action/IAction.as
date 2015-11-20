package com.miniGame.managers.action
{
	public interface IAction
	{
		function create(target:Object, data:Object=null):void;
		function dispose():void;
		
		function resume():void;
		function pause():void;
	}
}