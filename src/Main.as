package 
{
	import data.descriptiveData.ui.DescButtonList;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Multitouch;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import dispatches.MenuDispatch;
	import managers.DataManager;
	import managers.UIManager;
	import ui.menu.MenuButtonList;
	import ui.menu.MenuScreen;
	import utils.PlatformUtils;
	
	import starfield.*;
	
	/**
	 * Build with APK cert password "fd"
	 * @author Jonathon Barlet
	 */
	public class Main extends Sprite 
	{
		protected var m_CurrentMenu:MenuScreen;
		protected var m_bInitialized:Boolean;
		
		//	The Grand Star Field
		protected var m_StarField:StarField;
		
		//	Text Fields
		protected var m_tfStars:TextField;
		protected var m_tfMode:TextField;
		protected var m_tfFPS:TextField;
		
		//	FPS Variables
		protected var m_nSecond:Number = 0;
		protected var m_nFrames:int = 0;
		
		//	Delta Time Variables
		protected var m_nLastTime:int;
		protected var m_nDelta:Number;
		
		public function Main():void 
		{
			var dbl:DescButtonList;
			var mbl:MenuButtonList;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(Event.RESIZE, resized);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			//	Set Embedded Asset Class
			UIManager.s_EmbeddedAssets = EmbeddedAssets;
			
			// Load descriptive data.
			var ba:ByteArray = (new EmbeddedAssets.UI()) as ByteArray;
			var s:String = ba.readUTFBytes( ba.length );
			
			DataManager.mapDataXML(new XML(s));
		}
		
		private function resized(e:Event):void
		{
			PlatformUtils.init(stage);
			
			if (!m_bInitialized) {
				initialize();
			}
			else {
				m_StarField.resize(PlatformUtils.stageWidth, PlatformUtils.stageHeight);
				
				m_tfFPS.x = (PlatformUtils.stageWidth - m_tfFPS.width) / 2;
				m_tfStars.x = (PlatformUtils.stageWidth - m_tfStars.width) / 2;
				m_tfMode.x = (PlatformUtils.stageWidth - m_tfMode.width) / 2;
			}
		}
		
		private function enterFrame(e:Event):void
		{
			//	Delta Time
			var current:int = getTimer();
			m_nDelta = (current - m_nLastTime) / 1000;
			m_nLastTime = current;
			
			m_StarField.update(m_nDelta);
			
			//	FPS Matters
			m_nFrames++;
			m_nSecond += m_nDelta;
			if (m_nSecond >= 1) {
				m_tfFPS.text = "FPS: " + m_nFrames.toString();
				m_nSecond = m_nFrames = 0;
			}
		}
		
		private function initialize():void
		{
			m_bInitialized = true;
			
			PlatformUtils.init(stage);
			
			/////////////////////
			//	Star Field
			var canvas:BitmapData = new BitmapData(PlatformUtils.stageWidth, PlatformUtils.stageHeight, false, 0);
			m_StarField = new StarField(canvas, "auto", true);
			m_StarField.init(400);
			addChild(m_StarField);
			
			var format:TextFormat = new TextFormat(EmbeddedAssets.FontNameMolot);
			format.align = "center";
			format.color = 0xffffffff;
			format.size = 16;
			//format.
			
			/////////////////////
			//	Render Mode Text Field
			m_tfMode = new TextField();
			m_tfMode.textColor = 0xffffffff
			m_tfMode.backgroundColor = 0xaa000000;
			m_tfMode.background = true;
			m_tfMode.text = "Render Mode: Draw";
			m_tfMode.autoSize = TextFieldAutoSize.LEFT;
			m_tfMode.x = (PlatformUtils.stageWidth - m_tfMode.width) / 2;
			addChild(m_tfMode);
			
			/////////////////////
			//	Star Count Text Field
			m_tfStars = new TextField();
			m_tfStars.textColor = 0xffffffff
			m_tfStars.backgroundColor = 0xaa000000;
			m_tfStars.background = true;
			m_tfStars.text = "Stars: 400";
			m_tfStars.autoSize = TextFieldAutoSize.LEFT;
			m_tfStars.y += m_tfMode.height;
			m_tfStars.x = (PlatformUtils.stageWidth - m_tfStars.width) / 2;
			addChild(m_tfStars);
			
			/////////////////////
			//	FPS Text Field
			m_tfFPS = new TextField();
			m_tfFPS.textColor = 0xffffffff;
			m_tfFPS.backgroundColor = 0xaa000000;
			m_tfFPS.background = true;
			m_tfFPS.text = "FPS: 0";
			m_tfFPS.autoSize = TextFieldAutoSize.LEFT;
			m_tfFPS.x = (PlatformUtils.stageWidth - m_tfFPS.width) / 2;
			m_tfFPS.y = m_tfStars.y + m_tfStars.height;
			addChild(m_tfFPS);
			
			/////////////////////
			//	UI - Excluding Text Fields
			m_CurrentMenu = new MenuScreen();
			m_CurrentMenu.init();
			m_CurrentMenu.loadData(DataManager.descriptiveData["menu_main"]);
			
			addChild(m_CurrentMenu);
			
			UIManager.addDispatchCallback("CHANGE_RENDER_MODE", changeRenderMode);
			UIManager.addDispatchCallback("CHANGE_AMOUNT", alterStars);
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close - No backgrounding for this app.
			//NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * Changes the render mode by the given dispatch argument.
		 * @param	e	<MenuDispatch>
		 */
		private function changeRenderMode(e:MenuDispatch):void
		{
			switch (e.m_strArguments) 
			{
				case "Copy Pixel":
					m_StarField.renderMode = Field.c_METHOD_COPY_PIXEL;
				break;
				case "Draw":
					m_StarField.renderMode = Field.c_METHOD_DRAW;
				break;
				default:
			}
			m_tfMode.text = "Render Mode: " + e.m_strArguments;
		}
		
		/**
		 * Adds/Removes stars by a given amount.
		 * @param	e	<MenuDispatch>
		 */
		private function alterStars(e:MenuDispatch):void
		{
			var difference:int = int(e.m_strArguments);
			if (difference > 0)
				m_StarField.addStars(difference);
			else if (difference < 0)
				m_StarField.removeStars(difference * -1);
			m_tfStars.text = "Stars: " + m_StarField.numStars.toString();
		}
		
	}
	
}