package {
	import flash.display.Stage;

	public class PlanetUtils {

		public function PlanetUtils() {
			// constructor code
		}

	
		public static function createPartition(model:Model, left:int, top:int):void
		{
			for (var i:int = 0; i < model.allPlanets.length; i++) {
				if(model.allPlanets[i] is Planet)
				{
					var planet: Planet = Planet(model.allPlanets[i]);
					var row:int = (planet.x - left) / Model.tileW;
					var col:int = (planet.y - top) / Model.tileH;
					var name:String = String(row) + "_" + String(col);
					if(!Model.partition[name])
					{
						Model.partition[name] = {};
					}
					Model.partition[name][planet.name] = planet;
				}
			}
		}

		public static function findNearestPlanet(model:Model, mx:Number, my:Number):Planet
		{
			
			var xPos: Number = mx; //(  ((stage.mouseX* currZoom) - l.x)  ); // l.x + -
			var yPos: Number = my; //(  ((stage.mouseY* currZoom) - l.y) ); //l.y + -
			var p: Planet;
			var found: Boolean = false;
			var i: int = 0;
			for (i = 0; i < model.allPlanets.length; i++) {
				if(model.allPlanets[i] is Planet) 
				{
					p = Planet(model.allPlanets[i]);
					if (MathUtils.getDistance(p.x, p.y, xPos, yPos) < p.radius) {
						found = true;
						return p;
					}
				}
				
			}
			return null;
			
		}

		public static function populatePlanetsARrr(planet: Planet,model:Model, stage:Stage): void
		{
			
			model.allPlanets.push(planet);
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					//this will make planets move slower if they are farther away
					var p: Planet = Planet(planet.orbitingPlanets[i]);
					
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