package ui.interfaces 
{
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public interface IMenuElement 
	{
		/**
		 * Gets the container alignment as given in <code>UIConstants.as</code> under k_CONTAINER.
		 */
		function get menuContainerAlignment():int;
		
		/**
		 * Sets the container alignment as given in <code>UIConstants.as</code> under k_CONTAINER.
		 */
		function set menuContainerAlignment(value:int):void;
		
		function get xMenuOffset():Number;
		function set xMenuOffset(value:Number):void;
		
		function get yMenuOffset():Number;
		function set yMenuOffset(value:Number):void;
		
		function IMenuElement();
		
	}

}