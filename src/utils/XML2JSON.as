package utils {
    
	/**
	 * Picked up from http://krasimirtsonev.com/blog/article/as3-action-script-convert-xml-to-json-xml2json
	 */
    public class XML2JSON {
		
		private static var _arrays:Array;
		
		public static function get arrays():Array		{
			//if(!_arrays) {
				//_arrays = [];
			//}
			return _arrays ||= [];
		}
		public static function set arrays(a:Array):void	{    _arrays = a;	}
		
		/**
		* Parse an XML Node and all sub nodes into JSON.
		* @param	node
		* @return
		*/
		public static function parse(node:*):Object {
			var obj:Object = {};
			var numOfChilds:int = node.children().length();
			var childNode:*;
			var childNodeName:String;
			var value:*;
			var numOfAttributes:int;
			var j:int, i:int;
			
			for (i = 0; i < numOfChilds; i++) {
				childNode = node.children()[i];
				childNodeName = childNode.name();
				
				if(childNode.children().length() == 1 && childNode.children()[0].name() == null) {
					if(childNode.attributes().length() > 0) {
						value = { _content: childNode.children()[0].toString() };
						numOfAttributes = childNode.attributes().length();
						for(j = 0; j < numOfAttributes; j++) {
							value[childNode.attributes()[j].name().toString()] = childNode.attributes()[j];
						}
					}
					else
						value = childNode.children()[0].toString();
				} 
				else
					value = parse(childNode);
					
				if(obj[childNodeName]) {
					if(getTypeof(obj[childNodeName]) == "array")
						obj[childNodeName].push(value);
					else
						obj[childNodeName] = [obj[childNodeName], value];
				} 
				else if(isArray(childNodeName))
					obj[childNodeName] = [value];
				else
					obj[childNodeName] = value;
			}
			
			numOfAttributes = node.attributes().length();          
			for (i = 0; i < numOfAttributes; i++) {
				obj[node.attributes()[i].name().toString()] = node.attributes()[i];
			}
			
			if(numOfChilds == 0) {
				if(numOfAttributes == 0)
					obj = "";
				else
					obj._content = "";
			}
			
			return obj;
        }
        
		/**
		 * 
		 * @param	nodeName
		 * @return
		 */
		private static function isArray(nodeName:String):Boolean {
			var numOfArrays:int = _arrays ? _arrays.length : 0;
			for (var i:int = 0; i < numOfArrays; i++) {
				if(nodeName == _arrays[i])
					return true;
			}
			return false;
		}
		
		/**
		 * Returns the type of the thing.
		 * @param	o
		 * @return
		 */
		private static function getTypeof(o:*):String {
			if(typeof(o) == "object") {
				if(o.length == null)
					return "object";
				else if(typeof(o.length) == "number")
					return "array";
				else
					return "object";
			} 
			else
				return typeof(o);
		}
         
    }
     
}