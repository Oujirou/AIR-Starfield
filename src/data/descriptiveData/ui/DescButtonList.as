package data.descriptiveData.ui 
{
	import data.descriptiveData.DescriptiveData;
	import managers.DataManager;
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class DescButtonList extends DescriptiveData
	{
		public static const k_DIRECTION_TOP_BOTTON:int = 0;
		public static const k_DIRECTION_LEFT_RIGHT:int = 1;
		public static const k_DIRECTION_BOTTOM_TOP:int = 2;
		public static const k_DIRECTION_RIGHT_LEFT:int = 3;
		
		protected var m_vButtonData:Vector.<DescBitmapButton>;
		
		public var m_nContainerAlignment:int;
		public var m_strEmbeddedAssetKey:String = "";
		public var m_strButtonDataIDs:String = "";
		public var m_nDisplayAlignX:String = "";
		public var m_nDisplayAlignY:String = "";
		public var m_nNewLineEvery:int = -1;
		public var m_nDirection:int = 0;
		public var m_nBuffer:Number;
		public var x:Number;
		public var y:Number;
		
		public function get buttonData():Vector.<DescBitmapButton>	{	return m_vButtonData;	}
		
		public function DescButtonList() 
		{
			super();
		}
		
		/**
		 * Here we break down the data inside m_strButtonDataIDs and figure out what Buttons are in this list.
		 */
		public function buildData():void {
			var buttonData:DescBitmapButton;
			var buttonIds:Array = m_strButtonDataIDs.split(",");
			var len:int = buttonIds.length;
			
			m_vButtonData = new Vector.<DescBitmapButton>();
			
			for (var i:int = 0; i < len; i++) 
			{
				buttonData = DataManager.descriptiveData[buttonIds[i]] as DescBitmapButton;
				if (buttonData != null) {
					m_vButtonData.push(buttonData);
				}
				else {
					trace("3:DescButtonList::buildData - Error in finding button data by the ID:", buttonIds[i], " in m_id ", m_id);
				}
			}
			
			m_vButtonData.fixed = true;
		}
		
	}

}