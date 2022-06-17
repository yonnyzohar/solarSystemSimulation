package {
	import flash.display.*;
	import flash.text.TextField;

	public class Model {

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
			


			mercury = new Planet(this, stage);
			mercury.init(
			/*radius*/	30, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	500, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"mercury"
			);
			
			

			venus = new Planet(this, stage);
			venus.init(
			/*radius*/	30, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	1000, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"venus"
			);
			

			earth = new Planet(this, stage);
			earth.init(
			/*radius*/	30, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	1500, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"earth",
			/*numMoons*/4
			);


			mars = new Planet(this, stage);
			mars.init(
			/*radius*/	20, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	2000, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"mars",
			/*numMoons*/2
			);
			

			jupiter = new Planet(this, stage);
			jupiter.init(
			/*radius*/	100, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	2500, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"jupiter",
			/*numMoons*/4
			);

			saturn = new Planet(this, stage);
			saturn.init(
			/*radius*/	150, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	3000, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"saturn",
			/*numMoons*/12,
			/*numRings*/ 3
			);



			uranus = new Planet(this, stage);
			uranus.init(
			/*radius*/	30, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	3500, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"uranus"
			);
			

			neptune = new Planet(this, stage);
			neptune.init(
			/*radius*/	30, 
			/*color*/	0xffffff * Math.random(),
			/*distanceFromParent*/	4000, 
			/*angle*/	Math.random() * (Math.PI * 2), 
			/*name*/	"neptune",
			10
			);
			

			sun = new Star(this, stage);
			sun.init(
			/*radius*/	200, 
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
			sun.orbitingPlanets.push(neptune); //Utils.duplicate
			
			
		}



	}

}