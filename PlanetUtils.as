package {
	import flash.display.Stage;

	public class PlanetUtils {

		public function PlanetUtils() {
			// constructor code
		}

		public static function addMoons(model:Model, stage:Stage): void
		{
			for (var i: int = 0; i < model.allPlanets.length; i++)
			{
				var planet: Object = model.allPlanets[i];
				if (planet.numMoons)
				{
					var dist: Number = 20;
					for (var j: int = 0; j < planet.numMoons; j++)
					{

						var moon: Object = {
							radius: (Math.random() * 10) + 4,
							color: 0xffffff * Math.random(),
							distanceFromParent: dist,
							angle: Math.random() * (Math.PI * 2),
							speed: Utils.getSpeed(true),
							name: "moon"
						}

						dist += (moon.radius * 2);

						planet.orbitingPlanets.push(moon);
					}
				}

			}
		}

		public static function populatePlanetsARrr(planet: Object,model:Model, stage:Stage): void
		{
			model.allPlanets.push(planet);
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					var p: Object = planet.orbitingPlanets[i];

					populatePlanetsARrr(p, model, stage);
				}
			}
		}


		public static function populateBGStars(model:Model, stage:Stage): void
		{
			model.gs.lineStyle(0.1, 0x000000);

			for (var i: int = 0; i < 100; i++)
			{
				var _x: Number = stage.stageWidth * Math.random();
				var _y: Number = stage.stageHeight * Math.random();
				model.gs.beginFill(0xffffff, 1);
				model.gs.drawCircle(_x, _y, 1); // Draw the circle, assigning it a x position, y position, raidius.
				model.gs.endFill();
			}
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