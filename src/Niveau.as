package 
{
	import org.flashdevelop.utils.FlashConnect;
	import flash.display.Sprite;
	/// //////////////////////////// NORMALEMENT TOUS Y EST
	/**
	 * ...
	 * @author Kirako79 & Kribouille
	 */
	public class Niveau
	{
		static public var lesBriques:Array;
		static public var lesSpritesDesBriques:Array;
		
		public function Niveau()
		{
			lesBriques = new Array(Config.HauteurMap);
			var y:int = 0;
			for (y = 0; y < Config.HauteurMap; y++)
			{
				lesBriques[y] = new Array(Config.LargeurMap);
			}
			lesSpritesDesBriques = new Array(Config.HauteurMap);
			for (y = 0; y < Config.HauteurMap; y++)
			{
				lesSpritesDesBriques[y] = new Array(Config.LargeurMap);
			}			
		}
		/*
		 * 
		 * Retourne true si il y a bien un niveau qui a été chargé.
		 * Le niveau 0 n'existe pas
		 * 
		 * Chaque numéro dans le tableau indique le rang de la brique
		 * 
		 * */
		public function charger(idNiveau:Number):Boolean
		{
			var ret:Boolean = true;
			switch(idNiveau)
			{
				case 1:
					lesBriques = [
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0],
					[0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0],
					[0,0,0,0,0,0,1,1,3,3,1,3,3,1,1,0,0,0,0,0],
					[0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
					[0,0,0,1,1,0,1,1,1,1,1,1,1,1,1,0,1,1,0,0],
					[0,0,0,0,1,1,0,1,1,1,0,1,1,1,0,1,1,0,0,0],
					[0,0,0,0,0,0,0,0,1,1,0,1,1,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
					[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
					];
					break;
				default:
					ret = false;
					break;
			}
			return ret;
		}
		/*
		 * 
		 * retourne si true ou false la balle rebondis
		 * s'occupe également d'endommager la brique si necessaire
		 * 
		 * */
		public function testCollision(x:int, y:int):Boolean  /// il faut des int ici (bug 0x00002)
		{
			var collision:Boolean = false;
			if (x < 0 || y<  0 || y >= Config.HauteurMap || x >= Config.LargeurMap) /// faut pas sortir de la map
			{
				return true; 
			}
			if (lesBriques[y][x] > 0)
			{
				lesBriques[y][x] -= 1; /// on baisse le rang de la brique
				Data.Joueur_Score += 10;
				Main.getInstance().actualiseHUD();
				if (lesBriques[y][x] == 0)
				{
					lesSpritesDesBriques[y][x].graphics.clear();
				}
				collision = true;
			}
			else
			{
				
				collision = false;
			}
			return collision;
		}
	}
	
}