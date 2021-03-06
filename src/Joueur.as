package 
{
	import flash.display.Sprite;
	import Main;
	import Balle;
	import Config;
	/**
	 * ...
	 * @author Kirako79 & Kribouille
	 */
	public class Joueur
	{
		private var saPositionX:Number;
		private var saPositionY:Number;
		private var sonSprite:Sprite;
		
		public function Joueur(x:Number,y:Number,unSprite:Sprite)
		{
			saPositionX = x;
			saPositionY = y;
			sonSprite = unSprite;
			sonSprite.graphics.beginFill(Config.Joueur_Couleur, 1); /// le 1 correspond à la transparence
			sonSprite.graphics.drawRect(0, 0, Config.LargeurJoueur, Config.HauteurJoueur); /// les 0,0 sont necessaire (à vérifier)
			sonSprite.graphics.endFill();
			sonSprite.x = saPositionX;
			sonSprite.y = saPositionY;
		}
		
		public function getX():Number /// permet de faire les condition de rebonds de la balle sur cette la paddle
		{
			return saPositionX;
		}
		public function getY():Number /// elle aussi
		{
			return saPositionY;
		}
		
		public function lancerBalle():void
		{
			/// appel de la fonction static de la classe balle
			if (Main.lesBalles.length == 0 && Data.Joueur_Vie > 0)
			{
				Data.Joueur_Vie -= 1;
				Balle.create(saPositionX+(Config.LargeurJoueur/2),saPositionY-Config.Balle_RayonStandard,-Math.PI/2 + (Math.random()-0.5 * (Math.PI/2)),2.0);
			}
			else if (Data.Joueur_Vie == 0 && Main.lesBalles.length == 0)
			{
				/// fin du jeu, écran de submit score; /////////////////////
			}
		}
		/*
		 * Appelé depuis le Main quand la souris bouge (onMouseMove)
		 * */
		public function setPositionX(unX:Number): void
		{
			saPositionX = unX - (Config.LargeurJoueur / 2);
			if (saPositionX >= 0 && saPositionX < Config.LargeurFenetre)  /// pour l'instant on s'occupe pas des limites
			{
				
			}
			sonSprite.x = saPositionX;
		}
	}
}