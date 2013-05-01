package ui 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	
	import data.descriptiveData.ui.DescBitmapButton;
	import ui.interfaces.IDisplayElement;
	
	import managers.UIManager;
	import utils.PlatformUtils;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class BitmapButton extends Sprite implements IDisplayElement
	{
		public static const k_ENABLED:int = 0;
		public static const k_DISABLED:int = 1;
		public static const k_TOTAL_BITMAPS:int = 2;
		
		protected var m_descButton:DescBitmapButton;
		
		protected var m_bmDisplay:Bitmap;
		protected var m_fpActivateCallback:Function;
		protected var m_Format:TextFormat;
		protected var m_tfText:TextField;
		
		protected var m_nAlignmentX:Number;
		protected var m_nAlignmentY:Number;
		
		protected var m_vBitmaps:Vector.<Bitmap>;
		
		/**
		 * @inheritDoc
		 */
		public function set xAlign(value:Number):void {
			m_nAlignmentX = value;
			if (m_bmDisplay != null) {
				m_bmDisplay.x = -m_bmDisplay.width * m_nAlignmentX;
				if (m_tfText != null)
					m_tfText.x = m_bmDisplay.x + (m_bmDisplay.width - m_tfText.width) / 2;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function set yAlign(value:Number):void {
			m_nAlignmentY = value;
			if (m_bmDisplay != null) {
				m_bmDisplay.y = -m_bmDisplay.height * m_nAlignmentY;
				if (m_tfText != null)
					m_tfText.y = m_bmDisplay.y + (m_bmDisplay.height - m_tfText.height) / 2;
			}
		}
		
		/**
		 * Click/Tap Callback.
		 */
		public function set fpActivateCallback(value:Function):void {
			m_fpActivateCallback = value;
		}
		
		public function set text(value:String):void {
			if (m_tfText != null) {
				m_tfText.text = value;
				
				if (m_descButton.m_nTextSize == 0) {
					m_Format.size = Math.min(
						Math.floor((m_bmDisplay.width - m_descButton.m_nTextBuffer) / Math.ceil(m_tfText.textWidth) * (m_tfText.defaultTextFormat.size as Number)),
						Math.floor((m_bmDisplay.height - m_descButton.m_nTextBuffer) / Math.ceil(m_tfText.textHeight) * (m_tfText.defaultTextFormat.size as Number)));
					m_tfText.defaultTextFormat = m_Format;
					m_tfText.setTextFormat(m_Format);
				}
				
				m_tfText.height = m_tfText.textHeight + 4;
				m_tfText.width = m_tfText.textWidth + 4;
				
				m_tfText.x = m_bmDisplay.x + (m_bmDisplay.width - m_tfText.width) / 2;
				m_tfText.y = m_bmDisplay.y + (m_bmDisplay.height - m_tfText.height) / 2;
			}
		}
		
		public function BitmapButton() 
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function init():void { 
			m_bmDisplay = new Bitmap();
			m_tfText = new TextField();
			m_tfText.mouseEnabled = false;
			m_tfText.selectable = false;
			m_tfText.multiline = false;
			
			addChild(m_bmDisplay);
			addChild(m_tfText);
			
			m_vBitmaps = new Vector.<Bitmap>(k_TOTAL_BITMAPS);
			for (var i:int = 0; i < k_TOTAL_BITMAPS; i++)	{
				m_vBitmaps[i] = new Bitmap();
			}
			
			//	This won't do anything unless we're in desktop mode.
			buttonMode = true;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * --	Building the Button via XML and DescBitmapButton.
		 * If you wish to add this to the XML then you may pass a DescBitmapButton to auto-build it.
		 * 
		 * --	Setting The Image
		 * bitmapData	<Vector> List of BitmapData to set this bitmap data to, this does not make a clone so do not alter the source images.
		 * bitmap	<Vector> List of Bitmaps to take the BitmapData out of to set this bitmap data to, this does not make a clone so do not alter the source images.
		 * imageUrl	<Vector> (CURRENTLY NOT SUPPORTED - Functionality for loading via a url currently does not exist for this project)
		 * 
		 * --	Callbacks
		 * activateCallback	<String> This is the function that is called when the 
		 */
		public function loadData(dataObj:Object):void {
			//	This may not actually come through as a 
			m_descButton = dataObj as DescBitmapButton;
			if (m_descButton == null)
				throw new Error("BitmapButton::loadData - loadData called without sending a valid DescBitmapButton.");
			
			//	Image
			if (m_descButton == null && dataObj.bitmapData)
				m_bmDisplay.bitmapData = dataObj.bitmapData;
			else if (m_descButton == null && dataObj.bitmap)
				m_bmDisplay.bitmapData = (dataObj.bitmap as Bitmap).bitmapData;
			else if (dataObj.m_strEmbeddedAssetKey) {
				if (UIManager.s_EmbeddedAssets == null)
					throw new Error("BitmapButton::loadData - Passed an embeddedAssetKey while UIManager.s_EmbeddedAssets was null.");
				if (UIManager.s_EmbeddedAssets[dataObj.m_strEmbeddedAssetKey] == null)
					throw new Error("BitmapButton::loadData - Passed an embeddedAssetKey that was not found in UIManager.s_EmbeddedAssets.");
				var embeddedBitmap:Bitmap = new UIManager.s_EmbeddedAssets[dataObj.m_strEmbeddedAssetKey]();
				m_bmDisplay.bitmapData = embeddedBitmap.bitmapData;
			}
			else if (dataObj.m_strImageUrl) {
				//	TODO: Load url method insert, possibly use dataObject field in method described in assetLoaded?
			}
			
			//	X/Y Position
			if (dataObj.x)	x = dataObj.x;
			if (dataObj.y)	y = dataObj.y;
			
			m_Format = new TextFormat();
			if (dataObj.m_nTextSize)	m_Format.size = dataObj.m_nTextSize;
			if (dataObj.m_nTextColor)	m_Format.color = dataObj.m_nTextColor;
			if (dataObj.m_strFontKey)	m_Format.font = dataObj.m_strFontKey;
			m_Format.align = "center";
			m_Format.bold = true;
			
			m_tfText.embedFonts = true;
			m_tfText.defaultTextFormat = m_Format;
			m_tfText.setTextFormat(m_Format);
			
			if (dataObj.m_strText)
				text = dataObj.m_strText;
			else {
				m_tfText.height = m_bmDisplay.height;
				m_tfText.width = m_bmDisplay.width;
			}
			
			//	IDisplayElement Alignment
			if (dataObj.m_nDisplayAlignX)	{
				xAlign = dataObj.m_nDisplayAlignX is String ? UIConstants[dataObj.m_nDisplayAlignX] : dataObj.m_nDisplayAlignX;
			}
			if (dataObj.m_nDisplayAlignY)	{
				yAlign = dataObj.m_nDisplayAlignY is String ? UIConstants[dataObj.m_nDisplayAlignY] : dataObj.m_nDisplayAlignY;
			}
			
			//	Click/Touch Callback
			if (m_descButton == null && dataObj.activateCallback)
				m_fpActivateCallback = dataObj.activateCallback;
			
			addEventListener(PlatformUtils.actionEvent, activateCallback, false, 0, true);
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
		 * Click/Tap Callback.
		 * @param	e	<Event>
		 */
		protected function activateCallback(e:Event):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			if (m_fpActivateCallback != null)
				m_fpActivateCallback(e);
				
			if (m_descButton && m_descButton.m_strDispatch != "")
				UIManager.sendDispatch(m_descButton.m_strDispatch, e, m_descButton.m_strDispatchArgs);
		}
		
		/**
		 * @inheritDoc
		 */
		public function align(xAlign:Number, yAlign:Number):void {
			this.xAlign = xAlign;
			this.yAlign = yAlign;
		}
		
		/**
		 * @inheritDoc
		 */
		public function center():void {
			xAlign = UIConstants.k_DISPLAY_ALIGN_ON_CENTER;
			yAlign = UIConstants.k_DISPLAY_ALIGN_ON_CENTER;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void {
			if (m_bmDisplay && m_bmDisplay.parent)
				m_bmDisplay.parent.removeChild(m_bmDisplay);
			m_bmDisplay = null;
			
			m_fpActivateCallback = null;
			m_vBitmaps = null;
		}
	}

}