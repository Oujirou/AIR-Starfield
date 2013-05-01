package data.descriptiveData 
{
	import data.Data;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class DescriptiveData extends Data
	{
		public var m_instanceClass:String;
		public var m_dataClass:String
		
		public function get instanceClassName():String	{	return m_instanceClass;	}
		public function get dataClassName():String		{	return m_dataClass;		}
		public function get classRef():Class			{	return getDefinitionByName(m_instanceClass) as Class;	}
		
		public function DescriptiveData() 
		{
			super();
		}
		
	}

}