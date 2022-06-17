package  {
	import flash.display.Stage;
	import flash.utils.*;

	public class SpaceShip extends Entity{
		
		public var attachedPlanet:Planet;
		private var moveObj:Object;
		var distanceFromParent:Number;
		var currPlanet:Planet;
		private var mc:ShipMC;

		public function SpaceShip(_model:Model, _stage:Stage) {
			super(_model, _stage);
			
			color = 0xffffff * Math.random();
			radius = 20;
			speed = 10;
			mc = new ShipMC();
			mc.x = x;
			mc.y = y;
			model.layer1.addChild(mc);
			mc.fireMC.visible = false;

			findTarget(true);


		}

		function findTarget(immidiate:Boolean = false):void
		{
			var time:Number = Math.random() * 15;
			time += 2;
			time *= 1000;
			if(immidiate)
			{
				time = 0;
			}

			setTimeout(function():void
			{
				var found:Boolean = false;
				while(!found)
				{
					var rnd:int = Math.random() * model.allPlanets.length;
					if(model.allPlanets[rnd] is Planet)
					{
						var p:Planet = Planet(model.allPlanets[rnd]);
						if(currPlanet != p)
						{
							moveTo(p);
							found = true;
							return;
						}
					}
					

				}
				

				}, time)
		}




		public function moveTo(p:Planet):void
		{
			trace("going to " + p.name);
			var w:Number = p.x - x;
			var h:Number = p.y - y;
			var distance:Number = MathUtils.getDistance(x, y, p.x, p.y);
			var vx:Number = w / distance;
			var vy:Number = h / distance;
			currPlanet = null;
			mc.fireMC.visible = true;
			moveObj = {
				destX: p.x,
				destY: p.y,
				vx : vx,
				vy : vy,
				radius : p.radius,
				p : p

			};


		}

		public function draw(parentObj: Planet = null): void {
			//model.g1.beginFill(color, 1);
			var i;
			var j;

			if(moveObj)
			{
				var myP:Planet = moveObj.p
				var w:Number = myP.x - x;
				var h:Number = myP.y - y;
				var distance:Number = MathUtils.getDistance(x, y, myP.x, myP.y);
				var orbit:Number = (myP.radius  + (myP.radius * 0.5));
				if(distance <= orbit )
				{
					moveObj = null;
					mc.fireMC.visible = false;
					angle = MathUtils.getAngle( x, y,myP.x, myP.y);
					distanceFromParent = orbit;
					currPlanet = myP;	
					findTarget();
					return;
				}

				moveObj.vx = w / distance;
				moveObj.vy = h / distance;

				var nextX:Number = x + moveObj.vx * speed;
				var nextY:Number = y + moveObj.vy * speed;

				var fX:Number = 0;
				var fY:Number = 0;

				//now move me
				for(var i:int = 0; i < model.allPlanets.length; i++)
				{
					if(model.allPlanets[i] is Planet)
					{
						var p:Planet = Planet(model.allPlanets[i]);
						if(p != myP)
						{
							var rad:Number = p.radius;
							var d:Number = MathUtils.getDistance(x, y, p.x, p.y);
							var sAngle:Number = MathUtils.getAngle(x, y, p.x, p.y );
							var c:Number = Math.cos(sAngle);
							var s:Number = Math.sin(sAngle);

							fX -= ((c * speed)  / (d - rad)) * 100 ;//
							fY -= ((s * speed)  / (d- rad )) * 100 ; // 
							

						}
					}
					
				}

				//trace(fX, fY);
				nextX -= fX;
				nextY -= fY;

				var sAngle:Number = MathUtils.getAngle(nextX, nextY, x, y) * 180 / Math.PI;

				y = nextY;
				x = nextX;	
				mc.x = x;
				mc.y = y;	
				mc.rotation = sAngle;
			}
			if (currPlanet) {

				
				var cos: Number = Math.cos(angle) * (distanceFromParent );
				var sin: Number = Math.sin(angle) * (distanceFromParent );
				cos += currPlanet.x;
				sin += currPlanet.y;
				//trace("pre draw", x,y,angle);
				x = cos;
				y = sin;
				mc.x = x;
				mc.y = y;
				angle += (speed * 0.001);
				angle = MathUtils.fixAngle(angle);
				mc.rotation = (angle + (Math.PI / 2)) * 180 / Math.PI;
				/**/

			}
			/*
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
			*/
		}

	}
	
}
