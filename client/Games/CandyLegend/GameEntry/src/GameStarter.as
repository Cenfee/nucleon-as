package    
{    
import com.miniGame.ApplicationFacade;

import flash.display.Sprite;    
  
public class GameStarter    
{    
public function GameStarter(gameClass:Class, entryAssetsUrl:String, assets:Array, container:Sprite)    
{    
var facade:ApplicationFacade = new ApplicationFacade();    
facade.start(gameClass, entryAssetsUrl, assets, container);    
}    
}    
}    
