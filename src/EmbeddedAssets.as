package  
{
	/**
	 * All assets to be embedded into the APK/IPA.
	 * @author Jonathon Barlet
	 */
	public final class EmbeddedAssets 
	{
		[Embed (source="../assets/Button.png" )]
        public static const Button:Class;
		
		[Embed (source="../assets/UI.xml", mimeType="application/octet-stream" )]
		public static const UI:Class;
		
		[Embed(source="../assets/fonts/Molot.ttf", fontFamily="Molot", fontName="Molot", mimeType="application/x-font-truetype", embedAsCFF="false")]
		public static const MolotFont:Class
		public static const FontNameMolot:String = "Molot";
		
		public function EmbeddedAssets() 
		{
			
		}
		
	}

}