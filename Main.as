package
{
	import flash.display.*;
	 import flash.geom.*;
	import flash.events.*;

	public class Main extends MovieClip
	{
		var model:Model;
		var controls:Controls;


		public function Main()
		{
			
			// constructor code
			stage.align = "topLeft";
			model = new Model(stage);
			model.txt = txt;
			model.moonsTxt = moonsTxt;
			controls = new Controls(stage, model);
			
			txt.text = "";
			moonsTxt.text = "";

			
			for (var i: int = 0; i < model.layers.length; i++)
			{
				var l: Sprite = model.layers[i];
				stage.addChild(l);
				l.mouseChildren = false;
				l.mouseEnabled = false;
			}
		
			stage.addChild(model.debugLayer);
			stage.addChild(txt);
			stage.addChild(moonsTxt);
			model.layerT.mask = model.layer0;

			populatePlanetsARrr(model.sun);
			addMoons();
			populateBGStars();


			
		}

		function addMoons(): void
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

		


		function populatePlanetsARrr(planet: Object): void
		{
			model.allPlanets.push(planet);
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					var p: Object = planet.orbitingPlanets[i];

					populatePlanetsARrr(p);
				}
			}
		}






		





		function populateBGStars(): void
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