package {
	import flash.display.Stage;
	public class Planet extends Entity{

		public static var moonIndex:int = 0;
		public var distanceFromParent: Number;
		
		public var orbitingPlanets: Vector.<Entity> ;
		public var showOrbit: Boolean = false;
		public var numMoons: Number;
		public var isMoon:Boolean = false;
		
		public var rings: Array;
		//private var mc:PlanetMC ;

		

		public function Planet(_model:Model, _stage:Stage) {
			
			// constructor code
			super(_model, _stage);

		}

		public static function nextMoonIndex():int
		{
			Planet.moonIndex++;
			return Planet.moonIndex;
		}
		public function init(_radius:Number, _color:uint, _distanceFromParent:Number, _angle:Number, _name:String, _numMoons:Number = 0, _numRings:Number = 0):void
		{
			radius= _radius;
			color= _color;
			distanceFromParent= _distanceFromParent;
			angle= _angle;
			name= _name;
			numMoons = _numMoons;

			/*
			mc = new PlanetMC();
			var scale:Number = radius / (mc.width/2);
			trace("scale", scale);
			mc.scaleX *= scale;
			mc.scaleY *= scale;
			model.layer1.addChild(mc);
			mc.cacheAsBitmap = true;
			mc.visible = false;
*/
			if(_numRings > 0)
			{
				rings = [];

				for(var i:int = 0; i < _numRings; i++)
				{
					rings.push(Math.random() * 0xffffff);
				}
			}
			
			speed = (Model.maxDistance / distanceFromParent) * 0.000001;
		}

		override public function draw(parentObj: Planet = null): void {
			super.draw(parentObj);
			
			var i;
			var j;
			if (parentObj) {

				

				var cos: Number = Math.cos(angle) * (distanceFromParent + parentObj.radius);
				var sin: Number = Math.sin(angle) * (distanceFromParent + parentObj.radius);
				cos += parentObj.x;
				sin += parentObj.y;
				//trace("pre draw", x,y,angle);
				x = cos;
				y = sin;
		

				//trace("draw", name, x,y, parentObj.x, parentObj.y, angle, parentObj.radius);

				angle += speed;
				angle = MathUtils.fixAngle(angle);

				if (showOrbit || parentObj.showOrbit) {
					model.g05.lineStyle(0.1, 0xffffff, .5);
					model.g05.drawCircle(parentObj.x, parentObj.y, distanceFromParent + parentObj.radius);
					model.g05.endFill();
				}
				/**/


			}
			
			if (
				Utils.isInScreen(x, y, model.layers, stage) ||
				Utils.isInScreen(x + radius, y, model.layers, stage) ||
				Utils.isInScreen(x - radius, y, model.layers, stage) ||
				Utils.isInScreen(x, y + radius, model.layers, stage) ||
				Utils.isInScreen(x, y - radius, model.layers, stage)

			) {
				
				model.g1.beginFill(color, 1);
				model.g1.drawCircle(x, y, radius); // Draw the circle, assigning it a x position, y position, raidius.
				model.g1.endFill();

				if (rings) {
					var thickness:int = 10;
					var startDist: Number = radius + (radius * 0.4);
					for (i = 0; i < rings.length; i++) {
						var color: uint = rings[i];
						model.g05.lineStyle(thickness, color, .5);

						//for (j = 0; j < 15; j++) {
							model.g05.drawCircle(x, y, startDist);
							model.g05.endFill();
						//}
						startDist += thickness;
					}
				}
			}


			var p: Planet;
			if (orbitingPlanets) {
				for ( i = 0; i < orbitingPlanets.length; i++) {
					p = Planet(orbitingPlanets[i]);
					p.draw(this);
				}
			}
			/**/


			
		}

		public function addMoons(): void {
			if (numMoons) {
				if (!orbitingPlanets) {
					orbitingPlanets = new Vector.<Entity> ();
				}
				var dist: Number = radius + 20;
				for (var j: int = 0; j < numMoons; j++) {

					var moon: Planet = new Planet(model, stage);
					moon.radius = Math.max(radius * (Math.random() - 0.6), radius * 0.3);
					moon.color = 0xffffff * Math.random();
					moon.distanceFromParent = dist;
					moon.angle = Math.random() * (Math.PI * 2);
					moon.speed = (Model.maxDistance / moon.distanceFromParent) * 0.000001; //speed = Utils.getSpeed(true);
					moon.name = "moon" + Planet.nextMoonIndex();
					moon.isMoon = true;

					dist += (moon.radius * 4);

					orbitingPlanets.push(moon);
					model.allPlanets.push(moon);
				}
			}

		}

	}

}