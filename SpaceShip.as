package  {
	
	public class SpaceShip {
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var speed:Number;
		public var attachedPlanet:Planet;
		public var name: String;
		public var angle: Number;
		public var color: uint;

		public function SpaceShip() {
			// constructor code
			color = 0xffffff * Math.random();
			radius = 20;
		}

	}
	
}
