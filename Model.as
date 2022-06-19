package {
	import flash.display.*;
	import flash.text.TextField;

	public class Model {

		public static var partition:Object = {};
		public static var tileW:int;
		public static var tileH:int;
		public static var mapW:int;
		public static var mapH:int ;
		public static var mapLeft:int;
		public static var mapTop:int;

		public static var numShips:int = 6;

		public static var maxDistance = 1000000;

		public var mercury: Planet;
		public var venus: Planet;
		public var earth: Planet;
		public var mars: Planet;
		public var jupiter: Planet;
		public var saturn: Planet;
		public var uranus: Planet;
		public var neptune: Planet;
		public var sun: Star;

		public var layerS: Sprite = new Sprite();
		public var layerT: Sprite = new Sprite();
		public var layer0: Sprite = new Sprite();
		public var layer05: Sprite = new Sprite();
		public var layer1: Sprite = new Sprite();
		public var debugLayer: Sprite = new Sprite();
		public var allPlanets: Vector.<Entity> = new Vector.<Entity>;
		public var tweenTo: Object = null;
		public var layers: Array;
		public var gs = layerS.graphics;
		public var gt = layerT.graphics;
		public var g0 = layer0.graphics;
		public var g05 = layer05.graphics;
		public var g1 = layer1.graphics;
		public var dg = debugLayer.graphics;
		public var offsetX: Number = 0;
		public var offsetY: Number = 0;
		public var prevX: Number = 0;
		public var prevY: Number = 0;
		public var zoomAmount: Number = 0.05;
		public var currZoom: Number = 1;
		public var mouseDown: Boolean = false;
		
		///texts
		public var txt:TextField;
		public var moonsTxt:TextField;
		private var stage:Stage;


		public function Model(_stage: Stage) {
	
			layers = [layerS, layerT, layer0, layer05, layer1, debugLayer];
			stage = _stage;
			
			var dist:int = 500;

			mercury = new Planet(this, stage);
			mercury.init(
			/*radius*/	50, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	500, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"mercury"
			);
			
			dist += (mercury.radius * 10);

			venus = new Planet(this, stage);
			venus.init(
			/*radius*/	50, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"venus"
			);
			
			dist += (venus.radius * 10);

			earth = new Planet(this, stage);
			earth.init(
			/*radius*/	50, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	0,//Math.random() * (Math.PI * 2), 
			/*name*/	"earth",
			/*numMoons*/5
			);

			dist += (earth.radius * 10);


			mars = new Planet(this, stage);
			mars.init(
			/*radius*/	35, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"mars",
			/*numMoons*/1
			);

			dist += (mars.radius * 10);
			

			jupiter = new Planet(this, stage);
			jupiter.init(
			/*radius*/	200, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"jupiter",
			/*numMoons*/5
			);

			dist += (jupiter.radius * 10);

			saturn = new Planet(this, stage);
			saturn.init(
			/*radius*/	180, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"saturn",
			/*numMoons*/3,
			/*numRings*/ 8
			);

			dist += (saturn.radius * 10);



			uranus = new Planet(this, stage);
			uranus.init(
			/*radius*/	80, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"uranus",
			4
			);

			dist += (uranus.radius * 10);
			

			neptune = new Planet(this, stage);
			neptune.init(
			/*radius*/	70, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	dist, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"neptune",
			3,
			2
			);

			dist += (neptune.radius * 10);
			

			sun = new Star(this, stage);
			sun.init(
			/*radius*/	300, 
			/*color*/	0xffff00,
			/*distanceFromParent*/	10000, 
			/*angle*/	0, 
			/*name*/	"sun"
			);
			
			sun.lightRad = 9000;
			sun.x= _stage.stageWidth / 2;
			sun.y= _stage.stageHeight / 2;
			sun.orbitingPlanets = new Vector.<Entity>();

			sun.orbitingPlanets.push(mercury);
			sun.orbitingPlanets.push(venus);
			sun.orbitingPlanets.push(earth);
			sun.orbitingPlanets.push(mars);
			sun.orbitingPlanets.push(jupiter);
			sun.orbitingPlanets.push(saturn);
			sun.orbitingPlanets.push(uranus);
			sun.orbitingPlanets.push(neptune); 
			
			
		}



	}

}