package com.miniGame.managers.configs
{
	public class GameConfig
	{
		/**
		 * 数组的第一个元素是占位符,无需理会
		 * 1.红 #f97a41
		 * 2.黄 #f7cb4b
		 * 3.蓝 #30a1dd
		 * 4.绿 #74bd4b
		 * 5.白 #9654b6
		 */		
		public static var colors:Vector.<uint> = Vector.<uint>([0xffffff, 0xf97a41, 0xf7cb4b, 0x30a1dd, 0x74bd4b, 0x9654b6]);
		public static var totalTime:Number = 121;//51
		/**combo多少次触发特殊效果**/
		public static var comboMax:int = 5;
		
		public static var itemGapX:Number = 30;
		public static var itemGapY:Number = 30;
		
		
		public function GameConfig()
		{
		}
	}
}