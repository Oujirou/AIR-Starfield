package ui 
{
	/**
	 * Used as strings inside various UI data classes to denote how to align classes.
	 * @author Jonathon Barlet
	 */
	public class UIConstants 
	{
		public static const k_CONTAINER_TOP_LEFT:int = 0;
		public static const k_CONTAINER_TOP_CENTER:int = 1;
		public static const k_CONTAINER_TOP_RIGHT:int = 2;
		public static const k_CONTAINER_MIDDLE_LEFT:int = 3;
		public static const k_CONTAINER_CENTER:int = 4;
		public static const k_CONTAINER_MIDDLE_RIGHT:int = 5;
		public static const k_CONTAINER_BOTTOM_LEFT:int = 6;
		public static const k_CONTAINER_BOTTOM_CENTER:int = 7;
		public static const k_CONTAINER_BOTTOM_RIGHT:int = 8;
		
		//{ region IDisplayElement
		public static const k_DISPLAY_ALIGN_ON_LEFT:Number = 0;
		public static const k_DISPLAY_ALIGN_ON_RIGHT:Number = 1;
		public static const k_DISPLAY_ALIGN_ON_TOP:Number = 0;
		public static const k_DISPLAY_ALIGN_ON_BOTTOM:Number = 1;
		public static const k_DISPLAY_ALIGN_ON_CENTER:Number = 0.5;
		//} endregion
		
		//{ region Directional Switches
		public static const k_LEFT_TO_RIGHT:int = 1;
		public static const k_RIGHT_TO_LEFT:int = 2;
		public static const k_TOP_TO_BOTTOM:int = 3;
		public static const k_BOTTOM_TO_TOP:int = 4;
		//} endregion
		
		public function UIConstants() 
		{
			
		}
		
	}

}