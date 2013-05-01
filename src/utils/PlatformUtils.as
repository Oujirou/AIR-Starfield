package utils 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public final class PlatformUtils 
	{
		public static const k_PLATFORM_DESKTOP:int = 1;
		public static const k_PLATFORM_ANDROID:int = 2;
		public static const k_PLATFORM_IOS:int = 3;
		
		private static var m_nPlatform:int;
		
		private static var m_nStageHeight:Number;
		private static var m_nStageWidth:Number;
		
		/*This variable is either MouseEvent.CLICK or TouchEvent.TAP depending on platform.*/
		private static var m_strActionEvent:String;
		
		//{ region Accessors
		static public function get actionEvent():String	{	return m_strActionEvent;	}
		static public function get stageHeight():Number	{	return m_nStageHeight;		}
		static public function get stageWidth():Number	{	return m_nStageWidth;		}
		static public function get platform():int		{	return m_nPlatform;			}
		//}
		
		public function PlatformUtils()
		{	
			throw new Error("PlatformUtils cannot be instanciated.");
		}
		
		/**
		 * Initializes the utility class by gathering data about the stage and the device capabilities.
		 * @param	mainStage	<Stage>
		 */
		public static function init(mainStage:Stage):void {
			//	TODO: This assumes landscape, if we need to change that then we need to expand upon this.
			m_nStageHeight = Math.min(mainStage.stageWidth, mainStage.stageHeight);
			m_nStageWidth = Math.max(mainStage.stageWidth, mainStage.stageHeight);
			
			switch (Capabilities.version.substr(0, 3).toLocaleUpperCase()) 
			{
				case "IOS":
					m_nPlatform = k_PLATFORM_IOS;
					break;
				case "AND":
					m_nPlatform = k_PLATFORM_ANDROID;
					break;
				default:
					m_nPlatform = k_PLATFORM_DESKTOP;
			}
			
			if (m_nPlatform === k_PLATFORM_DESKTOP)
				m_strActionEvent = MouseEvent.CLICK;
			else
				m_strActionEvent = TouchEvent.TOUCH_TAP;
		}
		
	}

}