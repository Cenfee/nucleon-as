package com.miniGame.managers.view
{
	public interface IView
	{
		function show(data:Object=null):void;
		function hide():void;
		
		function create(date:Object=null):void;
		function dispose():void;
	}
}