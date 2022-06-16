package {
	import flash.display.*;
	import flash.text.TextField;

	public class Model {

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
		public var allPlanets: Vector.<Planet> = new Vector.<Planet>;
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


		public function Model(_stage: Stage) {
	
			layers = [layerS, layerT, layer0, layer05, layer1, debugLayer];



			mercury = new Planet();
			mercury.radius= 30;
			mercury.color= 0xffffff * Math.random();
			mercury.distanceFromParent= 300;
			mercury.angle= Math.random() * (Math.PI * 2);
			mercury.showOrbit= false;
			mercury.name= "mercury";
			

			venus = new Planet();
			venus.radius =  35;
			venus.color = 0xffffff * Math.random();
			venus.distanceFromParent = 600;
			venus.angle = Math.random() * (Math.PI * 2);
			venus.showOrbit = false;
			venus.name = "venus";
			

			earth = new Planet();
			earth.radius =  40;
			earth.color = 0xffffff * Math.random();
			earth.distanceFromParent = 1000;
			earth.angle = 0; 
			earth.showOrbit = false;
			earth.numMoons = 1;
			earth.name = "earth"
			


			mars = new Planet();
			mars.radius =  20;
			mars.color = 0xffffff * Math.random();
			mars.distanceFromParent = 1500;
			mars.angle = Math.random() * (Math.PI * 2);
			mars.showOrbit = false;
			mars.numMoons = 2;
			mars.name = "mars"

			jupiter = new Planet();
			jupiter.radius =  100;
			jupiter.color = 0xffffff * Math.random();
			jupiter.distanceFromParent = 2500;
			jupiter.angle = Math.random() * (Math.PI * 2);
			jupiter.showOrbit = false;
			jupiter.numMoons = 4;
			jupiter.name = "jupiter"

			saturn = new Planet();
			saturn.radius =  120;
			saturn.color = 0xffffff * Math.random();
			saturn.distanceFromParent = 5000;
			saturn.angle = Math.random() * (Math.PI * 2);
			saturn.rings =  [Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff];
			saturn.showOrbit = false;
			saturn.numMoons = 12;
			saturn.name = "saturn"



			uranus = new Planet();
			uranus.radius =  18;
			uranus.color = 0xffffff * Math.random();
			uranus.distanceFromParent = 6000;
			uranus.angle = Math.random() * (Math.PI * 2);
			uranus.numMoons = 3;
			uranus.showOrbit = false;
			uranus.name = "uranus"
			

			neptune = new Planet();
			neptune.radius =  18;
			neptune.color = 0xffffff * Math.random();
			neptune.distanceFromParent = 7000;
			neptune.angle = Math.random() * (Math.PI * 2);
			neptune.showOrbit = false;
			neptune.numMoons = 4;
			neptune.name = "neptune"
			

			sun = new Star();
			sun.radius = 200;
			sun.color = 0xffff00;
			sun.x= _stage.stageWidth / 2;
			sun.y= _stage.stageHeight / 2;
			sun.emitsLight =  true;
			sun.lightRad= 9000;
			sun.lightAngleDelta= 0.01; //0.03 is the smallest that still runs in normal fps
			sun.orbitingPlanets = new Vector.<Planet>();
			sun.orbitingPlanets.push(mercury);
			sun.orbitingPlanets.push(venus);
			sun.orbitingPlanets.push(earth);
			sun.orbitingPlanets.push(mars);
			sun.orbitingPlanets.push(jupiter);
			sun.orbitingPlanets.push(saturn);
			sun.orbitingPlanets.push(uranus);
			sun.orbitingPlanets.push(neptune); //Utils.duplicate
			sun.name = "sun"
			
		}



	}

}