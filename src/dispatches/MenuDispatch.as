package dispatches 
{
	import flash.events.Event;
	
	/**
	 * Class to 
	 * @author Jonathon Barlet
	 */
	public class MenuDispatch
	{
		public var m_strArguments:String = "";
		public var m_strDispatch:String = "";
		public var m_InvokingEvent:Event;
		
		public function MenuDispatch(dispatch:String, invokingEvent:Event, extraArgs:String = "") 
		{
			m_InvokingEvent = invokingEvent;
			m_strArguments = extraArgs;
			m_strDispatch = dispatch;
		}
		
	}

}