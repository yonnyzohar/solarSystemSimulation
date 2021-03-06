package {
	import flash.display.*;
	import flash.geom.*;

	public class Utils {
		private static var pool:Pool = Pool.getInstance();

		public function Utils() {
			// constructor code
		}

		public static function getSpeed(isMoon: Boolean = false): Number {
			var speed: Number = (Math.random() * 0.005) + 0.001;
			if (isMoon) {
				speed += (Math.random() * 0.05) + 0.01;
			}
			return speed;
		}

		public static function duplicate(o: Object): Object {
			var newO: Object = {};
			for (var k: String in o) {
				newO[k] = o[k];
			}
			return newO;
		}
	

		public static function setFollow(p: Entity, firstTime: Boolean, stage: Stage,model:Model): void {
			var l: Sprite = model.layers[1];
			var i: int = 0;
			////trace("hit ", p.name);
			for (i = 0; i < model.layers.length; i++) {
				l = model.layers[i];
				var fX: Number = 0;
				var fY: Number = 0;

				fX -= (p.x * model.currZoom);
				fY -= (p.y * model.currZoom);
				fX += (stage.stageWidth / 2); //
				fY += (stage.stageHeight / 2); //
				if(p is Planet)
				{
					Planet(p).showOrbit = true;
				}
				model.tweenTo = {
					planet: p,
					x: fX,
					y: fY,
					firstTime: firstTime
				};
			}
		}

		public static function isInScreen(p1X: Number, p1Y: Number, layers: Array, _stage: Stage): Boolean {
			var l: Sprite = layers[1];
			
			var point:Point = pool.get("point");
			point.x = p1X;
			point.y = p1Y;
			var localPos: Point = l.localToGlobal(point);
			pool.putBack(point, "point");
			var w: Number = _stage.stageWidth;
			var h: Number = _stage.stageHeight;
			if (localPos.x > 0 && localPos.x < w && localPos.y > 0 && localPos.y < h) {
				return true;
			} else {
				return false;
			}

		}
	
		

		public static function printObj(obj: AngledBody): String {
			var str: String = "left " + obj.left + " right " + obj.right + " dist " + obj.dist ;
			return str;
		}

		public static function getMapSize(model:Model, center:Planet): Object {
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

			var lr:Number = Math.max(Math.abs(left), right);
			var ud:Number = Math.max(Math.abs(top), btm);
			var m:Number = Math.max(lr,ud );


			var t:int = int(center.y - m);
			var b:int = int(center.y + m);

			var l:int = int(center.x - m);
			var r:int = int(center.x + m);

			return {
				left: l,
				right: r,
				top: t,
				btm: b,
				w: int(r - l),
				h: int(b - t)
			};
		}

		
	/*
		public static function drawCircle(_x: Number, _y: Number, rad: Number, color: uint = 0xffffff): void {
			dg.beginFill(color, 1);
			dg.drawCircle(_x, _y, rad); // Draw the circle, assigning it a x position, y position, raidius.
			dg.endFill();
		}
	*/

	}

}