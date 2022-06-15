package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.*;

	public class Main extends MovieClip
	{

		var zoomAmount: Number = 0.05;
		var currZoom: Number = 1;

		var mouseDown: Boolean = false;
		var origMouseX: Number = 0;
		var origMouseY: Number = 0;


		var layerS: Sprite = new Sprite();
		var layer0: Sprite = new Sprite();
		var layer05: Sprite = new Sprite();
		var layer1: Sprite = new Sprite();
		var debugLayer: Sprite = new Sprite();

		var offsetX = 0;
		var offsetY = 0;
		var prevX = 0;
		var prevY = 0;


		var layers: Array = [layerS, layer0, layer05, layer1, debugLayer];

		var gs = layerS.graphics;
		var g0 = layer0.graphics;
		var g05 = layer05.graphics;
		var g1 = layer1.graphics;
		var dg = debugLayer.graphics;

		var allPlanets: Array = [];
		var tweenTo: Object = null;

		/*
		Mercury - 0
		Venus - 0
		Earth - 1
		Mars - 2
		Jupiter - 79 (53 confirmed, 26 provisional)
		Saturn - 82 (53 confirmed, 29 provisional)
		Uranus - 27
		Neptune - 14
		
		
		*/

		/*
		var moon: Object = {
			radius: 8,
			color: 0xffffff * Math.random(),
			distanceFromParent: 20,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "moon"
		}


		var marsMoon1: Object = {
			radius: 10,
			color: 0xffffff * Math.random(),
			distanceFromParent: 50,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "europa"
		}

		var marsMoon2: Object = {
			radius: 7,
			color: 0xffffff * Math.random(),
			distanceFromParent: 80,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "kallisto"
		}


		var marsMoon3: Object = {
			radius: 7,
			color: 0xffffff * Math.random(),
			distanceFromParent: 110,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "io"
		}

		var marsMoon4: Object = {
			radius: 7,
			color: 0xffffff * Math.random(),
			distanceFromParent: 140,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "x"
		}


		var marsMoon5: Object = {
			radius: 7,
			color: 0xffffff * Math.random(),
			distanceFromParent: 170,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "p4573"
		}


		var marsMoon6: Object = {
			radius: 7,
			color: 0xffffff * Math.random(),
			distanceFromParent: 200,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(true),
			name: "p456873"
		}
		*/


		var mercury: Object = {
			radius: 15,
			color: 0xffffff * Math.random(),
			distanceFromParent: 300,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			orbitingPlanets: [],
			showOrbit: false,
			numMoons: 5,
			name: "mercury"
		}

		var venus: Object = {
			radius: 20,
			color: 0xffffff * Math.random(),
			distanceFromParent: 600,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			showOrbit: false,
			name: "venus"
		}

		var earth: Object = {
			radius: 22,
			color: 0xffffff * Math.random(),
			distanceFromParent: 200,
			angle: 0,//Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			orbitingPlanets: [],
			showOrbit: false,
			numMoons: 5,

			name: "earth"
		}


		var mars: Object = {
			radius: 18,
			color: 0xffffff * Math.random(),
			distanceFromParent: 1500,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			orbitingPlanets: [],
			showOrbit: false,
			numMoons: 2,
			name: "mars"
		}

		var jupiter: Object = {
			radius: 100,
			color: 0xffffff * Math.random(),
			distanceFromParent: 2500,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			orbitingPlanets: [],
			showOrbit: false,
			numMoons: 53,
			name: "jupiter"
		}

		var saturn: Object = {
			radius: 120,
			color: 0xffffff * Math.random(),
			distanceFromParent: 5000,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			rings: [Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff],
			orbitingPlanets: [],
			showOrbit: false,
			numMoons: 53,
			name: "saturn"
		}

		var uranus: Object = {
			radius: 18,
			color: 0xffffff * Math.random(),
			distanceFromParent: 6000,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			orbitingPlanets: [],
			numMoons: 27,
			showOrbit: false,
			name: "uranus"
		}

		var neptune: Object = {
			radius: 18,
			color: 0xffffff * Math.random(),
			distanceFromParent: 7000,
			angle: Math.random() * (Math.PI * 2),
			speed: getSpeed(),
			orbitingPlanets: [],
			showOrbit: false,
			numMoons: 14,
			name: "neptune"
		}


		var sun: Object = {
			radius: 50,
			color: 0xffff00,
			x: stage.stageWidth / 2,
			y: stage.stageHeight / 2,
			emitsLight: true,
			lightRad: 10000,
			lightAngleDelta: 0.01, //0.03 is the smallest that still runs in normal fps

			orbitingPlanets: [
				duplicate(mercury),
				duplicate(venus),
				duplicate(earth),
				duplicate(mars),
				duplicate(jupiter),
				duplicate(saturn),
				duplicate(uranus),
				duplicate(neptune)
			],
			/**/
			name: "sun"
		}


		public function Main()
		{
			// constructor code
			stage.align = "topLeft";
			stage.addChild(layerS);
			stage.addChild(layer0);
			stage.addChild(layer05);
			stage.addChild(layer1);
			stage.addChild(debugLayer);
			stage.addChild(txt);
			stage.addChild(moonsTxt);
			txt.text = "";
			moonsTxt.text = "";


			for (var i: int = 0; i < layers.length; i++)
			{
				var l: Sprite = layers[0];
				l.mouseChildren = false;
				l.mouseEnabled = false;
			}


			populatePlanetsARrr(sun);
			addMoons();
			populateBGStars();


			stage.addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, zooom);
		}

		function addMoons(): void
		{
			for (var i: int = 0; i < allPlanets.length; i++)
			{
				var planet: Object = allPlanets[i];
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
							speed: getSpeed(true),
							name: "moon"
						}

						dist += (moon.radius * 2);

						planet.orbitingPlanets.push(moon);
					}
				}

			}
		}

		function drawPlanet(planet: Object, parentObj: Object = null): void
		{
			g1.beginFill(planet.color, 1);

			if (parentObj)
			{


				var cos: Number = Math.cos(planet.angle) * (planet.distanceFromParent + parentObj.radius);
				var sin: Number = Math.sin(planet.angle) * (planet.distanceFromParent + parentObj.radius);
				cos += parentObj.x;
				sin += parentObj.y;

				planet.x = cos;
				planet.y = sin;

				planet.angle += planet.speed;
				planet.angle = fixAngle(planet.angle);

				if (planet.showOrbit || parentObj.showOrbit)
				{
					g05.lineStyle(0.1, 0xffffff, .5);
					g05.drawCircle(parentObj.x, parentObj.y, planet.distanceFromParent + parentObj.radius);
					g05.endFill();
				}


			}
			/**/
			if (isInScreen(planet.x, planet.y) ||
				isInScreen(planet.x + planet.radius, planet.y) ||
				isInScreen(planet.x - planet.radius, planet.y) ||
				isInScreen(planet.x, planet.y + planet.radius) ||
				isInScreen(planet.x, planet.y - planet.radius)

			)
			{
				g1.drawCircle(planet.x, planet.y, planet.radius); // Draw the circle, assigning it a x position, y position, raidius.
				g1.endFill();
			}


			var p: Object;
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					p = planet.orbitingPlanets[i];
					drawPlanet(p, planet);
				}
			}

			if (planet.emitsLight)
			{
				var lightLineThickness: Number = 2;
				if (lightLineThickness < 1)
				{
					lightLineThickness = 1;
				}
				var lightAngleDelta: Number = planet.lightAngleDelta; //(Math.PI * 2)/(360/2 );


				g0.lineStyle(lightLineThickness, planet.color, 0.4);
				var angles: Array = [];

				//
				gatherAllPlanetPositions(angles, planet, allPlanets);

				var emptypSpaces = [];
				//sort the array and fix it to contain the accurate gaps so none are overlapping
				angles = addEntry1(angles, emptypSpaces);

				var baseLen: Number = planet.radius;


		
				var a: Object;

				//first emit to all the planets
				//trace(angles.length);
				for (var h: int = 0; h < angles.length; h++)
				{
					a = angles[h];
					if (a)
					{
						
						for (var l: Number = a.left; l <= a.right; l += lightAngleDelta)
						{
							var cos1: Number = Math.cos(l);
							var sin1: Number = Math.sin(l);
							var planetSurfaceX: Number = planet.x + (cos1 * baseLen);
							var planetSurfaceY: Number = planet.y + (sin1 * baseLen);

							//if (isInScreen(planetSurfaceX, planetSurfaceY)) 
							{
								emitLight(lightLineThickness, planetSurfaceX, planetSurfaceY, planet.x, planet.y, cos1, sin1, Math.min(a.dist, planet.lightRad), planet.lightRad, planet.color);//
							}
						}

					}


				}
				//then emit to empty space
			
			
				for (var k: int = 0; k < emptypSpaces.length; k++)
				{
					a = emptypSpaces[k];
					for (var ang: Number = a.left; ang < a.right; ang += lightAngleDelta)
					{
						var cos2: Number = Math.cos(ang);
						var sin2: Number = Math.sin(ang);
						var planetSurfaceX: Number = planet.x + (cos2 * baseLen);
						var planetSurfaceY: Number = planet.y + (sin2 * baseLen);

						//if (isInScreen(planetSurfaceX, planetSurfaceY)) 
						{

							emitLight(lightLineThickness, planetSurfaceX, planetSurfaceY, planet.x, planet.y, cos2, sin2, planet.lightRad, planet.lightRad, planet.color);
						}


					}
				}/**/
			}

			if (planet.rings)
			{
				var i;
				var j;
				var startDist: Number = planet.radius + (planet.radius * 0.4);
				for (i = 0; i < planet.rings.length; i++)
				{
					var color: uint = planet.rings[i];
					g05.lineStyle(0.1, color, .5);

					for (j = 0; j < 15; j++)
					{
						g05.drawCircle(planet.x, planet.y, startDist + j);
						g05.endFill();
					}
					startDist += j;


				}


			}
		}

		function gatherAllPlanetPositions(angles: Array, planet: Object, arr: Array): void
		{
			var p: Object;
			for (var j: int = 0; j < arr.length; j++)
			{
				p = arr[j];

				if (p == planet)
				{
					continue;
				}
				//go over all planets and get their angle to the sun
				//get center angle, angle from left side and angle from right side
				//we need to t figure out if they are blocking planets behind them
				var centerAngleToSun: Number = fixAngle(getAngle(p.x, p.y, planet.x, planet.y));
				var distanceToSun: Number = getDistance(planet.x, planet.y, p.x, p.y);

				if(distanceToSun < planet.lightRad)
				{
					var leftAngle: Number = centerAngleToSun + (Math.PI / 2);
					var leftPointX: Number = (Math.cos(leftAngle) * p.radius) + p.x;
					var leftPointY: Number = (Math.sin(leftAngle) * p.radius) + p.y;

					//drawCircle(leftPointX, leftPointY, 2);

					var rightAngleToSun: Number = fixAngle(getAngle(leftPointX, leftPointY, planet.x, planet.y));

					var rigtAngle: Number = centerAngleToSun - (Math.PI / 2);
					var rightPointX: Number = (Math.cos(rigtAngle) * p.radius) + p.x;
					var rightPointY: Number = (Math.sin(rigtAngle) * p.radius) + p.y;

					//drawCircle(rightPointX, rightPointY, 2);

					var leftAngleToSun: Number = fixAngle(getAngle(rightPointX, rightPointY, planet.x, planet.y));

					if (leftAngleToSun > rightAngleToSun)
					{
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

				

				if (p.orbitingPlanets)
				{
					gatherAllPlanetPositions(angles, planet, p.orbitingPlanets);
				}



			}
		}

		//emitLight(lightLineThickness, planetSurfaceX, planetSurfaceY, planet.x, planet.y, cos1, sin1, Math.min(a.dist, planet.lightRad), planet.lightRad, 0xffffff * Math.random(), baseLen);
		function emitLight(
			lightLineThickness: Number, 
			planetSurfaceX: Number, 
			planetSurfaceY: Number, 
			baseX: Number, 
			baseY: Number, 
			cos: Number, 
			sin: Number, 
			currentLightRad: Number, 
			totalLightRad: Number, 
			color: uint): void
		{

			g0.moveTo(planetSurfaceX, planetSurfaceY);
			
			var dpX: Number = baseX + cos * currentLightRad ;//+ lightLineThickness)
			var dpY: Number = baseY + sin  * currentLightRad;//+ lightLineThickness

			if (isInScreen(planetSurfaceX, planetSurfaceY) || isInScreen(dpX, dpY))
			{
				g0.lineStyle(lightLineThickness, color, 0.5);//per * 0.6
				g0.lineTo(dpX, dpY);
			}
		}

		//now that we have all angles to the sun we need to fix them so none are overlapping
		//some may encapsulte others
		//others may combine to larger gaps
		//once we have this complete list we know how far to draw each ray of the sun
		//if we've made alterations to the array we need to do the algorithm again until we havs the 
		//accurate gaps array

		function addEntry1(arr: Array, empties:Array): Array
		{
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
			
			for (i = 0; i < arr.length; i++)
			{
				var currP: Object = arr[i];
				var useNewArr = true;
				
				if(i == 0)
				{
					currMin = currP.left;
					currMax = currP.right;
				}
				
				//this means we have hit a new cluster
				if(currP.left > currMax)
				{
					bigArr.push([]);
					arrNum++;
					bigArr[arrNum].push(currP);
					currMin = currP.left;
					currMax = currP.right;
				}
				else
				{
					if(arrNum == -1)
					{
						arrNum = 0;
						bigArr[arrNum] = [];
					}
					bigArr[arrNum].push(currP);
					if(currP.right > currMax)
					{
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
			var lastArr = bigArr[bigArr.length-1];
			var lastElement = findBiggestRight(lastArr);
			if(lastElement.right > (Math.PI * 2))
			{
				
				
				var r = lastElement.right - (Math.PI * 2);
				//trace("lastElement l",lastElement.left,"r", r, "d",lastElement.dist);
				for(var i = 0; i < bigArr[0].length; i++)
				{
					var element = bigArr[0][i];
					//trace("	element l",element.left,"r", element.right, "d",element.dist);
					if(element.left > r)
					{
						//trace("		element left is bigger than last right");
						break;
					}
					if(element.right < r)
					{
						//trace("		element right is smaller than last right");
						if(element.distance > lastElement.distance)
						{
							trace("		element is farther");
							bigArr[0].splice(i,1);
							if(bigArr[0].length == 0)
							{
								bigArr.shift();
								break;
							}
						}
						else
						{
							//element is closer
							var index = Math.max(i-1, 0);
							//trace("		element is closer");
							bigArr[0].unshift({left : smallestLeft, right : element.left, dist : lastElement.dist});
							smallestLeft = element.right;
							i++;//to not get stick in a loop i guess
						}
					}
					else
					{
						//current element is bigger than 
						if(element.distance < lastElement.distance)
						{
							bigArr[0].unshift({left : smallestLeft, right : element.left, dist : lastElement.dist});
						}
						else
						{
							bigArr[0].unshift({left : smallestLeft, right : r, dist : lastElement.dist});
							element.left = r ;
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
			var tmp:Array = [];
			//now sort the clusters 
			for ( h = 0; h < bigArr.length; h++)
			{
				tmp[h] = [];
				var a: Array = bigArr[h];
				var obj = {
					left: a[0].left,
					right:a[0].right,
					dist:a[0].dist
				};
				
				for (var i: int = 1; i < a.length; i++)
				{
					var currP: Object = a[i];

					//if obj is closer
					if(obj.dist < currP.dist )
					{
						//trace("obj "+printObj(obj)+" is closer than currP "+printObj(currP));
						//if obj ends before curr
						if(obj.right < currP.right)
						{
							//trace("	obj "+printObj(obj)+"right is less than currP right "+printObj(currP));
							obj.added = true;
							tmp[h].push(obj);
							obj = {
								left: obj.right,
								right:currP.right,
								dist:currP.dist
							}
						}
						if(obj.right >= currP.right)
						{
							//do nothing
						}
					}
					else
					{
						//trace("obj "+printObj(obj)+" is farther than currP "+printObj(currP));
						//obj is farther away
						//end obj at left 
						if(obj.right < currP.right)
						{
							//trace("	obj "+printObj(obj)+" right is less than currP right "+printObj(currP));
							//if obj is farther
							obj.right = currP.left;
							obj.added = true;
							tmp[h].push(obj);
							obj = {
								left: currP.left,
								right:currP.right,
								dist:currP.dist
							}
						}
						else if(obj.right >= currP.right)
						{
							//trace("	obj "+printObj(obj)+" right is more than currP right "+printObj(currP));
							var orig = {left:obj.left, right:obj.right, dist:obj.dist};
							obj.right = currP.left;
							obj.added = true;
							tmp[h].push(obj);
							obj = {
								left: currP.left,
								right:currP.right,
								dist:currP.dist,
								added:true
							}
							tmp[h].push(obj);
						
							obj = {
								left: currP.right,
								right:orig.right,
								dist:orig.dist
							}
						}
					}					
				}
				if(obj.added != true)
				{
					tmp[h].push(obj);
				}
			}
		
		
			var o;
			for ( h = 0; h < tmp.length; h++)
			{
				var a: Array = tmp[h];
				if(h == 0)
				{
					if(a[0].left != 0)
					{
						o = {left : 0, right : a[0].left };
						empties.push(o);
						o = {left : a[a.length-1].right };
					}
					else{
						o = {left : a[a.length-1].right };
					}

				}
				else{
					o.right = a[0].left;
					empties.push(o);
					o = {left : a[a.length-1].right };
					
					if(h == tmp.length-1)
					{
						o.right = Math.PI * 2;
						empties.push(o);
					}
				}
			}
			
			/**/
			trace("output");
			var res = [];
			for (var b = 0; b < tmp.length; b++)
			{	
				var a: Array = tmp[b];
				for (var i: int = 0; i < a.length; i++)
				{
					var pp = a[i];
					res.push(pp);
					trace("l",pp.left,"r", pp.right, "d",pp.dist);
				}
				
			}
		
			return res;
		}
	
	function findBiggestRight(arr:Array):Object
	{
		var big = 0;
		var element = null;
		
		for(var i = arr.length-1; i >= 0; i--)
		{
			var g = arr[i];

			if( g.right > big )
			{
				element = g;
				big = g.right;
			}
		}
		return element;
	}
	
	function printObj(obj:Object):String
	{
		var str:String = "";
		for(var k:String in obj)
		{
			str += k + ":" + obj[k] + " ";
		}
		return str;
	}

		function fixAngle(angle: Number): Number
		{
			if (angle > Math.PI * 2)
			{
				angle -= Math.PI * 2;
			}
			else if (angle < 0)
			{
				angle += Math.PI * 2;
			}
			return angle;
		}

		function drawCircle(_x: Number, _y: Number, rad: Number, color: uint = 0xffffff): void
		{
			dg.beginFill(color, 1);
			dg.drawCircle(_x, _y, rad); // Draw the circle, assigning it a x position, y position, raidius.
			dg.endFill();
		}


		function getDistance(p1X: Number, p1Y: Number, p2X: Number, p2Y: Number): Number
		{
			var dX: Number = p1X - p2X;
			var dY: Number = p1Y - p2Y;
			var dist: Number = Math.sqrt(dX * dX + dY * dY);
			return dist;
		}

		function getAngle(p1X: Number, p1Y: Number, p2X: Number, p2Y: Number): Number
		{
			var dX: Number = p1X - p2X;
			var dY: Number = p1Y - p2Y;
			return Math.atan2(dY, dX);
		}


		function isInScreen(p1X: Number, p1Y: Number): Boolean
		{
			var l: Sprite = layers[1];
			var localPos: Point = l.localToGlobal(new Point(p1X, p1Y));
			var w: Number = stage.stageWidth;
			var h: Number = stage.stageHeight;
			if (localPos.x > 0 && localPos.x < w && localPos.y > 0 && localPos.y < h)
			{
				return true;
			}
			else
			{
				return false;
			}

		}




		function populatePlanetsARrr(planet: Object): void
		{
			allPlanets.push(planet);
			if (planet.orbitingPlanets)
			{
				for (var i: int = 0; i < planet.orbitingPlanets.length; i++)
				{
					var p: Object = planet.orbitingPlanets[i];

					populatePlanetsARrr(p);
				}
			}
		}






		function duplicate(o: Object): Object
		{
			var newO: Object = {};
			for (var k: String in o)
			{
				newO[k] = o[k];
			}
			return newO;
		}





		function populateBGStars(): void
		{
			gs.lineStyle(0.1, 0x000000);

			for (var i: int = 0; i < 100; i++)
			{
				var _x: Number = stage.stageWidth * Math.random();
				var _y: Number = stage.stageHeight * Math.random();
				gs.beginFill(0xffffff, 1);
				gs.drawCircle(_x, _y, 1); // Draw the circle, assigning it a x position, y position, raidius.
				gs.endFill();
			}
		}


		function setFollow(p: Object, firstTime: Boolean): void
		{
			var l: Sprite = layers[1];
			var i: int = 0;
			trace("hit ", p.name);
			for (i = 0; i < layers.length; i++)
			{
				l = layers[i];
				var fX: Number = 0;
				var fY: Number = 0;

				fX -= (p.x * currZoom);
				fY -= (p.y * currZoom);
				fX += (stage.stageWidth / 2); //
				fY += (stage.stageHeight / 2); //
				p.showOrbit = true;
				tweenTo = {
					planet: p,
					x: fX,
					y: fY,
					firstTime: firstTime
				};
			}
		}

		var yonny = true;

		function getSpeed(isMoon: Boolean = false): Number
		{
			var speed: Number = (Math.random() * 0.005) + 0.001;
			if (isMoon)
			{
				speed += (Math.random() * 0.05) + 0.01;
			}
			return speed;
		}

		function onDown(event: MouseEvent): void
		{
			var l: Sprite = layers[1];
			//this is the offset in origin coords, at scale 1
			offsetX = (stage.mouseX - l.x) / currZoom;
			offsetY = (stage.mouseY - l.y) / currZoom;
			mouseDown = true;
			if (tweenTo)
			{
				tweenTo.planet.showOrbit = false;
			}

			tweenTo = null;
			txt.text = "";
			moonsTxt.text = "";
		}


		function update(e: Event): void
		{
			var i: int = 0;
			var l: Sprite;



			if (tweenTo != null)
			{

				if (tweenTo.firstTime)
				{
					l = layers[1];
					var dX: Number = ((tweenTo.x - l.x) / 2);
					var dY: Number = ((tweenTo.y - l.y) / 2);

					for (i = 0; i < layers.length; i++)
					{
						l = layers[i];
						if (i != 0)
						{

							l.x += dX;
							l.y += dY;

						}
					}

					if (getDistance(l.x, l.y, tweenTo.x, tweenTo.y) < 0.5)
					{
						setFollow(tweenTo.planet, false);
					}


				}
				else
				{
					var fX: Number = 0;
					var fY: Number = 0;

					fX -= (tweenTo.planet.x * currZoom);
					fY -= (tweenTo.planet.y * currZoom);
					fX += (stage.stageWidth / 2); //
					fY += (stage.stageHeight / 2); //
					for (i = 0; i < layers.length; i++)
					{
						l = layers[i];
						if (i != 0)
						{

							l.x = fX;
							l.y = fY;
						}
					}
				}

			}
			else
			{
				if (mouseDown)
				{
					var l: Sprite = layers[1];
					//this is absolute position in scene, scaled
					var newX = stage.mouseX - (offsetX * currZoom);
					var newY = stage.mouseY - (offsetY * currZoom);
					for (i = 0; i < layers.length; i++)
					{
						l = layers[i];
						if (i == 0)
						{
							//l.x -= deltaX * 0.1;
							//l.y -= deltaY * 0.1;
						}
						else
						{
							l.x = newX;
							l.y = newY;
						}
					}

					prevX = l.x;
					prevY = l.y;


				}
			}
			if(yonny)
			{
				//yonny = false;
				g0.clear();
				g05.lineStyle(0.1, 0x000000);
				g05.clear();
				g1.clear();
				g1.lineStyle(0.1, 0x000000);
				drawPlanet(sun);
			}
			
			//stage.removeEventListener(Event.ENTER_FRAME, update);
		}


		function onUp(event: MouseEvent): void
		{
			mouseDown = false;
		}

		function zooom(event: MouseEvent): void
		{
			var l: Sprite = layers[1];
			//this is the mouse position at current scale inside 
			var localPosPre: Point = l.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			//drawCircle(localPosPre.x, localPosPre.y, 10, 0x00cc00);
			if (tweenTo)
			{
				tweenTo.planet.showOrbit = false;
			}


			tweenTo = null;
			txt.text = "";
			moonsTxt.text = "";
			var proceed: Boolean = true;
			if (event.delta > 0)
			{
				currZoom += zoomAmount;
			}
			else if (event.delta < 0)
			{
				currZoom -= zoomAmount;
				if (currZoom <= 0.01)
				{
					currZoom = 0.01;
					proceed = false;
				}
			}

			//txt.text = String(event.delta);

			if (!proceed)
			{
				return;
			}


			var i: int = 0;


			for (i = 0; i < layers.length; i++)
			{
				l = layers[i];

				if (i != 0)
				{
					l.scaleX = currZoom;
					l.scaleY = currZoom;


				}
			}


			for (i = 0; i < layers.length; i++)
			{
				l = layers[i];

				if (i != 0)
				{
					l.x = stage.mouseX - localPosPre.x * currZoom;
					l.y = stage.mouseY - localPosPre.y * currZoom;

				}
			}

		}

		///////////////////////////---- controls -----/////////
		function onClick(event: MouseEvent): void
		{
			var l: Sprite = layers[1];
			var localPos: Point = l.globalToLocal(new Point(stage.mouseX, stage.mouseY));
			var xPos: Number = localPos.x; //(  ((stage.mouseX* currZoom) - l.x)  ); // l.x + -
			var yPos: Number = localPos.y; //(  ((stage.mouseY* currZoom) - l.y) ); //l.y + -
			var p: Object;
			var found: Boolean = false;
			var i: int = 0;
			for (i = 0; i < allPlanets.length; i++)
			{
				p = allPlanets[i];
				if (getDistance(p.x, p.y, xPos, yPos) < p.radius)
				{
					found = true;
					break;
				}
			}
			if (found)
			{
				txt.text = p.name;
				moonsTxt.text = "";
				if (p.numMoons)
				{
					moonsTxt.text = String(p.numMoons) + " Moons";
				}

				setFollow(p, true);

			}

		}

	}

}