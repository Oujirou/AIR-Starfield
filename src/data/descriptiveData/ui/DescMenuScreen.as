package data.descriptiveData.ui 
{
	import data.descriptiveData.DescriptiveData;
	import managers.DataManager;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class DescMenuScreen extends DescriptiveData
	{
		protected var m_vMenuElementData:Vector.<DescriptiveData>;
		
		public var m_strMenuElementIDs:String = "";
		
		public function get menuElementData():Vector.<DescriptiveData>	{	return m_vMenuElementData;		}
		
		public function DescMenuScreen() 
		{
			super();
		}
		
		/**
		 * This will link any element data as denoted in the ElementIDs.  We would set this in the XML and break it out in here.
		 */
		public function buildData():void {
			var elementData:DescriptiveData;
			var elementIds:Array = m_strMenuElementIDs.split(",");
			var len:int = elementIds.length;
			
			m_vMenuElementData = new Vector.<DescriptiveData>();
			
			for (var i:int = 0; i < len; i++) 
			{
				elementData = DataManager.descriptiveData[elementIds[i]] as DescriptiveData;
				if (elementData != null) {
					m_vMenuElementData.push(elementData);
				}
				else {
					trace("3:DescMenuScreen::buildData - Error in finding element by the ID:", elementIds[i], " in m_id ", m_id);
				}
			}
		}
		
		
	}

}