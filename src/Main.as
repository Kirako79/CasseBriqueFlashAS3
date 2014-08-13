package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flashdevelop.utils.FlashConnect;
	import Joueur;
	import Niveau;
	import Balle;
	import Config;
	
	/**
	 * ...
	 * @author Kirako79 & Kribouille 
	 */
	 
	[SWF(frameRate='50',width='200',height='200',backgroundColor='0x101010')] /// il va agrandir la fenetre du jeux (ça ne restera pas je pense)
	 
	public class Main extends Sprite 
	{
		
		private var leJoueur:Joueur;
		static private var instance:Main;
		private var leNiveau:Niveau;
		/// TOUTES LES SPRITES à AFFICHER
		private var sprite_joueur:Sprite;
		static public var lesBalles:Array;
		/// TOUS LES TIMERS
		private var leTimer:Timer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function getJoueur():Joueur
		{
			return leJoueur;
		}
		
		private function init(e:Event = null):void 
		{
			instance = this; /// permet un acces à cette instance depuis une autre classe
			/// Configuration des timers
			leTimer = new Timer(40, 0);
			leTimer.start();
			/// Manipulation des listener
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//stage.focus = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown );
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener(MouseEvent.CLICK, onMouseLeftClick);
			leTimer.addEventListener(TimerEvent.TIMER, onTriggeredTimer);
			/// CONSTRUCTION SPRITE
			sprite_joueur = new Sprite();
			addChild(sprite_joueur);
			/// CONSTRUCTION DE TOUT LE RESTE
			leJoueur = new Joueur(Config.LargeurFenetre / 2, Config.HauteurFenetre-Config.HauteurJoueur, sprite_joueur);
			leNiveau = new Niveau();
			lesBalles = new Array();
			leNiveau.charger(1); /// on charge le premier niveau
			/// on construit tout les sprites des briques
			for (var x:int = 0; x < Config.LargeurMap; x++)
			{
				for (var y:int = 0; y < Config.HauteurMap; y++)
				{
					Niveau.lesSpritesDesBriques[y][x] = new Sprite();
					addChild(Niveau.lesSpritesDesBriques[y][x]);
				}
			}
			/// un petit coup de render avant de commencer
			render();
		}
		
		private function motorBalles():void
		{
			var toRender:Boolean = false;
			var lesDetruites:Array = new Array();
			for each (var i:Balle in lesBalles )
			{
				if (i.getDestroy())
				{
					lesDetruites.push(i);
				}
				else
				{
					if (i.Work()) toRender = true;
				}
			}
			
			for each (var a:Balle in lesDetruites)
			{
				
				a.getSprite().graphics.clear();
				
				removeChild(a.getSprite()); /// on balance le sprite
				
				lesBalles.slice(lesBalles.indexOf(a), 1); /// suppression de la balle en question /// on commence la suppression de un élement en commençant par l'index de celui à supprimer
			}
			if (toRender) render();
		}
		
		private function motorJoueur():void
		{
			; /// rien pour l'instant
		}
		
		private function onTriggeredTimer(event:TimerEvent):void
		{
			motorBalles();
			motorJoueur(); 
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			leJoueur.setPositionX(mouseX);
		}
		private function onMouseLeftClick(event:MouseEvent):void
		{
			leJoueur.lancerBalle();
		}
		private function onKeyDown(event:KeyboardEvent):void
		{
		}
		
		static public function getInstance():Main
		{
			return instance;
		}
		
		public function getNiveau():Niveau
		{
			return leNiveau;
		}
		
		public function render():void 
		{
			//FlashConnect.trace("Render");
			var x:int, y:int;
			for (x = 0; x < 20; x++)
			{
				for (y = 0; y < 19; y++)
				{
					if (Niveau.lesBriques[y][x] > 0)
					{
						var a:Sprite = Niveau.lesSpritesDesBriques[y][x];
						a.graphics.beginFill(Config.BriqueCouleur[Niveau.lesBriques[y][x]-1]); /// on recharge la couleur orrespondante
						a.graphics.drawRect(x * Config.Brique_Largeur, y * Config.Brique_Hauteur, Config.Brique_Largeur-0.5, Config.Brique_Hauteur-0.5);
						a.graphics.endFill();
						//a.buttonMode = true;
						//a.addEventListener(MouseEvent.MOUSE_OVER, onMouseMove);
						addChild(a);
					}
					else
					{
						Niveau.lesSpritesDesBriques[y][x].graphics.clear();
					}
				}
			}
		}
		
	}
	
}