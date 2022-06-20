package {
	import flash.display.Stage;
	public class Star extends Planet {

		public var lightRad: Number;
		private var firstTime:Boolean = true;
		private var pool:Pool = Pool.getInstance();

		public function Star(_model: Model, _stage: Stage) {
			super(_model, _stage);
			// constructor code
		}

		override public function draw(parentObj: Planet = null): void {
			super.draw(parentObj);
			pool.clear("angle");
			handleLight();
		}

		

		public function handleLight(): void {

			if(firstTime)
			{
				model.gt.clear();
				//firstTime = false;
				var light_rings = 10;

				for (var i = 0; i < light_rings; i++) {
					var per = i / light_rings;
					if (i != light_rings - 1) {
						model.gt.beginFill(color,.05); //
						model.gt.drawCircle(x, y, lightRad * per);
						model.gt.endFill();
					}
				}
				//model.layerT.cacheAsBitmap = true;
			}

			

			var lightLineThickness: Number = 6;
			

			//model.g0.lineStyle(lightLineThickness, color, 0.4);
			var angles: Array =[];

			//
			gatherAllPlanetPositions(angles, model.allPlanets, true);
			//////trace("angles before manipulations",angles.length );

			var emptypSpaces = [];
			//sort the array and fix it to contain the accurate gaps so none are overlapping
			angles = addEntry1(angles, emptypSpaces);
			//////trace("angles after manipulations",angles.length );

			sendBeams(angles,  lightLineThickness,  false);


			//then emit to empty space
			sendBeams(emptypSpaces, lightLineThickness, true)
		}

		public function gatherAllPlanetPositions(angles: Array, allPlanets: Vector.<Entity> , topHeirarchy:Boolean = false): void {
			var p: Entity;
			//////trace("gatherAllPlanetPositions",allPlanets.length );
			for (var j: int = 0; j < allPlanets.length; j++) {
				p = Entity(allPlanets[j]);
				//////trace("checking", p.name);

				if (p == this) {
					//////trace("skipping", name);
					continue;
				}


				//go over all planets and get their angle to the sun
				//get center angle, angle from left side and angle from right side
				//we need to t figure out if they are blocking planets behind them
				var centerAngleToSun: Number = MathUtils.fixAngle(MathUtils.getAngle(p.x, p.y, x, y));
				//////trace("shit",x, y, p.x, p.y);
				var distanceToSun: Number = MathUtils.getDistance(x, y, p.x, p.y);
				//////trace("distanceToSun",distanceToSun,"lightRad",lightRad);
				if (distanceToSun < lightRad) {
					var leftAngle: Number = centerAngleToSun + (Math.PI / 2);
					var leftPointX: Number = (Math.cos(leftAngle) * p.radius) + p.x;
					var leftPointY: Number = (Math.sin(leftAngle) * p.radius) + p.y;

					//drawCircle(leftPointX, leftPointY, 2);

					var rightAngleToSun: Number = MathUtils.fixAngle(MathUtils.getAngle(leftPointX, leftPointY, x, y));

					var rigtAngle: Number = centerAngleToSun - (Math.PI / 2);
					var rightPointX: Number = (Math.cos(rigtAngle) * p.radius) + p.x;
					var rightPointY: Number = (Math.sin(rigtAngle) * p.radius) + p.y;

					//drawCircle(rightPointX, rightPointY, 2);

					var leftAngleToSun: Number = MathUtils.fixAngle(MathUtils.getAngle(rightPointX, rightPointY, x, y));

					if (leftAngleToSun > rightAngleToSun) {
						rightAngleToSun += (Math.PI * 2);
					}


					////trace(leftAngleToSun, centerAngleToSun, rightAngleToSun);

					var obj: AngledBody = pool.get("angle");
					obj.left =  Math.min(leftAngleToSun, rightAngleToSun);
					obj.right= Math.max(leftAngleToSun, rightAngleToSun);
					obj.dist= int(distanceToSun);
					

					//addEntry(obj, angles)
					//////trace("adding angle object");
					angles.push(obj);
				}

				//if (p is Planet && Planet(p).orbitingPlanets) {
					//////trace("has moons");
					//gatherAllPlanetPositions(angles, Planet(p).orbitingPlanets, false);
				//}
			}
		}

		//now that we have all angles to the sun we need to fix them so none are overlapping
		//some may encapsulte others
		//others may combine to larger gaps
		//once we have this complete list we know how far to draw each ray of the sun
		//if we've made alterations to the array we need to do the algorithm again until we havs the 
		//accurate gaps array

		public function addEntry1(arr: Array, empties: Array): Array {
			// this fort function sorts the array of planes angles into clusters. each cluster
			//meaning planets are touching each other
			////trace("addEntry1", arr.length );
			arr.sortOn("left", Array.NUMERIC);
			var i: int = 0;
			//fill array with clusters
			var arrNum: int = -1;
			var bigArr: Array = [];
			var currMax = 0;
			var currMin = 0;
			var currP: AngledBody;
			var h = 0;
			var obj: AngledBody;

			for (i = 0; i < arr.length; i++) {
				currP = arr[i];
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
			
			//trace("before manipulations");
			
			for ( h = 0; h < bigArr.length; h++)
			{
				var a: Array = bigArr[h];
				for (i = 0; i < a.length; i++)
				{
					var pp:AngledBody = a[i];
					////trace(h + " debug l",pp.left,"r", pp.right, "d",pp.dist);
				}
			}/**/

			////trace("fixing pverboard");
			//see if we went overboard
			//since 360 degress wraps around back to 0 we needs to make sure a planet that goes overboard from the last cluster
			//does not interfiere with cluster 0
			var smallestLeft = 0;
			//////trace("bigArr",bigArr.length);
			var lastArr = bigArr[bigArr.length - 1];
			
			var lastElement = findBiggestRight(lastArr);
			if (lastElement.right > (Math.PI * 2)) {


				var r = lastElement.right - (Math.PI * 2);
				//trace("lastElement l",lastElement.left,"r", r, "d",lastElement.dist);
				for ( i = 0; i < bigArr[0].length; i++) {
					var element:AngledBody = bigArr[0][i];
					//trace("	element l",element.left,"r", element.right, "d",element.dist);
					if (element.left > r) {
						////trace("		element left is bigger than last right");
						break;
					}
					if (element.right < r) {
						//trace("		element right is smaller than last right");
						if (element.dist > lastElement.dist){
							////trace("		element is farther");
							bigArr[0].splice(i, 1);
							if (bigArr[0].length == 0) {
								bigArr.shift();
								break;
							}
						} else {
							//element is closer
							var index = Math.max(i - 1, 0);
							//trace("		element is closer");

							 obj = pool.get("angle");
							obj.left =  smallestLeft;
							obj.right= element.left;
							obj.dist= lastElement.dist;

							bigArr[0].unshift(obj);
							smallestLeft = element.right;
							i++; //to not get stick in a loop i guess
						}
					} else {
						//current element is bigger than 
						if (element.dist < lastElement.dist) {

							obj = pool.get("angle");
							obj.left =  smallestLeft;
							obj.right= element.left;
							obj.dist= lastElement.dist;


							bigArr[0].unshift(obj);
						} else {

							obj = pool.get("angle");
							obj.left =  smallestLeft;
							obj.right= r;
							obj.dist= lastElement.dist;

							bigArr[0].unshift(obj);
							element.left = r;
						}
						break;
					}

				}

			}
			
			for ( h = 0; h < bigArr.length; h++)
			{
				var a: Array = bigArr[h];
				for (i = 0; i < a.length; i++)
				{
					var pp:AngledBody = a[i];
					//trace(h + " debug l",pp.left,"r", pp.right, "d",pp.dist);
				}
			}/**/

			//now that the list is sorted into clusters we can begin to sort out who is blocking whom
			//we construct a new list which takes blockins into account
			var tmp: Array = [];
			//now sort the clusters 
			for (h = 0; h < bigArr.length; h++) {
				tmp[h] = [];
				var a: Array = bigArr[h];
				obj = pool.get("angle");
				obj.left =  a[0].left;
				obj.right= a[0].right;
				obj.dist = a[0].dist;

				

				for ( i = 1; i < a.length; i++) {
					currP = a[i];

					//if obj is closer
					if (obj.dist < currP.dist) {
						//trace("obj "+Utils.printObj(obj)+" is closer than currP "+Utils.printObj(currP));
						//if obj ends before curr
						if (obj.right < currP.right) {
							////trace("	obj "+Utils.printObj(obj)+" right is less than currP right "+Utils.printObj(currP));
							obj.added = true;
							var r = obj.right;
							tmp[h].push(obj);
							obj = pool.get("angle");
							obj.left =  r;
							obj.right= currP.right;
							obj.dist= currP.dist;
							////trace("1 "+Utils.printObj(obj));
							
						}
						if (obj.right >= currP.right) {
							//do nothing
						}
					} else {
						////trace("obj "+Utils.printObj(obj)+" is farther than currP "+Utils.printObj(currP));
						//obj is farther away
						//end obj at left 
						if (obj.right < currP.right) {
							//trace("	obj "+Utils.printObj(obj)+" right is less than currP right "+Utils.printObj(currP));
							//if obj is farther
							obj.right = currP.left;
							obj.added = true;
							tmp[h].push(obj);
							////trace("2 "+Utils.printObj(obj));

							obj = pool.get("angle");
							obj.left =  currP.left;
							obj.right= currP.right;
							obj.dist= currP.dist;
							//trace("3 "+Utils.printObj(obj));

							
						} else if (obj.right >= currP.right) {
							//trace("	obj "+Utils.printObj(obj)+" right is more than currP right "+Utils.printObj(currP));
							
							var l = obj.left;
							var r = obj.right;
							var d = obj.dist;
							var orig:AngledBody =  pool.get("angle");
							orig.left= l;
							orig.right= r;
							orig.dist= d;
							
							obj.right = currP.left;
							obj.added = true;
							tmp[h].push(obj);
							////trace("4 "+Utils.printObj(obj));

							obj = pool.get("angle");
							obj.left =  currP.left;
							obj.right= currP.right;
							obj.dist= currP.dist;
							obj.added = true;

							
							tmp[h].push(obj);
							//trace("5 "+Utils.printObj(obj));

							obj = pool.get("angle");
							obj.left =  currP.right;
							obj.right= orig.right;
							obj.dist= orig.dist;
							//trace("6 "+Utils.printObj(obj));

							
						}
					}
				}
				if (obj.added != true) {
					tmp[h].push(obj);
				}
			}

			////trace("bob");
			var res = [];
			for (var b = 0; b < tmp.length; b++) {
				var a: Array = tmp[b];
				for (var i: int = 0; i < a.length; i++) {
					var pp:AngledBody = a[i];
					res.push(pp);
					//trace("l",pp.left,"r", pp.right, "d",pp.dist);
				}

			}
			//trace("--");

			//now do empties
			var o:AngledBody;
			for (h = 0; h < tmp.length; h++) {
				//////trace("h",h);
				var a: Array = tmp[h];
				if (h == 0) 
				{
					if (a[0].left != 0) 
					{

						o = pool.get("angle");
						o.left  =  0;
						o.right = a[0].left;
						o.dist  = lightRad;

						
						empties.push(o);

						o = pool.get("angle");
						o.left =  a[a.length - 1].right;
						o.dist = lightRad;

					} else {
						o = pool.get("angle");
						o.left =  a[a.length - 1].right;
						o.dist = lightRad;
					}

				} 
				else 
				{
					o.right = a[0].left;
					empties.push(o);

					o = pool.get("angle");
					o.left =  a[a.length - 1].right;
					o.dist = lightRad;
				}

				if (h == tmp.length - 1) {
					//////trace("added last one!");
					o.right = Math.PI * 2;
					empties.push(o);
				}
				
			}

			
			//trace("output");
			var res = [];
			for (var b = 0; b < tmp.length; b++) {
				var a: Array = tmp[b];
				for (var i: int = 0; i < a.length; i++) {
					var pp:AngledBody = a[i];
					res.push(pp);
					//trace("l",pp.left,"r", pp.right, "d",pp.dist);
				}

			}

			return res;
		}

		public function sendBeams(angles: Array,  lightLineThickness: Number, isEmpty: Boolean): void {
			var baseLen: Number = radius;
			var a: AngledBody;

			//model.g0.lineStyle(0, color, 0.5); //per * 0.6

			//first emit to all the planets
			////trace(angles.length);
			for (var h: int = 0; h < angles.length; h++) {
				a = angles[h];
				if (a) {
					model.g0.moveTo(x, y);
					model.g0.beginFill(color);


					var cos: Number = Math.cos(a.left);
					var sin: Number = Math.sin(a.left);
					var dpX: Number = x + cos * a.dist; //+ lightLineThickness)
					var dpY: Number = y + sin * a.dist; //+ lightLineThickness
					model.g0.lineTo(dpX, dpY);
					

					if (isEmpty) {
						//////trace("empty left",a.left, "right",a.right);

						var pers: Array = [0.25, 0.5, 0.75];
						for (var i = 0; i < pers.length; i++) {
							var midAngle: Number = a.left + ((a.right - a.left) * pers[i]);
							//////trace(midAngle);
							cos = Math.cos(midAngle);
							sin = Math.sin(midAngle);
							dpX = x + cos * a.dist; //+ lightLineThickness)
							dpY = y + sin * a.dist; //+ lightLineThickness
							model.g0.lineTo(dpX, dpY);
						}

					}

					cos = Math.cos(a.right);
					sin = Math.sin(a.right);
					dpX = x + cos * a.dist; //+ lightLineThickness)
					dpY = y + sin * a.dist; //+ lightLineThickness
					model.g0.lineTo(dpX, dpY);

					model.g0.lineTo(x, y);
					model.g0.endFill();

					

				}
			}
		}


		public static function findBiggestRight(arr: Array): AngledBody {
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