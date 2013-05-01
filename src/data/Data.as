package data 
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Base data class for all objects in the game.
	 * @author Jonathon Barlet
	 */
	public class Data 
	{
		public var m_id:String;
		
		public function get id():String	{	return m_id;	}
		
		public function Data() 
		{
			
		}
		
		/**
		 * This maps the values of the given object to this class.
		 * @param	value	<Object> The class that we will fill out.
		 */
		public function map(value:Object):void {
			var key:String;
			
			for (key in value) {
				if (key in this) {
					this[key] = value[key];
					continue;
				}
				CONFIG::debug {
					trace("Data::map - Value", key, "Not found in class", getQualifiedClassName(this));
				}
				
			}
		}
	}

}