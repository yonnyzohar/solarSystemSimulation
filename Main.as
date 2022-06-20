//pool for angles :)
//pool for trail :)
//space partition for planets :)

package {
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.getTimer;


	public class Main extends MovieClip {
		var model: Model;
		var lastPlanet: Entity = null;
		var yonny = true;
		var spaceShips: Array = [];
		var mouseCounter:int =0;
		var pool:Pool = Pool.getInstance();
		var fps:FPSDemo = new FPSDemo();
		

		public function Main() {

			// constructor code
			stage.align = "topLeft";
			model = new Model(stage);
			model.txt = txt;
			model.moonsTxt = moonsTxt;

			txt.text = "";
			moonsTxt.text = "";


			for (var i: int = 0; i < model.layers.length; i++) 
			{
				var l: Sprite = model.layers[i];
				stage.addChild(l);
				l.mouseChildren = false;
				l.mouseEnabled = false;
			}

			stage.addChild(txt);
			stage.addChild(moonsTxt);
			stage.addChild(fpsTxt);
			model.layerT.mask = model.layer0;

			PlanetUtils.populatePlanetsARrr(model.sun, model, stage);

			for (var i: int = 0; i < model.allPlanets.length; i++) {
				var planet: Planet = Planet(model.allPlanets[i]);
				planet.addMoons();
			}
			PlanetUtils.populateBGStars(model, stage);

			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, zooom);
			
			
			pool.init(model.allPlanets.length * 50, AngledBody, "angle", function(ent:*):void{ent.reset();});
			pool.init(100, Point, "point");

			model.sun.draw();

			var obj:Object = Utils.getMapSize(model, model.sun);
			Model.mapW = obj.w;
			Model.mapH = obj.h;
			Model.mapLeft = obj.left;
			Model.mapTop = obj.top;

			//if want to split the map up to 4 X 4
			var n:int = 4;
			Model.tileW = Model.mapW / n;
			Model.tileH = Model.mapH / n;

			

			PlanetUtils.createPartition(model, Model.mapLeft, Model.mapTop);

			//_numElements : int, _CLS:Class, type:String
			pool.init(50 * Model.numShips, Smoke, "smoke", function(ent:*):void{ent.stop();});
			
			//place ships randomly in spots where they dont smash into planets
			for(var i:int = 0; i < Model.numShips; i++)
			{
				var s:SpaceShip = new SpaceShip(model, stage);
				var found:Boolean = false;
				while(!found)
				{
					var _x:Number = Math.random() * Model.mapW + Model.mapLeft;
					var _y:Number = Math.random() * Model.mapH + Model.mapTop;
					for(var j:int = 0; j < model.allPlanets.length; j++)
					{
						if(model.allPlanets[j] is Planet)
						{
							var p:Planet = Planet(model.allPlanets[j]);
							var rad:Number = p.radius;
							var d:Number = MathUtils.getDistance(_x, _y, p.x, p.y);
							if(d > rad + s.radius)
							{
								s.x =  _x;
								s.y =  _y;
								model.allPlanets.push(s);
								spaceShips.push(s);
								found = true;
								break;
							}

						}
					}
				}
			}

		}

		function releaseTween():Boolean
		{
			if (model.tweenTo) {
				if(model.tweenTo.planet is Planet)
				{
					Planet(model.tweenTo.planet).showOrbit = false;
				}
				model.tweenTo = null;
				model.txt.text = "";
				model.moonsTxt.text = "";
				return true;
			}
			return false;
		}

		function onClick(event: MouseEvent): void {
			
			
		}
		

		function onDown(event: MouseEvent): void {
			mouseCounter = 0;
			var l: Sprite = model.layers[1];
			//this is the offset in origin coords, at scale 1
			model.offsetX = (stage.mouseX - l.x) / model.currZoom;
			model.offsetY = (stage.mouseY - l.y) / model.currZoom;
			model.mouseDown = true;

			
		}

		function onUp(event: MouseEvent): void {
			model.mouseDown = false;
			releaseTween();
			if(mouseCounter < 10)
			{
				var l: Sprite = model.layers[1];
				var point:Point = pool.get("point");
				point.x = stage.mouseX;
				point.y = stage.mouseY;
				var localPos: Point = l.globalToLocal(point);
				pool.putBack(point, "point");
				var p: Entity = PlanetUtils.findNearestPlanet(model, localPos.x, localPos.y);
				if (p) {
					model.txt.text = p.name;
					model.moonsTxt.text = "";
					if(p is Planet)
					{
						if (Planet(p).numMoons) {
							model.moonsTxt.text = String(Planet(p).numMoons) + " Moons";
						}

					}
					
					//spaceShip.moveTo(p);

					Utils.setFollow(p, true, stage, model);
				}
			}
		}

		function zooom(event: MouseEvent): void {
			var l: Sprite = model.layers[1];
			var point:Point = pool.get("point");
			point.x = stage.mouseX;
			point.y = stage.mouseY;
			//this is the mouse position at current scale inside 
			var localPosPre: Point = l.globalToLocal(point);
			pool.putBack(point, "point");
			//drawCircle(localPosPre.x, localPosPre.y, 10, 0x00cc00);
			var proceed: Boolean = true;
			if (event.delta > 0) {
				model.currZoom += model.zoomAmount;
			} else if (event.delta < 0) {
				model.currZoom -= model.zoomAmount;
				if (model.currZoom <= 0.1) {
					model.currZoom = 0.1;
					proceed = false;
				}
			}

			//txt.text = String(event.delta);

			if (!proceed) {
				return;
			}


			var i: int = 0;


			for (i = 0; i < model.layers.length; i++) {
				l = model.layers[i];

				if (i != 0) {
					l.scaleX = model.currZoom;
					l.scaleY = model.currZoom;
				}
			}


			for (i = 0; i < model.layers.length; i++) {
				l = model.layers[i];

				if (i != 0) {
					l.x = stage.mouseX - localPosPre.x * model.currZoom;
					l.y = stage.mouseY - localPosPre.y * model.currZoom;
				}
			}

		}



		///////////////////////////---- controls -----/////////
		

		function update(e: Event): void {
			var i: int = 0;
			var l: Sprite;
			mouseCounter++;
			

			if (model.tweenTo != null) {

				if (model.tweenTo.firstTime) {
					l = model.layers[1];
					var dX: Number = ((model.tweenTo.x - l.x) / 2);
					var dY: Number = ((model.tweenTo.y - l.y) / 2);

					for (i = 0; i < model.layers.length; i++) {
						l = model.layers[i];
						if (i != 0) {

							l.x += dX;
							l.y += dY;

						}
					}

					if (MathUtils.getDistance(l.x, l.y, model.tweenTo.x, model.tweenTo.y) < 0.5) {
						Utils.setFollow(model.tweenTo.planet, false, stage, model);
					}


				} else {
					var fX: Number = 0;
					var fY: Number = 0;

					fX -= (model.tweenTo.planet.x * model.currZoom);
					fY -= (model.tweenTo.planet.y * model.currZoom);
					fX += (stage.stageWidth / 2); //
					fY += (stage.stageHeight / 2); //
					for (i = 0; i < model.layers.length; i++) {
						l = model.layers[i];
						if (i != 0) {

							l.x = fX;
							l.y = fY;
						}
					}
				}

			} else {
				if (model.mouseDown) {
					var l: Sprite = model.layers[1];
					//this is absolute position in scene, scaled
					var newX = stage.mouseX - (model.offsetX * model.currZoom);
					var newY = stage.mouseY - (model.offsetY * model.currZoom);
					for (i = 0; i < model.layers.length; i++) {
						l = model.layers[i];
						if (i != 0) {
							l.x = newX;
							l.y = newY;
						}
					}

					model.prevX = l.x;
					model.prevY = l.y;


				} else {
					
					var l: Sprite = model.layers[1];
					var point:Point = pool.get("point");
					point.x = stage.mouseX;
					point.y = stage.mouseY;

					var localPos: Point = l.globalToLocal(point);
					pool.putBack(point, "point");
					var p: Entity = PlanetUtils.findNearestPlanet(model, localPos.x, localPos.y);
					if (p && p != lastPlanet) {
						model.txt.text = p.name;
						model.moonsTxt.text = "";
						if(p is Planet)
						{
							if (Planet(p).numMoons) {
								model.moonsTxt.text = String(Planet(p).numMoons) + " Moons";
							}
						}
						
						
					} else {
						if (p == null && lastPlanet != null) {
							model.txt.text = "";
							model.moonsTxt.text = "";
						}

					}

					lastPlanet = p;
					/**/
				}
			}

			if (yonny) 
			{
				//trace("");
				//yonny = false;
				
				model.g0.clear();
				model.g05.lineStyle(0.1, 0x000000);
				model.g05.clear();
				model.g1.clear();
				model.g1.lineStyle(0.1, 0x000000);

				//drawTiles();
				 
				for(var i:int = 0; i < spaceShips.length; i++)
				{
					var s:SpaceShip = spaceShips[i];
					s.draw();
				}
				model.sun.draw();
				//stage.removeEventListener(Event.ENTER_FRAME, update);
				//

				try {

				} 
				catch (e: Error) {
					trace(e.message);
				}
				
			}

			fps.checkFPS(fpsTxt);
		}

		function drawTiles():void
		{
			model.dg.clear();
			model.dg.lineStyle(0.1, 0x000000);

			for(var k:String in Model.partition)
			{
				var obj:Object = Model.partition[k];
				if(obj.numPlanets > 0)
				{
					var row:int = obj.row;
					var col:int = obj.col;
					var color:uint = obj.color;
					//trace("color", color);
					model.dg.beginFill(color, 1);
					model.dg.drawRect((col * Model.tileW) + Model.mapLeft, (row * Model.tileH) + Model.mapTop, Model.tileW , Model.tileH );
					model.dg.endFill();
				}
				
			}


		}

		
	}

}

