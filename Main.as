﻿package {
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;

	public class Main extends MovieClip {
		var model: Model;
		var lastPlanet: Planet = null;
		
		var yonny = true;

		var spaceShip1: SpaceShip;
		var spaceShip2: SpaceShip;
		var spaceShip3: SpaceShip;
		var spaceShip4: SpaceShip;
		

		public function Main() {

			// constructor code
			stage.align = "topLeft";
			model = new Model(stage);
			model.txt = txt;
			model.moonsTxt = moonsTxt;

			txt.text = "";
			moonsTxt.text = "";


			for (var i: int = 0; i < model.layers.length; i++) {
				var l: Sprite = model.layers[i];
				stage.addChild(l);
				l.mouseChildren = false;
				l.mouseEnabled = false;
			}

			stage.addChild(model.debugLayer);
			stage.addChild(txt);
			stage.addChild(moonsTxt);
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

			spaceShip1 = new SpaceShip(model, stage);
			spaceShip1.x = 0;
			spaceShip1.y = 0;
			model.allPlanets.push(spaceShip1);

			spaceShip2 = new SpaceShip(model, stage);
			spaceShip2.x = 0;
			spaceShip2.y = 0;
			model.allPlanets.push(spaceShip2);

			spaceShip3 = new SpaceShip(model, stage);
			spaceShip3.x = 0;
			spaceShip3.y = 0;
			model.allPlanets.push(spaceShip3);

			spaceShip4 = new SpaceShip(model, stage);
			spaceShip4.x = 0;
			spaceShip4.y = 0;

			model.allPlanets.push(spaceShip4);




		}

		

		function onDown(event: MouseEvent): void {
			var l: Sprite = model.layers[1];
			//this is the offset in origin coords, at scale 1
			model.offsetX = (stage.mouseX - l.x) / model.currZoom;
			model.offsetY = (stage.mouseY - l.y) / model.currZoom;
			model.mouseDown = true;
			if (model.tweenTo) {
				model.tweenTo.planet.showOrbit = false;
			}

			model.tweenTo = null;
			model.txt.text = "";
			model.moonsTxt.text = "";
		}

		function onUp(event: MouseEvent): void {
			model.mouseDown = false;
		}

		function zooom(event: MouseEvent): void {
			var l: Sprite = model.layers[1];
			//this is the mouse position at current scale inside 
			var localPosPre: Point = l.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			//drawCircle(localPosPre.x, localPosPre.y, 10, 0x00cc00);
			if (model.tweenTo) {
				model.tweenTo.planet.showOrbit = false;
			}




			model.tweenTo = null;
			model.txt.text = "";
			model.moonsTxt.text = "";
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
		function onClick(event: MouseEvent): void {
			var l: Sprite = model.layers[1];
			var localPos: Point = l.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			var p: Planet = PlanetUtils.findNearestPlanet(model, localPos.x, localPos.y);
			if (p) {
				model.txt.text = p.name;
				model.moonsTxt.text = "";
				if (p.numMoons) {
					model.moonsTxt.text = String(p.numMoons) + " Moons";
				}

				//spaceShip.moveTo(p);

				Utils.setFollow(p, true, stage, model);
			}

		}

		function update(e: Event): void {
			var i: int = 0;
			var l: Sprite;


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
						if (i == 0) {
							//l.x -= deltaX * 0.1;
							//l.y -= deltaY * 0.1;
						} else {
							l.x = newX;
							l.y = newY;
						}
					}

					model.prevX = l.x;
					model.prevY = l.y;


				} else {
					var l: Sprite = model.layers[1];
					var localPos: Point = l.globalToLocal(new Point(stage.mouseX, stage.mouseY));
					var p: Planet = PlanetUtils.findNearestPlanet(model, localPos.x, localPos.y);
					if (p && p != lastPlanet) {
						model.txt.text = p.name;
						model.moonsTxt.text = "";
						if (p.numMoons) {
							model.moonsTxt.text = String(p.numMoons) + " Moons";
						}
					} else {
						if (p == null && lastPlanet != null) {
							model.txt.text = "";
							model.moonsTxt.text = "";
						}

					}

					lastPlanet = p;
				}
			}

			
			model.g0.clear();
			model.g05.lineStyle(0.1, 0x000000);
			model.g05.clear();
			model.g1.clear();
			model.g1.lineStyle(0.1, 0x000000);

			try {
				spaceShip1.draw();
				spaceShip2.draw();
				spaceShip3.draw();
				spaceShip4.draw();
				model.sun.draw();

			} catch (e: Error) {
				trace(e.message);
				stage.removeEventListener(Event.ENTER_FRAME, update);
			}
		
		if (yonny) {
				//trace("");
				yonny = false;

			}

			//PlanetUtils.drawPlanet(model, stage, model.sun);

		}

		
	}

}


/*

function getMapSize(): Object {
			var left: Number = 100000000;
			var right: Number = -100000000;
			var top: Number = 1000000000;
			var btm: Number = -1000000000;

			for (var i: int = 0; i < model.allPlanets.length; i++) {
				var e: Entity = model.allPlanets[i];
				//trace(e.x);
				if (e.x < left) {
					left = e.x;
				}
				if (e.x > right) {
					right = e.x;
				}
				if (e.y < top) {
					top = e.y;
				}
				if (e.y > btm) {
					btm = e.y;
				}
			}
			return {
				left: int(left),
				right: int(right),
				top: int(top),
				btm: int(btm),
				w: int(right - left),
				h: int(btm - top)
			};
		}


				var map: Array = [
				
					[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
					[0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
					[0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
					[0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
					[0, 0, 0, 0, 0, 1, 1, 1, 0, 0],
					[0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
					[0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
					[0, 1, 0, 0, 0, 0, 1, 1, 0, 0],
					[0, 1, 0, 0, 0, 0, 1, 1, 0, 0],
					[0, 1, 0, 0, 0, 0, 0, 1, 0, 0]
					
				];

				var mapSize: Object = getMapSize();
				
				var size:int = Math.max(mapSize.w, mapSize.h);
				var tilesPerRow:int = size / Model.tileSize;
				for(var i:int = 0; i < tilesPerRow; i++)
				{
					map.push([]);
					for(var j:int = 0; j < tilesPerRow; j++)
					{
						map[i][j] = 0;
					}
				}

				for (i = 0; i < model.allPlanets.length; i++) {
					var e1: Entity = model.allPlanets[i];
					var _x = int(e1.x);
					var _y = int(e1.y);
					var radius:int = e1.radius;
					var numTiles:int = radius / Model.tileSize;
					var col:int = (_x - mapSize.left) / Model.tileSize;
					var row:int = (_y - mapSize.top) / Model.tileSize;

					for(var r:int = row - numTiles; r < row + numTiles; r++)
					{
						for(var c:int = col - numTiles; c < col + numTiles; c++)
						{
							if(map[r] != null && map[r][c] != null)
							{
								map[r][c] = 1;
							}
						}
					}
					
				}
			
				
				trace(mapSize.left, mapSize.right, mapSize.top, mapSize.btm, mapSize.w, mapSize.h);
				var grid: Array = aStar.createNodesBoard(map, 0);
				var startNode: Object = grid[0][0];
				var endNode: Object = grid[tilesPerRow-1][tilesPerRow-1];

				var pathList: Array = aStar.getPath(grid, startNode, endNode);
				aStar.printPath(map, pathList);
				*/