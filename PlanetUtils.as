﻿package {
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
					if(!planet.orbitingPlanets)
					{
						planet.orbitingPlanets = new Vector.<Planet>() ;
					}
					var dist: Number = planet.radius + 20;
					for (var j: int = 0; j < planet.numMoons; j++)
					{

						var moon: Planet = new Planet();
						moon.radius= (Math.random() * 10) + 4;
						moon.color= 0xffffff * Math.random();
						moon.distanceFromParent= dist;
						moon.angle= Math.random() * (Math.PI * 2);
						moon.speed= Utils.getSpeed(true);
						moon.name= "moon";
						

						dist += (moon.radius * 4);

						planet.orbitingPlanets.push(moon);
					}
				}

			}
		}

		public static function populatePlanetsARrr(planet: Object,model:Model, stage:Stage): void
		{
			var maxDistance = 1000000
			model.allPlanets.push(planet);
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					//this will make planets move slower if they are farther away
					var p: Object = planet.orbitingPlanets[i];
					p.speed = (maxDistance / p.distanceFromParent) * 0.000001;
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


			var p:Planet;
			if (planet.orbitingPlanets) {
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++) {
					p = planet.orbitingPlanets[i];
					PlanetUtils.drawPlanet(model, stage, p, planet);
				}
			}

			if (planet is Star) {

				LightUtils.handleLight(Star(planet), model);
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