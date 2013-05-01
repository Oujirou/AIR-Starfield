package ui.menu 
{
	import data.descriptiveData.ui.DescButtonList;
	import ui.interfaces.IDisplayElement;
	import ui.interfaces.IMenuElement;
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import managers.UIManager;
	import ui.BitmapButton;
	import ui.UIConstants;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class MenuButtonList extends Sprite implements IDisplayElement, IMenuElement
	{
		private var m_vButtons:Vector.<IDisplayElement>;
		
		protected var m_nContainerAlignment:int;
		protected var m_nMenuOffsetX:Number = 0;
		protected var m_nMenuOffsetY:Number = 0;
		
		protected var m_nAlignmentX:Number = 0;
		protected var m_nAlignmentY:Number = 0;
		
		//{ region IMenuElement Implementation - Accessors/Mutators
		/**
		 * @inheritDoc
		 */
		public function get menuContainerAlignment():int			{	return m_nContainerAlignment;	}
		
		/**
		 * @inheritDoc
		 */
		public function set menuContainerAlignment(value:int):void	{	m_nContainerAlignment = value;	}
		
		public function get xMenuOffset():Number					{	return m_nMenuOffsetX;			}
		public function set xMenuOffset(value:Number):void			{	m_nMenuOffsetX = value;			}
		
		public function get yMenuOffset():Number					{	return m_nMenuOffsetY;			}
		public function set yMenuOffset(value:Number):void			{	m_nMenuOffsetY = value;			}
		//} endregion
		
		//{ region IDisplayElement Implementation - Accessors/Mutators
		/**
		 * @inheritDoc
		 */
		public function set xAlign(value:Number):void 				{
			m_nAlignmentX = value;
			x = -width * m_nAlignmentX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set yAlign(value:Number):void				{
			m_nAlignmentY = value;
			y = -height * m_nAlignmentY;
		}
		//} endregion
		
		public function MenuButtonList() 
		{
			
		}
		
		//{ region IDisplayElement Implementation - Methods
		/**
		 * @inheritDoc
		 */
		public function init():void { 
			m_vButtons = new Vector.<IDisplayElement>();
		}
		
		/**
		 * @inheritDoc
		 */
		public function loadData(dataObj:Object):void {
			//	Check for DescButtonList and populate buttons.
			if (dataObj is DescButtonList) {
				var desc:DescButtonList = dataObj as DescButtonList;
				desc.buildData();
				
				var btn:BitmapButton;
				
				var iterations:int = 0;
				var dimensionHelper:Number = 0;
				var xOffset:Number = 0;
				var yOffset:Number = 0;
				var len:int = desc.buttonData.length;
				for (var i:int = 0; i < len; i++) 
				{
					btn = new BitmapButton();
					btn.init();
					btn.loadData(desc.buttonData[i]);
					
					m_vButtons.push(btn);
					addChild(btn);
					
					//	Get ready the offset based on the direction we are going, default is top to bottom.
					switch (desc.m_nDirection) {
						case DescButtonList.k_DIRECTION_TOP_BOTTON:
							if (i > 0 && desc.m_nNewLineEvery != -1 && i % desc.m_nNewLineEvery == 0) {
								xOffset += width - dimensionHelper + desc.m_nBuffer - desc.m_nBuffer * iterations;
								dimensionHelper = width;
								
								yOffset = 0;
								iterations++;
							}
							
							btn.x = xOffset;
							btn.y = yOffset;
							yOffset += btn.height + desc.m_nBuffer;
							break;
							
						case DescButtonList.k_DIRECTION_BOTTOM_TOP:
							if (i > 0 && desc.m_nNewLineEvery != -1 && i % desc.m_nNewLineEvery == 0) {
								xOffset += width - dimensionHelper + desc.m_nBuffer - desc.m_nBuffer * iterations;
								dimensionHelper = width;
								
								yOffset = 0;
								iterations++;
							}
							
							btn.x = xOffset;
							btn.y = yOffset;
							yOffset -= btn.height + desc.m_nBuffer;
							break;
							
						case DescButtonList.k_DIRECTION_LEFT_RIGHT:
							if (i > 0 && desc.m_nNewLineEvery != -1 && i % desc.m_nNewLineEvery == 0) {
								yOffset += height - dimensionHelper + desc.m_nBuffer - desc.m_nBuffer * iterations;
								dimensionHelper = height;
								
								xOffset = 0;
								iterations++;
							}
							
							btn.x = xOffset;
							btn.y = yOffset;
							xOffset += btn.width + desc.m_nBuffer;
							break;
							
						case DescButtonList.k_DIRECTION_RIGHT_LEFT:
							if (i > 0 && desc.m_nNewLineEvery != -1 && i % desc.m_nNewLineEvery == 0) {
								yOffset += height - dimensionHelper + desc.m_nBuffer - desc.m_nBuffer * iterations;
								dimensionHelper = height;
								
								xOffset = 0;
								iterations++;
							}
							
							btn.x = xOffset;
							btn.y = yOffset;
							xOffset -= btn.width + desc.m_nBuffer;
							break;
					}
				}
			}
			
			//	X/Y Position
			if (dataObj.x)	x = dataObj.x;
			if (dataObj.y)	y = dataObj.y;
			
			//	IDisplayElement Alignment
			if (dataObj.m_nDisplayAlignX)	{
				xAlign = dataObj.m_nDisplayAlignX is String ? UIConstants[dataObj.m_nDisplayAlignX] : dataObj.m_nDisplayAlignX;
			}
			if (dataObj.m_nDisplayAlignY)	{
				yAlign = dataObj.m_nDisplayAlignY is String ? UIConstants[dataObj.m_nDisplayAlignY] : dataObj.m_nDisplayAlignY;
			}
			
			//	IMenuElement Alignment
			if (dataObj.m_nContainerAlignment)	{
				m_nContainerAlignment = dataObj.m_nContainerAlignment;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function assetLoaded(asset:Object, dataObject:Object):void {
			if (dataObject.target) {
				if(asset is BitmapData)
					this[dataObject.target].bitmapData = asset;
				else if (asset is Bitmap)
					this[dataObject.target].bitmapData = (asset as Bitmap).bitmapData;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function align(xAlign:Number, yAlign:Number):void {
			m_nAlignmentX = xAlign;
			m_nAlignmentY = yAlign;
			
			x = width * m_nAlignmentX;
			y = height * m_nAlignmentY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function center():void {
			m_nAlignmentX = UIConstants.k_DISPLAY_ALIGN_ON_CENTER;
			m_nAlignmentY = UIConstants.k_DISPLAY_ALIGN_ON_CENTER;
			
			x = width * m_nAlignmentX;
			y = height * m_nAlignmentY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void {
			for each (var element:IDisplayElement in m_vButtons)	{
					element.clear();
			}
			m_vButtons = null;
		}
		//} endregion
	}

}