package {
	import flash.display.Stage;

	public class PlanetUtils {

		public function PlanetUtils() {
			// constructor code
		}

		

		public static function populatePlanetsARrr(planet: Planet,model:Model, stage:Stage): void
		{
			
			model.allPlanets.push(planet);
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					//this will make planets move slower if they are farther away
					var p: Planet = planet.orbitingPlanets[i];
					
					//speed: Utils.getSpeed()
					//distanceFromParent

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

		

	}

}