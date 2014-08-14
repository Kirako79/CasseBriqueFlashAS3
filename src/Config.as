package 
{
	/// ///////////////////////////// AJOUTE TOUT CE QUE TU TROUVE NECESSAIRE
	/**
	 * ...
	 * @author Kirako79 & Kribouille
	 * 
	 * Permet de stocker des valeurs centralisés comme un rassemblement de DEFINE
	 * 
	 * 
	 * 
	 */
	public class Config 
	{
		static public var HauteurFenetre:Number = 200;
		static public var LargeurFenetre:Number = 200;
		static public var HauteurMap:Number = 20;
		static public var LargeurMap:Number = 20;
		static public var HauteurJoueur:Number = 10; /// paddle 
		static public var LargeurJoueur:Number = 25; /// paddle 
		
		static public var BriqueCouleur:Array = [0xf0f010, 0x10f0f0, 0x10f010]; /// utilisé dans Main::render
		static public var BriqueRangMaximum:int = 3;
		
		static public var Joueur_Couleur:int = 0xf0f0f0; /// + blanc tu meurs 
		static public var Balle_Couleur:int = 0x909010;
		
		
		static public var Brique_Hauteur:Number = 10;
		static public var Brique_Largeur:Number = 10;
		
		static public var Balle_RayonStandard:Number = 3;
	}
	
}