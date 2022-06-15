package {
	import flash.display.Stage;

	public class PlanetUtils {

		public function PlanetUtils() {
			// constructor code
		}

		public static function drawPlanet(model:Model, stage:Stage, planet: Object, parentObj: Object = null): void {
			model.g1.beginFill(planet.color, 1);

			if (parentObj) {


				var cos: Number = Math.cos(planet.angle) * (planet.distanceFromParent + parentObj.radius);
				var sin: Number = Math.sin(planet.angle) * (planet.distanceFromParent + parentObj.radius);
				cos += parentObj.x;
				sin += parentObj.y;

				planet.x = cos;
				planet.y = sin;

				planet.angle += planet.speed;
				planet.angle = MathUtils.fixAngle(planet.angle);

				if (planet.showOrbit || parentObj.showOrbit) {
					model.g05.lineStyle(0.1, 0xffffff, .5);
					model.g05.drawCircle(parentObj.x, parentObj.y, planet.distanceFromParent + parentObj.radius);
					model.g05.endFill();
				}


			}
			/**/
			if (Utils.isInScreen(planet.x, planet.y, model.layers, stage) ||
				Utils.isInScreen(planet.x + planet.radius, planet.y, model.layers, stage) ||
				Utils.isInScreen(planet.x - planet.radius, planet.y, model.layers, stage) ||
				Utils.isInScreen(planet.x, planet.y + planet.radius, model.layers, stage) ||
				Utils.isInScreen(planet.x, planet.y - planet.radius, model.layers, stage)

			) {
				model.g1.drawCircle(planet.x, planet.y, planet.radius); // Draw the circle, assigning it a x position, y position, raidius.
				model.g1.endFill();
			}


			var p: Object;
			if (planet.orbitingPlanets) {
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++) {
					p = planet.orbitingPlanets[i];
					PlanetUtils.drawPlanet(model, stage, p, planet);
				}
			}

			if (planet.emitsLight) {

				LightUtils.handleLight(planet, model);

			}

			if (planet.rings) {
				var i;
				var j;
				var startDist: Number = planet.radius + (planet.radius * 0.4);
				for (i = 0; i < planet.rings.length; i++) {
					var color: uint = planet.rings[i];
					model.g05.lineStyle(0.1, color, .5);

					for (j = 0; j < 15; j++) {
						model.g05.drawCircle(planet.x, planet.y, startDist + j);
						model.g05.endFill();
					}
					startDist += j;
				}
			}
		}

	}

}