package starfield
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Jonathon Barlet
	 */
	public class Star 
	{
		protected var m_OriginalPosition:Point;
		protected var m_Velocity:Point;
		protected var m_Rect:Rectangle;
		
		public var m_Alpha:Number;
		
		/*Kept public for rendering access.*/
		public var m_Position:Point;
		
		public function Star() 
		{
			
		}
		
		/**
		 * Initializes the Star for use.
		 * @param	xPosition	<int> The starting X position.
		 * @param	yPosition	<int> The starting Y position.
		 * @param	center	<Point> The center of the entire Star Field.
		 * @param	hitRect	<Rectangle> The area of the owning Field that this Star will not escape.
		 */
		public function init(xPosition:int, yPosition:int, center:Point, hitRect:Rectangle):void {
			m_Rect = hitRect;
			
			//	Gather our new positional data.
			m_OriginalPosition = new Point(xPosition, yPosition);
			m_Position = m_OriginalPosition.clone();
			
			//	Find our velocity and set the magnitude to a high speed, adjusted for only being updated once every 4 cycles.
			m_Velocity = m_Position.subtract(center);
			m_Velocity.normalize(Math.random() * 40 + 360);
		}
		
		/**
		 * Moves the star and resets the position if it has traveled too far.
		 * @param	delta	<Number> Distance moved.
		 */
		public function update(delta:Number):void {
			m_Position.x += m_Velocity.x * delta;
			m_Position.y += m_Velocity.y * delta;
			m_Alpha += delta;
			
			if (m_Rect.containsPoint(m_Position) === false) {
				m_Position = m_OriginalPosition.clone();
				m_Alpha = 0;
			}
		}
		
		/**
		 * Clears out all the objects this star holds.
		 */
		public function clear():void {
			m_OriginalPosition = null;
			m_Velocity = null;
			m_Position = null;
			m_Rect = null;
		}
	}

}