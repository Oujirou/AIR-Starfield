package managers 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import data.Data;
	import utils.XML2JSON;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class DataManager 
	{
		public static var descriptiveData:Dictionary = new Dictionary();
		
		public function DataManager() 
		{
			
		}
		
		public static function mapDataObjects(dataObjects:Object):void {
			var newObj:Data;
			var obj:Object;
			var def:Object;
			
			for (obj in dataObjects) {
				if ("m_id" in dataObjects[obj] === false) {
					mapDataObjects(dataObjects[obj]);
					continue;
				}
				
				def = getDefinitionByName(dataObjects[obj].m_dataClass);
				newObj = new def;
				newObj.map(dataObjects[obj]);
				
				descriptiveData[newObj.id] = newObj;
			}
		}
		
		public static function mapDataXML(dataXML:XML):void {
			mapDataObjects(XML2JSON.parse(dataXML));
		}
		
		public static function clear():void {
			descriptiveData = null;
		}
	}

}