package
{
	import com.miniGame.view.game.GameView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class CandyLegend extends Sprite
	{
		public function CandyLegend()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			new GameStarter(GameView, "entryAssets", [
			
				"assets/texture1.swf",
				"assets/texture2.swf",
				"assets/countdown.swf"
			], this);
		}
	}
}