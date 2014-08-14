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
			leTimer = new Timer(40, 0);		/// cadence le moteur des balles
			leTimer.start();				/// démarrage
			/// Manipulation des listener
			removeEventListener(Event.ADDED_TO_STAGE, init);	/// code standard
			//stage.focus = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown ); ///
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );///
			stage.addEventListener(MouseEvent.CLICK, onMouseLeftClick); ///
			leTimer.addEventListener(TimerEvent.TIMER, onTriggeredTimer); /// permet de faire bouger les balles toutes les 40 ms
			/// CONSTRUCTION SPRITE
			sprite_joueur = new Sprite();		/// création du sprite du joueur
			addChild(sprite_joueur);			/// ajout à la scène
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
		
		private function motorBalles():void  /// permet de faire bouger les balles toutes les 40 ms
		{
			var toRender:Boolean = false;	/// permet de savoir si l'assemblage des briques à changer afin de le réafficher
			var lesDetruites:Array = new Array();
			for each (var i:Balle in lesBalles )
			{
				if (i.getDestroy()) /// si la balles nous dis qu'elle est détruite on l'ajoute dans la liste des balles détruites (on ne peut pas la supprimer tout de suite
									/// car la liste des balles est en cours de lecture.
				{
					lesDetruites.push(i);
				}
				else
				{
					if (i.Work()) toRender = true;
				}
			}
			
			for each (var a:Balle in lesDetruites)		/// et c'est ici qu'on supprime toutes les balles qui sont détruite
			{
				a.getSprite().graphics.clear(); /// on efface leur graphique, cette ligne permet de les effacer.
				
				
				removeChild(a.getSprite()); /// on balance le sprite
				a.deleteSprite();
				
				lesBalles.slice(lesBalles.indexOf(a), 1); /// suppression de la balle en question /// on commence la suppression de un élement en commençant par l'index de celui à supprimer
														//// cette commande permet de supprimer un certain nombre d'élément de la liste (second paramétre) à partir d'un index (premier parametre)
			}
			if (toRender) render(); /// voir premiere ligne
		}
		
		private function motorJoueur():void    		/// pour plus tard
		{
			; /// rien pour l'instant
		}
		
		private function onTriggeredTimer(event:TimerEvent):void
		{
			motorBalles();	/// action des balles 25fois/s
			motorJoueur(); 
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			leJoueur.setPositionX(mouseX);	/// lorsqu'on bouge la souris, on donne la posx au joueur
		}
		private function onMouseLeftClick(event:MouseEvent):void
		{
			leJoueur.lancerBalle();			/// lorsqu'on clic n'importe où cette méthode est appelé
		}
		private function onKeyDown(event:KeyboardEvent):void
		{
		}
		
		static public function getInstance():Main
		{
			return instance;					/// permet d'accéder à l'instance unique du main, afin de pourvoir faire la méthode ADDCHILD ailleur dans notre programme
		}
		
		public function getNiveau():Niveau 	/// permet à toutes les autres classes de récupérer le Niveau et ainsi de traiter les colisions, et faire d'autre bétise , etc ...
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
						var a:Sprite = Niveau.lesSpritesDesBriques[y][x];	/// 
						a.graphics.clear();
						a.graphics.beginFill(Config.BriqueCouleur[Niveau.lesBriques[y][x]-1]); /// on recharge la couleur orrespondante
						a.graphics.drawRect(x * Config.Brique_Largeur, y * Config.Brique_Hauteur, Config.Brique_Largeur-0.5, Config.Brique_Hauteur-0.5);
						a.graphics.endFill();
					}
					else
					{
						Niveau.lesSpritesDesBriques[y][x].graphics.clear();	/// si l'emplacement est vide, on efface le sprite 
					}
				}
			}
		}
		
	}
	
}