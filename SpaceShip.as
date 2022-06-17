package  {
	import flash.display.Stage;
	public class SpaceShip extends Entity{
		
		public var attachedPlanet:Planet;

		public function SpaceShip(_model:Model, _stage:Stage) {
			super(_model, _stage);
			color = 0xffffff * Math.random();
			radius = 20;
		}

		public function draw(parentObj: Planet = null): void {
			model.g1.beginFill(color, 1);
			var i;
			var j;
			if (parentObj) {

				/*
				var cos: Number = Math.cos(angle) * (distanceFromParent + parentObj.radius);
				var sin: Number = Math.sin(angle) * (distanceFromParent + parentObj.radius);
				cos += parentObj.x;
				sin += parentObj.y;
				//trace("pre draw", x,y,angle);
				x = cos;
				y = sin;
				angle += speed;
				angle = MathUtils.fixAngle(angle);
				*/

			}
			if (
				Utils.isInScreen(x, y, model.layers, stage) ||
				Utils.isInScreen(x + radius, y, model.layers, stage) ||
				Utils.isInScreen(x - radius, y, model.layers, stage) ||
				Utils.isInScreen(x, y + radius, model.layers, stage) ||
				Utils.isInScreen(x, y - radius, model.layers, stage)

			) {
				model.g1.drawCircle(x, y, radius); // Draw the circle, assigning it a x position, y position, raidius.
				model.g1.endFill();
			}
		}

	}
	
}
