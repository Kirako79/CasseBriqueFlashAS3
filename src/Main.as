package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import Joueur;
	
	/**
	 * ...
	 * @author Kirako79 & Kribouille 
	 */
	public class Main extends Sprite 
	{
		private var leJoueur:Joueur;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			leJoueur = new Joueur();
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
		private function motorBalles():void
		{
			;
		}
		
		private function motorJoueur():void
		{
			;
		}
		
		public function getInstance():Main
		{
			;
		}
		
		public function getNiveau():Niveau
		{
			;
		}
		
		public function render():void
		{
			;
		}
		
		
	}
	
}