package managers 
{
	import dispatches.MenuDispatch;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import ui.interfaces.IDisplayElement;
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class UIManager 
	{
		private static var m_vDisplayElements:Vector.<IDisplayElement>;
		private static var m_DispatchListeners:Dictionary = new Dictionary();
		
		public static var s_EmbeddedAssets:Class;
		
		public function UIManager() 
		{
			
		}
		
		/**
		 * Add a function to listen to a dispatch as it would be sent through our UI system.
		 * @param	dispatch	<String> The string that would be dispatched by the UI system that we listen for.
		 * @param	callback	<Function> The callback to use if we receive the dispatch.  The format requires the callback to accept an Event.
		 */
		public static function addDispatchCallback(dispatch:String, callback:Function):void {
			if (dispatch === "" || callback === null)
				return;
			
			var vDispatchList:Vector.<Function>;
			
			if (dispatch in m_DispatchListeners)
				vDispatchList = m_DispatchListeners[dispatch] as Vector.<Function>;
			else {
				vDispatchList = new Vector.<Function>();
				m_DispatchListeners[dispatch] = vDispatchList;
			}
			
			vDispatchList.fixed = false;
			vDispatchList.push(callback);
			vDispatchList.fixed = true;
		}
		
		/**
		 * Remove a callback as held by a certain dispatch.
		 * @param	dispatch	<String> The string that would be the bucket where this callback would exist.
		 * @param	callback	<Function> The function we're removing.
		 */
		public static function removeDispatchCallback(dispatch:String, callback:Function):void {
			if (dispatch === "" || callback === null)
				return;
			
			var vDispatchList:Vector.<Function>;
			
			if (dispatch in m_DispatchListeners)
				vDispatchList = m_DispatchListeners[dispatch] as Vector.<Function>;
			else {
				trace("2:UIManager::removeDispatchCallback - Could not locate Vector corresponding to dispatch:", dispatch);
				return;
			}
			
			
			var index:uint = vDispatchList.indexOf(callback);
			if (index == -1) {
				trace("2:UIManager::removeDispatchCallback - Could not locate function inside Vector corresponding to dispatch:", dispatch);
				return;
			}
			
			vDispatchList.fixed = false;
			vDispatchList.splice(index, 1);
			vDispatchList.fixed = true;
		}
		
		/**
		 * This is where a UI Element would call to dispatch to various callbacks.
		 * @param	dispatch	<String> What we are about to dispatch.
		 * @param	e	<Event> The event that triggered this dispatch.
		 * @param	extraArgs	<String> Any extra arguments would be passed.
		 */
		public static function sendDispatch(dispatch:String, event:Event, extraArgs:String = ""):void {
			var vDispatchList:Vector.<Function>;
			
			if (dispatch in m_DispatchListeners)
				vDispatchList = m_DispatchListeners[dispatch] as Vector.<Function>;
			else
				return;
				
			var dispatchEvent:MenuDispatch;
			var func:Function;
			for each (func in vDispatchList) {
				dispatchEvent = new MenuDispatch(dispatch, event, extraArgs);
				func(dispatchEvent);
			}
		}
		
	}

}