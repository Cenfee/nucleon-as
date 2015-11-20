package com.miniGame.view.game.ctrl
{
	import com.miniGame.managers.math.MathUtil;
	import com.miniGame.managers.sound.SoundManager;

	public class GameSoundCtrl
	{
		private var FILE_EXTENSION:String = ".mp3";
		private var SOUND_ROOT:String = "assets/sounds/";
		
		private var bg_url:String = SOUND_ROOT + "music_0";
		private var button_url:String = SOUND_ROOT + "button" + FILE_EXTENSION;
		
		private var right_bobi_url:String = SOUND_ROOT + "right_01_bobi" + FILE_EXTENSION;
		private var wrong_bobi_url:String = SOUND_ROOT + "wrong_01_bobi" + FILE_EXTENSION;
		private var right_url:String = SOUND_ROOT + "right" + FILE_EXTENSION;
		private var wrong_url:String = SOUND_ROOT + "wrong" + FILE_EXTENSION;
		private var combo_url:String = SOUND_ROOT + "combo_0";
		
		private var record_breaking_url:String = SOUND_ROOT + "record_breaking" + FILE_EXTENSION;
		private var recordBreaking_url:String = SOUND_ROOT + "record_breaking_bobi_0";
		private var recordNormal_url:String = SOUND_ROOT + "record_normal_bobi_0";
		
		private var timesup_url:String = SOUND_ROOT + "timesup" + FILE_EXTENSION;
		/**盘子进来的声音**/
		private var plateChange_url:String = SOUND_ROOT + "plate_change" + FILE_EXTENSION;
		/**糖果出现时的声音**/
		private var sugarAppear_url:String = SOUND_ROOT + "sugar_appear" + FILE_EXTENSION;
		/**321倒数**/
		private var countdown_url:String = SOUND_ROOT + "countdown" + FILE_EXTENSION;
		
		public function GameSoundCtrl()
		{
			
		}
		
		public function playButtonSound():void
		{
			SoundManager.getInstance().stream(button_url);
		}
		
		public function playRightWrong(isRight:Boolean, comboNum:int = 1, comboMax:int = 5):void
		{
			if(isRight)
			{
				if(comboNum == 1)
				{
					SoundManager.getInstance().stream(right_url);
				}
				else
				{
					if(comboNum >= comboMax)
					{
						if(comboNum % comboMax == 0)
							SoundManager.getInstance().stream(right_bobi_url);
						
						comboNum = comboMax;
					}
					SoundManager.getInstance().stream(combo_url + comboNum + FILE_EXTENSION);
				}
			}
			else
			{
				if(Math.round(Math.random()) * 10 > 5)
				{
					SoundManager.getInstance().stream(wrong_bobi_url);
				}
				else
				{
					SoundManager.getInstance().stream(wrong_url);
				}
			}
		}
		
		public function playComboSound(comboNum:int = 1):void
		{
			comboNum = (comboNum >= 5 ? 5 : comboNum);
			SoundManager.getInstance().stream(combo_url + comboNum + FILE_EXTENSION);
		}
		
		public function playBgSound(isChange:Boolean = false, id:int = -1):void
		{
			var index:int;
			var url:String;
			
			if(isChange)
			{
				index = 22;
			}
			else
			{
				index = 2;
			}
			if(id != -1)
				index = id;
			
			url = bg_url + index + FILE_EXTENSION;
			SoundManager.getInstance().stopCategorySounds(SoundManager.MUSIC_MIXER_CATEGORY);
			SoundManager.getInstance().stream(url, SoundManager.MUSIC_MIXER_CATEGORY, 0, int.MAX_VALUE);
		}
		
		public function playGameOverSound(isRecordBreaking:Boolean):void
		{
			var url:String;
			var index:int = MathUtil.getExtentRandomInt(1, 3);
			
			if(isRecordBreaking)
			{
				url = recordBreaking_url + index + FILE_EXTENSION;
			}
			else
			{
				url = recordNormal_url + index + FILE_EXTENSION;
			}
			
			playBgSound(false, 3);
			//暂时不要这个
			SoundManager.getInstance().stream(record_breaking_url, SoundManager.MUSIC_MIXER_CATEGORY);
//			SoundManager.getInstance().stream(url, SoundManager.MUSIC_MIXER_CATEGORY);
		}
		
		public function playTimesupSound():void
		{
			SoundManager.getInstance().stopCategorySounds(SoundManager.MUSIC_MIXER_CATEGORY);
			SoundManager.getInstance().stream(timesup_url);
		}
		
		public function playPlateChangeSound():void
		{
			SoundManager.getInstance().stream(plateChange_url);
		}
		
		public function playSugarAppearSound():void
		{
			SoundManager.getInstance().stream(sugarAppear_url);
		}
		
		public function playCountdownSound():void
		{
			SoundManager.getInstance().stream(countdown_url);
		}
	}
}