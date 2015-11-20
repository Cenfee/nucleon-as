package com.miniGame.managers.math
{
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		public static function getRandomNoOne(min:int, max:int, noOne:int):int
		{
			var target:int = noOne;
			
			while(target == noOne)
			{
				target = min + ( max - min + 1) * Math.random();
			}
			
			return target;
		}
		
		/**
		 * 从区间中随机获取一个整数,范围[start, end]
		 * @param start
		 * @param end
		 * @return
		 * 
		 */		
		public static function getExtentRandomInt(start:int, end:int):int
		{
			return Math.floor(Math.random() * end + start);
		}
	}
}