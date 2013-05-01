package ui.menu 
{
	import data.descriptiveData.DescriptiveData;
	import data.descriptiveData.ui.DescMenuScreen;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import ui.interfaces.IDisplayElement;
	import ui.interfaces.IMenuElement;
	import ui.UIConstants;
	import managers.UIManager;
	import utils.PlatformUtils;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class MenuScreen extends Sprite implements IDisplayElement
	{
		protected static const k_MENU_OFFSETS:Vector.<Point> = new Vector.<Point>(9);
		
		protected var m_descMenuScreen:DescMenuScreen;
		protected var m_vElements:Vector.<Sprite>;
		
		protected var m_nAlignmentX:Number;
		protected var m_nAlignmentY:Number;
		
		//{ region IDisplayElement Implementation - Accessors/Mutators
		/**
		 * @inheritDoc
		 */
		public function set xAlign(value:Number):void {
			m_nAlignmentX = value;
			x = width * m_nAlignmentX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set yAlign(value:Number):void {
			m_nAlignmentY = value;
			y = height * m_nAlignmentY;
		}
		//} endregion
		
		public function MenuScreen() 
		{
			
		}
		
		//{ region IDisplayElement Implementation - Methods
		/**
		 * @inheritDoc
		 */
		public function init():void {
			m_vElements = new Vector.<Sprite>();
			if (k_MENU_OFFSETS[0] == null)
				gatherMenuOffsets();
		}
		
		/**
		 * @inheritDoc
		 */
		public function loadData(dataObj:Object):void {
			if (dataObj is DescMenuScreen == false)
				throw new Error("MenuScreen::loadData - Not passed a valid DescMenuScreen.");
				
			m_descMenuScreen = dataObj as DescMenuScreen;
			m_descMenuScreen.buildData();
			
			var iDisplay:IDisplayElement;
			var iMenu:IMenuElement;
			
			var elements:Vector.<DescriptiveData> = m_descMenuScreen.menuElementData;
			var element:Sprite;
			
			var menuOffset:Point;
			var len:int = elements.length;
			for (var i:int = 0; i < len; i++)	{
				element = new elements[i].classRef;
				
				iDisplay = element as IDisplayElement;
				iMenu = element as IMenuElement;
				
				if (iDisplay) {
					iDisplay.init();
					iDisplay.loadData(elements[i]);
				}
				
				if (iMenu) {
					menuOffset = k_MENU_OFFSETS[iMenu.menuContainerAlignment];
					element.x += menuOffset.x + iMenu.xMenuOffset;
					element.y += menuOffset.y + iMenu.yMenuOffset;
				}
				
				m_vElements.push(element);
				addChild(element as DisplayObject);
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
			//	TODO: Clear menu.
			//if(m_bmDisplay != null) {
				//if (m_bDisposable && m_bmDisplay.bitmapData)
					//m_bmDisplay.bitmapData.dispose();
				//if (m_bmDisplay.parent)
					//m_bmDisplay.parent.removeChild(m_bmDisplay);
			//}
			//m_bmDisplay = null;
		}
		//} endregion
		
		/**
		 * Here we set the offsets for menu items.
		 */
		private function gatherMenuOffsets():void {
			var sw:Number = PlatformUtils.stageWidth;
			var sh:Number = PlatformUtils.stageHeight;
			
			//	I could have put it in a nifty for loop, but this is easier to understand.
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_TOP_LEFT]	= new Point(0, 0);
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_TOP_CENTER]	= new Point(sw / 2, 0);
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_TOP_RIGHT]	= new Point(sw, 0);
			
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_MIDDLE_LEFT]		= new Point(0, sh / 2);
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_CENTER]			= new Point(sw / 2, sh / 2);
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_MIDDLE_RIGHT]	= new Point(sw, sh / 2);
			
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_BOTTOM_LEFT]		= new Point(0, sh);
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_BOTTOM_CENTER]	= new Point(sw / 2, sh);
			k_MENU_OFFSETS[UIConstants.k_CONTAINER_BOTTOM_RIGHT]	= new Point(sw, sh);
		}
	}

}