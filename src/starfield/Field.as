package starfield
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class Field 
	{
		public static const c_METHOD_COPY_PIXEL:int = 0;
		public static const c_METHOD_DRAW:int = 1;
		
		/*The star to draw everywhere.*/
		protected static const c_sStar:BitmapData = new BitmapData(2, 2, false);
		
		/*Every star in this field.*/
		protected var m_vStars:Vector.<Star>;
		
		/*Owning Starfield.*/
		public var m_cStarField:StarField;
		
		/*The portion of the StarField that this Field controls.*/
		public var m_Rect:Rectangle;
		
		protected var m_fpRender:Function;
		
		public function get numStars():int	{	return m_vStars.length;	}
		
		public function set renderMode(mode:int):void {
			switch (mode)	{
				case c_METHOD_COPY_PIXEL:
					m_fpRender = renderCopyPixelMode;
				break;
				
				case c_METHOD_DRAW:
					m_fpRender = renderDrawMode;
				break;
			}
		}
		
		public function Field() 
		{
			
		}
		
		/**
		 * Initializes this Field for use.
		 * @param	stars	<int> The amount of starts to make.
		 * @param	rect	<Rectangle> The area this Field controls.
		 * @param	starfield	<StarField> The owner of this Field.
		 */
		public function init(stars:int, rect:Rectangle, starfield:StarField):void	{
			m_cStarField = starfield;
			m_Rect = rect.clone();
			
			m_vStars = new Vector.<Star>(stars);
			
			m_fpRender = renderDrawMode;
			
			//	Only spawn in the center of the screen so if a star spawns on the edges it won't 
			var spawnZone:Rectangle = new Rectangle(0, 0, m_Rect.width / 2, m_Rect.height / 2);
			spawnZone.x = m_Rect.x === 0 ? m_Rect.width / 2 : 0;
			spawnZone.y = m_Rect.y === 0 ? m_Rect.height / 2 : 0;
			
			const xRange:int = spawnZone.width;
			const yRange:int = spawnZone.height;
			
			var xPosition:int;
			var yPosition:int;
			var star:Star;
			var i:int;
			
			for (i = 0; i < stars; ++i)	{
				//	Positioning magic.
				xPosition = xRange * Math.random() + m_Rect.x + spawnZone.x;
				yPosition = yRange * Math.random() + m_Rect.y + spawnZone.y;
				
				//	Build and assign our star.
				star = new Star();
				star.init(xPosition, yPosition, m_cStarField.m_Center, m_Rect);
				star.update(Math.random() * 10);
				
				m_vStars[i] = star;
			}
		}
		
		/**
		 * Update loop.
		 * @param	<Number> The delta time between the last frame.
		 */
		public function update(delta:Number):void {
			var star:Star;
			for each(star in m_vStars) {
				star.update(delta);
			}
		}
		
		/**
		 * Renders this sector of the field.
		 */
		public function render():void {
			m_fpRender();
		}
		
		/**
		 * Render the Star Field with the Draw call, which looks nicer but is slower.
		 */
		private function renderDrawMode():void {
			const bmd:BitmapData = m_cStarField.bitmapData;
			bmd.fillRect(m_Rect, 0);
			
			var transform:ColorTransform = new ColorTransform();
			var matrix:Matrix = new Matrix();
			var star:Star;
			for each (star in m_vStars)	{
				matrix.tx = star.m_Position.x;
				matrix.ty = star.m_Position.y;
				transform.alphaMultiplier = star.m_Alpha;
				
				bmd.draw(c_sStar, matrix, transform);
			}
		}
		
		/**
		 * Render the Star Field with the CopyPixel call, which is super fast but doesn't look as nice.
		 */
		private function renderCopyPixelMode():void {
			const bmd:BitmapData = m_cStarField.bitmapData;
			bmd.fillRect(m_Rect, 0);
			
			var star:Star;
			for each (star in m_vStars)	{
				bmd.copyPixels(c_sStar, c_sStar.rect, star.m_Position);
			}
		}
		
		/**
		 * Spawns new stars.
		 * @param	newStars	<int> The amount of new stars to spawn.
		 */
		public function spawnStars(numStars:int):void {
			//	Unfix so we can alter the star amount.
			m_vStars.fixed = false;
			
			//	Get the center as seen by the user.
			var spawnZone:Rectangle = new Rectangle(0, 0, m_Rect.width / 2, m_Rect.height / 2);
			spawnZone.x = m_Rect.x === 0 ? m_Rect.width / 2 : 0;
			spawnZone.y = m_Rect.y === 0 ? m_Rect.height / 2 : 0;
			
			const xRange:int = spawnZone.width;
			const yRange:int = spawnZone.height;
			
			var star:Star;
			var i:int;
			for (i = 0; i < numStars; ++i)	{
				star = new Star();
				star.init(xRange * Math.random() + m_Rect.x + spawnZone.x, yRange * Math.random() + m_Rect.y + spawnZone.y, m_cStarField.m_Center, m_Rect);
				
				m_vStars.push(star);
			}
			
			//	Fix it again for speed.
			m_vStars.fixed = true;
		}
		
		/**
		 * Removes some stars from the list.
		 * @param	numStars
		 */
		public function removeStars(numStars:int):void {
			if (numStars >= m_vStars.length)
				return;
			
			//	Unfix so we can alter the star amount.
			m_vStars.fixed = false;
			
			var star:Star;
			var i:int;
			for (i = 0; i < numStars; ++i)	{
				m_vStars[i].clear();
			}
			m_vStars.splice(0, numStars);
			
			//	Fix it again for speed.
			m_vStars.fixed = true;
		}
	}

}