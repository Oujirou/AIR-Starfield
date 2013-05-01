package starfield
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class StarField extends Bitmap
	{
		protected var m_TopLeft:Field;
		protected var m_TopRight:Field;
		protected var m_BottomLeft:Field;
		protected var m_BottomRight:Field;
		
		protected var m_nUpdateIndex:int = 0;
		
		public var m_Center:Point;
		
		public function get numStars():int	{
			return m_TopLeft.numStars + m_TopRight.numStars + m_BottomLeft.numStars + m_BottomRight.numStars;
		}
		
		public function set renderMode(mode:int):void {
			switch (mode)	{
				case Field.c_METHOD_COPY_PIXEL:
					m_TopLeft.renderMode = Field.c_METHOD_COPY_PIXEL;
					m_TopRight.renderMode = Field.c_METHOD_COPY_PIXEL;
					m_BottomLeft.renderMode = Field.c_METHOD_COPY_PIXEL;
					m_BottomRight.renderMode = Field.c_METHOD_COPY_PIXEL;
				break;
				
				case Field.c_METHOD_DRAW:
					m_TopLeft.renderMode = Field.c_METHOD_DRAW;
					m_TopRight.renderMode = Field.c_METHOD_DRAW;
					m_BottomLeft.renderMode = Field.c_METHOD_DRAW;
					m_BottomRight.renderMode = Field.c_METHOD_DRAW;
				break;
			}
		}
		
		public function StarField(bitmapData:BitmapData, pixelSnapping:String = "auto", smoothing:Boolean = false) 
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		/**
		 * Initializes our star field with a given number of stars.  The field will recycle those stars as long as possible.
		 * @param	starCount	<int> The number of stars to show.
		 */
		public function init(starCount:int):void {
			var fieldMax:int = starCount / 4;
			var fieldWidth:int = bitmapData.width / 2;
			var fieldHeight:int = bitmapData.height / 2;
			var rect:Rectangle = new Rectangle(0, 0, fieldWidth, fieldHeight);
			
			m_Center = new Point(fieldWidth, fieldHeight);
			
			//	New Rects!
			m_TopLeft = new Field();
			m_TopRight = new Field();
			m_BottomLeft = new Field();
			m_BottomRight = new Field();
			
			//	Top Left
			m_TopLeft.init(fieldMax, rect, this);
			
			//	Top Right
			rect.x += fieldWidth;
			m_TopRight.init(fieldMax, rect, this);
			
			//	Bottom Left
			rect.x = 0;
			rect.y += fieldHeight;
			m_BottomLeft.init(fieldMax, rect, this);
			
			//	Bottom Right
			rect.x += fieldWidth;
			m_BottomRight.init(fieldMax, rect, this)
		}
		
		/**
		 * Update loop to update a quarter of the star field at a time and then draw it.
		 * @param	<Number> The delta time between the last frame.
		 */
		public function update(delta:Number):void {
			const updateOrder:Array/*Field*/ = [m_TopLeft, m_TopRight, m_BottomLeft, m_BottomRight];
			const updateField:Field = updateOrder[m_nUpdateIndex];
			m_nUpdateIndex = (m_nUpdateIndex + 1) % 4;
			
			updateField.update(delta);
			updateField.render();
		}
		
		/**
		 * Removes the given amount of stars from the field, removing 1/4th of the given number from each field.
		 * @param	amount	<int> The amount of stars to remove.
		 */
		public function removeStars(amount:int):void {
			const perField:int = amount / 4;
			
			//	Removes stars from each Field.
			m_TopLeft.removeStars(perField);
			m_TopRight.removeStars(perField);
			m_BottomLeft.removeStars(perField);
			m_BottomRight.removeStars(perField);
		}
		
		/**
		 * Adds a given amount of stars.
		 * @param	amount
		 */
		public function addStars(amount:int):void {
			const perField:int = amount / 4;
			
			//	Adds stars to each Field.
			m_TopLeft.spawnStars(perField);
			m_TopRight.spawnStars(perField);
			m_BottomLeft.spawnStars(perField);
			m_BottomRight.spawnStars(perField);
		}
		
		public function resize(newWidth:Number, newHeight:Number):void {
			if (bitmapData.width == newWidth && bitmapData.height == newHeight)
				return;
				
			//	Make the new field canvas and set it to our held bitmapData
			var bmd:BitmapData = new BitmapData(newWidth, newHeight, false, 0);
			bmd.draw(bitmapData)
			
			bitmapData.dispose();
			bitmapData = bmd;
			
			//	Build new field boundaries
			var fieldWidth:int = newWidth / 2;
			var fieldHeight:int = newHeight / 2;
			var rect:Rectangle = new Rectangle(0, 0, fieldWidth, fieldHeight);
			
			//	Change to the new Center.
			m_Center.x = fieldWidth;
			m_Center.y = fieldHeight;
			
			//	Change each field to their new dimensions.
			m_TopLeft.m_Rect.x = 0;
			m_TopLeft.m_Rect.y = 0;
			m_TopLeft.m_Rect.height = fieldHeight;
			m_TopLeft.m_Rect.width = fieldWidth;
			
			m_TopRight.m_Rect.x = fieldWidth;
			m_TopRight.m_Rect.y = 0;
			m_TopRight.m_Rect.height = fieldHeight;
			m_TopRight.m_Rect.width = fieldWidth;
			
			m_BottomLeft.m_Rect.x = 0;
			m_BottomLeft.m_Rect.y = fieldHeight;
			m_BottomLeft.m_Rect.height = fieldHeight;
			m_BottomLeft.m_Rect.width = fieldWidth;
			
			m_BottomRight.m_Rect.x = fieldWidth;
			m_BottomRight.m_Rect.y = fieldHeight;
			m_BottomRight.m_Rect.height = fieldHeight;
			m_BottomRight.m_Rect.width = fieldWidth;
			
			//	Render everything once
			m_TopLeft.render();
			m_TopRight.render();
			m_BottomLeft.render();
			m_BottomRight.render();
		}
		
	}

}