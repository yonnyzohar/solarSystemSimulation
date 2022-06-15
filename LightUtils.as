package {
	import flash.display.Stage;

	public class LightUtils {

		public function LightUtils() {
			// constructor code
		}

		public static function handleLight(planet: Object, model:Model): void {
			var rad = planet.lightRad;
			var rings = 10;

			for (var i = 0; i < rings; i++) {
				var per = i / rings;
				model.gt.beginFill(planet.color, .05);
				model.gt.drawCircle(planet.x, planet.y, rad * per);
				model.gt.endFill();

			}



			var lightLineThickness: Number = 2;
			if (lightLineThickness < 1) {
				lightLineThickness = 1;
			}
			var lightAngleDelta: Number = planet.lightAngleDelta; //(Math.PI * 2)/(360/2 );


			model.g0.lineStyle(lightLineThickness, planet.color, 0.4);
			var angles: Array = [];

			//
			gatherAllPlanetPositions(angles, planet, model.allPlanets);

			var emptypSpaces = [];
			//sort the array and fix it to contain the accurate gaps so none are overlapping
			angles = addEntry1(angles, emptypSpaces, planet);

			sendBeams(angles, planet, lightLineThickness, model);


			//then emit to empty space
			sendBeams(emptypSpaces, planet, lightLineThickness, model)
		}

		public static function gatherAllPlanetPositions(angles: Array, planet: Object, arr: Array): void {
			var p: Object;
			for (var j: int = 0; j < arr.length; j++) {
				p = arr[j];

				if (p == planet) {
					continue;
				}
				//go over all planets and get their angle to the sun
				//get center angle, angle from left side and angle from right side
				//we need to t figure out if they are blocking planets behind them
				var centerAngleToSun: Number = MathUtils.fixAngle(MathUtils.getAngle(p.x, p.y, planet.x, planet.y));
				var distanceToSun: Number = MathUtils.getDistance(planet.x, planet.y, p.x, p.y);

				if (distanceToSun < planet.lightRad) {
					var leftAngle: Number = centerAngleToSun + (Math.PI / 2);
					var leftPointX: Number = (Math.cos(leftAngle) * p.radius) + p.x;
					var leftPointY: Number = (Math.sin(leftAngle) * p.radius) + p.y;

					//drawCircle(leftPointX, leftPointY, 2);

					var rightAngleToSun: Number = MathUtils.fixAngle(MathUtils.getAngle(leftPointX, leftPointY, planet.x, planet.y));

					var rigtAngle: Number = centerAngleToSun - (Math.PI / 2);
					var rightPointX: Number = (Math.cos(rigtAngle) * p.radius) + p.x;
					var rightPointY: Number = (Math.sin(rigtAngle) * p.radius) + p.y;

					//drawCircle(rightPointX, rightPointY, 2);

					var leftAngleToSun: Number = MathUtils.fixAngle(MathUtils.getAngle(rightPointX, rightPointY, planet.x, planet.y));

					if (leftAngleToSun > rightAngleToSun) {
						rightAngleToSun += (Math.PI * 2);
					}


					//trace(leftAngleToSun, centerAngleToSun, rightAngleToSun);

					var obj: Object = {
						left: Math.min(leftAngleToSun, rightAngleToSun),
						right: Math.max(leftAngleToSun, rightAngleToSun),
						dist: int(distanceToSun)
					}

					//addEntry(obj, angles)
					angles.push(obj);
				}



				if (p.orbitingPlanets) {
					gatherAllPlanetPositions(angles, planet, p.orbitingPlanets);
				}



			}
		}



		//emitLight(lightLineThickness, planetSurfaceX, planetSurfaceY, planet.x, planet.y, cos1, sin1, Math.min(a.dist, planet.lightRad), planet.lightRad, 0xffffff * Math.random(), baseLen);
		public static function emitLight(
	model:Model, 
	stage:Stage,
			lightLineThickness: Number,
			planetSurfaceX: Number,
			planetSurfaceY: Number,
			baseX: Number,
			baseY: Number,
			cos: Number,
			sin: Number,
			currentLightRad: Number,
			totalLightRad: Number,
			color: uint): void {

			model.g0.moveTo(planetSurfaceX, planetSurfaceY);

			var dpX: Number = baseX + cos * currentLightRad; //+ lightLineThickness)
			var dpY: Number = baseY + sin * currentLightRad; //+ lightLineThickness

			if (Utils.isInScreen(planetSurfaceX, planetSurfaceY, model.layers, stage) || Utils.isInScreen(dpX, dpY, model.layers, stage)) {
				model.g0.lineStyle(lightLineThickness, color, 0.5); //per * 0.6
				model.g0.lineTo(dpX, dpY);
			}
		}

		//now that we have all angles to the sun we need to fix them so none are overlapping
		//some may encapsulte others
		//others may combine to larger gaps
		//once we have this complete list we know how far to draw each ray of the sun
		//if we've made alterations to the array we need to do the algorithm again until we havs the 
		//accurate gaps array

		public static function addEntry1(arr: Array, empties: Array, planet: Object): Array {
			// this fort function sorts the array of planes angles into clusters. each cluster
			//meaning planets are touching each other
			arr.sortOn("left", Array.NUMERIC);
			var i: int = 0;
			//fill array with clusters
			var arrNum: int = -1;
			var bigArr: Array = [];
			var currMax = 0;
			var currMin = 0;
			var h = 0;

			for (i = 0; i < arr.length; i++) {
				var currP: Object = arr[i];
				var useNewArr = true;

				if (i == 0) {
					currMin = currP.left;
					currMax = currP.right;
				}

				//this means we have hit a new cluster
				if (currP.left > currMax) {
					bigArr.push([]);
					arrNum++;
					bigArr[arrNum].push(currP);
					currMin = currP.left;
					currMax = currP.right;
				} else {
					if (arrNum == -1) {
						arrNum = 0;
						bigArr[arrNum] = [];
					}
					bigArr[arrNum].push(currP);
					if (currP.right > currMax) {
						currMax = currP.right;
					}
				}
			}
			/*
			trace("before manipulations");
			for ( h = 0; h < bigArr.length; h++)
			{
				var a: Array = bigArr[h];
				for (var i: int = 0; i < a.length; i++)
				{
					var pp = a[i];
					trace(h + " debug l",pp.left,"r", pp.right, "d",pp.dist);
				}
			}*/

			//trace("fixing pverboard");
			//see if we went overboard
			//since 360 degress wraps around back to 0 we needs to make sure a planet that goes overboard from the last cluster
			//does not interfiere with cluster 0
			var smallestLeft = 0;
			var lastArr = bigArr[bigArr.length - 1];
			var lastElement = findBiggestRight(lastArr);
			if (lastElement.right > (Math.PI * 2)) {


				var r = lastElement.right - (Math.PI * 2);
				//trace("lastElement l",lastElement.left,"r", r, "d",lastElement.dist);
				for (var i = 0; i < bigArr[0].length; i++) {
					var element = bigArr[0][i];
					//trace("	element l",element.left,"r", element.right, "d",element.dist);
					if (element.left > r) {
						//trace("		element left is bigger than last right");
						break;
					}
					if (element.right < r) {
						//trace("		element right is smaller than last right");
						if (element.distance > lastElement.distance) {
							//trace("		element is farther");
							bigArr[0].splice(i, 1);
							if (bigArr[0].length == 0) {
								bigArr.shift();
								break;
							}
						} else {
							//element is closer
							var index = Math.max(i - 1, 0);
							//trace("		element is closer");
							bigArr[0].unshift({
								left: smallestLeft,
								right: element.left,
								dist: lastElement.dist
							});
							smallestLeft = element.right;
							i++; //to not get stick in a loop i guess
						}
					} else {
						//current element is bigger than 
						if (element.distance < lastElement.distance) {
							bigArr[0].unshift({
								left: smallestLeft,
								right: element.left,
								dist: lastElement.dist
							});
						} else {
							bigArr[0].unshift({
								left: smallestLeft,
								right: r,
								dist: lastElement.dist
							});
							element.left = r;
						}
						break;
					}

				}

			}

			/*
			for ( h = 0; h < bigArr.length; h++)
			{
				var a: Array = bigArr[h];
				trace(a.length);
				for (var i: int = 0; i < a.length; i++)
				{
					var pp = a[i];
					trace(h + " debug l",pp.left,"r", pp.right, "d",pp.dist);
				}
			}*/

			//debug



			//now that the list is sorted into clusters we can begin to sort out who is blocking whom
			//we construct a new list which takes blockins into account
			var tmp: Array = [];
			//now sort the clusters 
			for (h = 0; h < bigArr.length; h++) {
				tmp[h] = [];
				var a: Array = bigArr[h];
				var obj = {
					left: a[0].left,
					right: a[0].right,
					dist: a[0].dist
				};

				for (var i: int = 1; i < a.length; i++) {
					var currP: Object = a[i];

					//if obj is closer
					if (obj.dist < currP.dist) {
						//trace("obj "+printObj(obj)+" is closer than currP "+printObj(currP));
						//if obj ends before curr
						if (obj.right < currP.right) {
							//trace("	obj "+printObj(obj)+"right is less than currP right "+printObj(currP));
							obj.added = true;
							tmp[h].push(obj);
							obj = {
								left: obj.right,
								right: currP.right,
								dist: currP.dist
							}
						}
						if (obj.right >= currP.right) {
							//do nothing
						}
					} else {
						//trace("obj "+printObj(obj)+" is farther than currP "+printObj(currP));
						//obj is farther away
						//end obj at left 
						if (obj.right < currP.right) {
							//trace("	obj "+printObj(obj)+" right is less than currP right "+printObj(currP));
							//if obj is farther
							obj.right = currP.left;
							obj.added = true;
							tmp[h].push(obj);
							obj = {
								left: currP.left,
								right: currP.right,
								dist: currP.dist
							}
						} else if (obj.right >= currP.right) {
							//trace("	obj "+printObj(obj)+" right is more than currP right "+printObj(currP));
							var orig = {
								left: obj.left,
								right: obj.right,
								dist: obj.dist
							};
							obj.right = currP.left;
							obj.added = true;
							tmp[h].push(obj);
							obj = {
								left: currP.left,
								right: currP.right,
								dist: currP.dist,
								added: true
							}
							tmp[h].push(obj);

							obj = {
								left: currP.right,
								right: orig.right,
								dist: orig.dist
							}
						}
					}
				}
				if (obj.added != true) {
					tmp[h].push(obj);
				}
			}


			var o;
			for (h = 0; h < tmp.length; h++) {
				var a: Array = tmp[h];
				if (h == 0) {
					if (a[0].left != 0) {
						o = {
							left: 0,
							right: a[0].left,
							dist: planet.lightRad
						};
						empties.push(o);
						o = {
							left: a[a.length - 1].right,
							dist: planet.lightRad
						};
					} else {
						o = {
							left: a[a.length - 1].right,
							dist: planet.lightRad
						};
					}

				} else {
					o.right = a[0].left;
					empties.push(o);
					o = {
						left: a[a.length - 1].right,
						dist: planet.lightRad
					};

					if (h == tmp.length - 1) {
						o.right = Math.PI * 2;
						empties.push(o);
					}
				}
			}

			/**/
			//trace("output");
			var res = [];
			for (var b = 0; b < tmp.length; b++) {
				var a: Array = tmp[b];
				for (var i: int = 0; i < a.length; i++) {
					var pp = a[i];
					res.push(pp);
					//trace("l",pp.left,"r", pp.right, "d",pp.dist);
				}

			}

			return res;
		}

		public static function sendBeams(angles: Array, planet: Object, lightLineThickness: Number, model:Model): void {
			var lightAngleDelta: Number = planet.lightAngleDelta;
			var baseLen: Number = planet.radius;
			var a: Object;

			model.g0.lineStyle(0, planet.color, 0.5); //per * 0.6

			//first emit to all the planets
			//trace(angles.length);
			for (var h: int = 0; h < angles.length; h++) {
				a = angles[h];
				if (a) {
					model.g0.moveTo(planet.x, planet.y);
					model.g0.beginFill(planet.color);


					var cos: Number = Math.cos(a.left);
					var sin: Number = Math.sin(a.left);
					var dpX: Number = planet.x + cos * a.dist; //+ lightLineThickness)
					var dpY: Number = planet.y + sin * a.dist; //+ lightLineThickness
					model.g0.lineTo(dpX, dpY);

					cos = Math.cos(a.right);
					sin = Math.sin(a.right);
					dpX = planet.x + cos * a.dist; //+ lightLineThickness)
					dpY = planet.y + sin * a.dist; //+ lightLineThickness
					model.g0.lineTo(dpX, dpY);

					model.g0.lineTo(planet.x, planet.y);
					model.g0.endFill();

					/*
					for (var l: Number = a.left; l < a.right; l += lightAngleDelta)
					{

						

						
						var cos1: Number = Math.cos(l);
						var sin1: Number = Math.sin(l);
						var planetSurfaceX: Number = planet.x + (cos1 * baseLen);
						var planetSurfaceY: Number = planet.y + (sin1 * baseLen);

						//if (isInScreen(planetSurfaceX, planetSurfaceY)) 
						{
							emitLight(lightLineThickness, planetSurfaceX, planetSurfaceY, planet.x, planet.y, cos1, sin1, Math.min(a.dist, planet.lightRad), planet.lightRad, planet.color);//
						}
					}*/

				}
			}
		}


		public static function findBiggestRight(arr: Array): Object {
			var big = 0;
			var element = null;

			for (var i = arr.length - 1; i >= 0; i--) {
				var g = arr[i];

				if (g.right > big) {
					element = g;
					big = g.right;
				}
			}
			return element;
		}

	}

}