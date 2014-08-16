package 
{
	import flash.display.Sprite;
	import Config;
	import Math;
	/**
	 * ...
	 * @author Kirako79 & Kribouille
	 */
	public class Balle
	{
		private var saPositionX:Number;
		private var saPositionY:Number;
		private var sonSprite:Sprite;
		private var saVitesseAbsolu:Number;
		private var sonAngle:Number;
		
		private var sonCosAngle:Number, sonSinAngle:Number; /// permet d'éviter d'avoir à calculer le cos et le sin à chaque iteration (ça bouffe de la puissance)
		private var aDetruire:Boolean;							/// permet de savoir si elle doit être supprimer (motorBalles de MAIN)
		private var sonRayon:Number;
		
		import org.flashdevelop.utils.FlashConnect;
		
		static public function create(_x:Number,_y:Number,_angle:Number,_vitesse:Number):void
		{
			var unSprite:Sprite = new Sprite();
			Main.getInstance().stage.addChild(unSprite);
			var laBalle:Balle = new Balle(_x, _y, unSprite, _angle, _vitesse);
			Main.lesBalles.push(laBalle);
		}
		
		
		public function Balle(x:Number,y:Number,unSprite:Sprite,angle:Number,vitesse:Number)
		{
			aDetruire = false;
			saPositionX = x;
			saPositionY = y;
			sonSprite = unSprite;
			
			sonAngle = angle;
			saVitesseAbsolu = vitesse;
			recalculeVector();
			
			sonSprite.graphics.beginFill(Config.Balle_Couleur, 1);
			sonSprite.graphics.drawCircle(0, 0, Config.Balle_RayonStandard); /// haut gauche
			sonSprite.graphics.endFill();
			sonRayon = Config.Balle_RayonStandard;
			sonSprite.x = x;
			sonSprite.y = y;
			
		}
		
		/*
		 * Retourne true si il la balle à modifier la map
		 * 
		 * */
		public function Work():Boolean
		{
			var toRender:Boolean = false;
			saPositionX += sonCosAngle * saVitesseAbsolu;
			saPositionY += sonSinAngle * saVitesseAbsolu;
			
			
			/// gestion des collisions avec les briques
			/// en premier les points haut gauche droit et bas
			if (sonCosAngle >= 0) 															/// direction vers la droite
			{
				if (Main.getInstance().getNiveau().testCollision((saPositionX + sonRayon) / 10, (saPositionY) / 10) > 0)
				{
					toRender = true;
					sonAngle = Math.PI - sonAngle;
					recalculeVector();
				}
			}
			else 																			/// direction vers la gauche
			{
				if (Main.getInstance().getNiveau().testCollision((saPositionX - sonRayon) / 10, (saPositionY) / 10) > 0)
				{
					toRender = true;
					sonAngle = Math.PI - sonAngle;
					recalculeVector();
				}
			}
			
			if (sonSinAngle >= 0) 														/// direction vers le bas
			{
				if (Main.getInstance().getNiveau().testCollision((saPositionX) / 10, (saPositionY + sonRayon) / 10) > 0)
				{
					toRender = true;
					sonAngle = -sonAngle;
					recalculeVector();
				}
			}
			else 																		/// direction vers le haut
			{
				if (Main.getInstance().getNiveau().testCollision((saPositionX) / 10, (saPositionY - sonRayon) / 10) > 0)
				{
					toRender = true;
					sonAngle = -sonAngle;
					recalculeVector();
				}
			}
			
			/// gére la sortie de la balle par le bas et le rebonds sur le joueur
			
			var py:Number = Main.getInstance().getJoueur().getY();
			if (saPositionY + sonRayon >= py) /// pris en compte comme une collision sur l'axe Ys
			{
				var px:Number = Main.getInstance().getJoueur().getX();
				if (saPositionX >= px && saPositionX <= px + Config.LargeurJoueur) /// test des coord X
				{
					/// RATIO : 1 - ((saPositionX - px) / Config.LargeurJoueur) /// pour comprendre reporter voius au manuel page 42
					toRender = true;
					//sonAngle = -sonAngle;
					/*
					 * le joueur renvoie la balle selon cette règles ( -45 --- +45 )
					 * 
					 * 
					 * */
					sonAngle = -Math.PI / 4 - ((1-((saPositionX - px) / Config.LargeurJoueur)) * Math.PI/2) ;
					recalculeVector();
				}
				else /// sortie de la balle par dessous
				{
					this.aDetruire = true; /// BANG
				}
			}
			
			//FlashConnect.trace("saPositionX:"+saPositionX+"saVitesseAbsolu:"+saVitesseAbsolu+"sonCosAngle:"+sonCosAngle);
			//FlashConnect.trace("saPositionY:"+saPositionY+"saVitesseAbsolu:"+saVitesseAbsolu+"sonSinAngle:"+sonSinAngle);
			
			sonSprite.x = saPositionX;
			sonSprite.y = saPositionY;
			
			/// gérer rebonds sur les extrémité /// permet de gérer les erreur de 0.0 et -0.0
			if ((saPositionX - sonRayon) < 0)
			{
				sonAngle = Math.PI - sonAngle;
				recalculeVector();
			}
			if ((saPositionY - sonRayon) < 0)
			{
				sonAngle = -sonAngle;
				recalculeVector();
			}
			
			/*
			if ((saPositionX + sonRayon) >= 200 || (saPositionX - sonRayon) < 0)
			{
				sonAngle = Math.PI - sonAngle;
				recalculeVector();
			}
			if (((saPositionY + sonRayon) >= 200) || ((saPositionY - sonRayon) < 0))
			{
				sonAngle = -sonAngle;
				recalculeVector();
			}*/
			return toRender;
		}
		
		public function getDestroy():Boolean
		{
			return this.aDetruire;
		}
		
		public function getSprite():Sprite
		{
			return sonSprite;
		}
		
		public function deleteSprite():void
		{
			sonSprite = null;
		}
		
		private function recalculeVector():void
		{
			sonCosAngle = Math.cos(sonAngle);
			sonSinAngle = Math.sin(sonAngle);
		}
	}
	
}