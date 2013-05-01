package ui.interfaces 
{
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public interface IDisplayElement 
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		/**
		 * Sets the alignment on the X-Axis as given in <code>UIConstants.as</code> under k_DISPLAY.
		 */
		function set xAlign(value:Number):void;
		
		/**
		 * Sets the alignment on the Y-Axis as given in <code>UIConstants.as</code> under k_DISPLAY.
		 */
		function set yAlign(value:Number):void;
		
		function IDisplayElement();
		
		/**
		 * Initializes this class for use so everything in this class should be functional without issue.  To detail out this class you should
		 * call loadData with an appropriate data object.
		 */
		function init():void;
		
		/**
		 * Takes an object and maps the values to the current class.
		 * @param	dataObj
		 */
		function loadData(dataObj:Object):void;
		
		/**
		 * Loaded asset callback.
		 * @param	asset	<Object> The asset that we have loaded.
		 * @param	dataObject	<Object> the data that belongs to this particular asset load call.
		 */
		function assetLoaded(asset:Object, dataObject:Object):void;
		
		/**
		 * Aligns the class based on the given parameters.
		 * @param	xAlign	<Number> The x position as given in <code>UIConstants.as</code> under k_DISPLAY.
		 * @param	yAlign	<Number> The y position as given in <code>UIConstants.as</code> under k_DISPLAY.
		 * @see		UIConstants
		 */
		function align(xAlign:Number, yAlign:Number):void;
		
		/**
		 * Centers display object.
		 */
		function center():void;
		
		/**
		 * Removes all memory references from itself and prepares itself for garbage collection.
		 */
		function clear():void;
	}

}