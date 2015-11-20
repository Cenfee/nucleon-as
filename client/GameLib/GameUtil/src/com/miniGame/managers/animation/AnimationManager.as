
package com.miniGame.managers.animation
{
	

	public class AnimationManager
	{
		private static var _instance:AnimationManager;
		public static function getInstance():AnimationManager
		{
			if(!_instance)
				_instance = new AnimationManager();
			
			return _instance;
		}
		
		public function AnimationManager()
		{
		}
	}
}