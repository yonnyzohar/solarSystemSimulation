package  {
	import flash.display.Stage;
	import flash.utils.*;
	import flash.events.Event;

	public class SpaceShip extends Entity{
		
		public var attachedPlanet:Planet;
		private var moveObj:Object;
		var distanceFromParent:Number;
		var currPlanet:Planet;
		private var mc:ShipMC;
		private var smokePool:Pool = Pool.getInstance();
		var smokeCounter:int = 0;

		public function SpaceShip(_model:Model, _stage:Stage) {
			super(_model, _stage);
			
			color = 0xffffff * Math.random();
			radius = 20;
			speed = 5;
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
							if(!p.isMoon)
							{
								moveTo(p);
								found = true;
								return;
							}
							
						}
					}
					

				}
				

				}, time)
		}




		public function moveTo(p:Planet):void
		{
			//trace("going to " + p.name);
			smokeCounter = 0;
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
				smokeCounter++;
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
				var num:int = 0;

				

				var row:int = (x - Model.mapLeft) / Model.tileW;
				var col:int = (y - Model.mapTop) / Model.tileH;
				
				for(var r:int = -1; r <= 1; r++)
				{
					for(var c:int = -1; c <= 1; c++)
					{
						var name:String = String(row+r) + "_" + String(col+c);
						var block:Object = Model.partition[name];
						if(block)
						{
							for(var k:String in block)
							{
								var e:Entity = block[k];
								if(e is Planet)
								{
									var p:Planet = Planet(e);
									if(p != myP)
									{
										var rad:Number = p.radius;
										var d:Number = MathUtils.getDistance(x, y, p.x, p.y);
										var sAngle:Number = MathUtils.getAngle(x, y, p.x, p.y );
										var cos:Number = Math.cos(sAngle);
										var sin:Number = Math.sin(sAngle);
										num++;
										var mag:Number = 100;
										if(p.isMoon)
										{
											mag = 0.1;
										}
										fX -= ((cos * speed)  / (d - rad)) * mag ;//
										fY -= ((sin * speed)  / (d - rad)) * mag ; // 
									}
								}

							}
						}
					}
				}
				
				/**/
				
				

				//now move me
				///////////////////////
				/*
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
							num++;
							fX -= ((c * speed)  / (d - rad)) * 100 ;//
							fY -= ((s * speed)  / (d- rad )) * 100 ; // 
						}
					}
				}*/

				//trace(num);

				///////////////////////

				//trace(fX, fY);
				nextX -= fX;
				nextY -= fY;

				var sAngle:Number = MathUtils.getAngle(nextX, nextY, x, y) * 180 / Math.PI;

				y = nextY;
				x = nextX;
				if(smokeCounter % 4 == 0)
				{
					var smoke:Smoke = Smoke(smokePool.get("smoke"));
					smoke.gotoAndPlay(1);
					model.layer1.addChild(smoke);
					smoke.x = x;
					smoke.y = y;
					smoke.play();
					smoke.addEventListener("EndOfAnimation", onStep1Complete);
				}
				
				

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

		private function onStep1Complete(event:Event=null):void
		{
			var smoke:Smoke = Smoke(event.target);
			smoke.removeEventListener("EndOfAnimation", onStep1Complete);
			model.layer1.removeChild(smoke);
			smokePool.putBack(smoke, "smoke");
		}

	}
	
}
