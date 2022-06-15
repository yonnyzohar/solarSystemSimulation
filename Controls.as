package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	public class Controls {

		var theStage: Stage;
		var model: Model;


		public function Controls(_stage: Stage, _model: Model) {
			model = _model;
			theStage = _stage;
			// constructor code
			_stage.addEventListener(Event.ENTER_FRAME, update);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_stage.addEventListener(MouseEvent.CLICK, onClick);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, zooom);
		}

		function onDown(event: MouseEvent): void {
			var l: Sprite = model.layers[1];
			//this is the offset in origin coords, at scale 1
			model.offsetX = (theStage.mouseX - l.x) / model.currZoom;
			model.offsetY = (theStage.mouseY - l.y) / model.currZoom;
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
			var localPosPre: Point = l.globalToLocal(new Point(theStage.mouseX, theStage.mouseY));
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
				if (model.currZoom <= 0.01) {
					model.currZoom = 0.01;
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
					l.x = theStage.mouseX - localPosPre.x * model.currZoom;
					l.y = theStage.mouseY - localPosPre.y * model.currZoom;

				}
			}

		}

		///////////////////////////---- controls -----/////////
		function onClick(event: MouseEvent): void {
			var l: Sprite = model.layers[1];
			var localPos: Point = l.globalToLocal(new Point(theStage.mouseX, theStage.mouseY));
			var xPos: Number = localPos.x; //(  ((stage.mouseX* currZoom) - l.x)  ); // l.x + -
			var yPos: Number = localPos.y; //(  ((stage.mouseY* currZoom) - l.y) ); //l.y + -
			var p: Object;
			var found: Boolean = false;
			var i: int = 0;
			for (i = 0; i < model.allPlanets.length; i++) {
				p = model.allPlanets[i];
				if (MathUtils.getDistance(p.x, p.y, xPos, yPos) < p.radius) {
					found = true;
					break;
				}
			}
			if (found) {
				model.txt.text = p.name;
				model.moonsTxt.text = "";
				if (p.numMoons) {
					model.moonsTxt.text = String(p.numMoons) + " Moons";
				}

				Utils.setFollow(p, true, theStage,model);

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
						Utils.setFollow(model.tweenTo.planet, false, theStage,model);
					}


				} else {
					var fX: Number = 0;
					var fY: Number = 0;

					fX -= (model.tweenTo.planet.x * model.currZoom);
					fY -= (model.tweenTo.planet.y * model.currZoom);
					fX += (theStage.stageWidth / 2); //
					fY += (theStage.stageHeight / 2); //
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
					var newX = theStage.mouseX - (model.offsetX * model.currZoom);
					var newY = theStage.mouseY - (model.offsetY * model.currZoom);
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


				}
			}
			var yonny = true;
			if (yonny) {
				//yonny = false;
				model.g0.clear();
				model.gt.clear();
				model.g05.lineStyle(0.1, 0x000000);
				model.g05.clear();
				model.g1.clear();
				model.g1.lineStyle(0.1, 0x000000);
				PlanetUtils.drawPlanet(model, theStage , model.sun);
			}

			//stage.removeEventListener(Event.ENTER_FRAME, update);
		}

	}

}