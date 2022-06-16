package {
	import flash.display.*;
	import flash.text.TextField;

	public class Model {

		public var mercury: Object;
		public var venus: Object;
		public var earth: Object;
		public var mars: Object;
		public var jupiter: Object;
		public var saturn: Object;
		public var uranus: Object;
		public var neptune: Object;
		public var sun: Object;
		public var layerS: Sprite = new Sprite();
		public var layerT: Sprite = new Sprite();
		public var layer0: Sprite = new Sprite();
		public var layer05: Sprite = new Sprite();
		public var layer1: Sprite = new Sprite();
		public var debugLayer: Sprite = new Sprite();
		public var allPlanets: Array = [];
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
			// constructor code
			/*
		Mercury - 0
		Venus - 0
		Earth - 1
		Mars - 2
		Jupiter - 79 (53 confirmed, 26 provisional)
		Saturn - 82 (53 confirmed, 29 provisional)
		Uranus - 27
		Neptune - 14
		

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
			layers = [layerS, layerT, layer0, layer05, layer1, debugLayer];

			mercury = {
				radius: 30,
				color: 0xffffff * Math.random(),
				distanceFromParent: 300,
				angle: Math.random() * (Math.PI * 2),
				showOrbit: false,
				name: "mercury"
			}

			venus = {
				radius: 35,
				color: 0xffffff * Math.random(),
				distanceFromParent: 600,
				angle: Math.random() * (Math.PI * 2),
				//speed: Utils.getSpeed(),
				showOrbit: false,
				name: "venus"
			}

			earth = {
				radius: 40,
				color: 0xffffff * Math.random(),
				distanceFromParent: 1000,
				angle: 0, //Math.random() * (Math.PI * 2),
				orbitingPlanets: [],
				showOrbit: false,
				numMoons: 1,

				name: "earth"
			}


			mars = {
				radius: 20,
				color: 0xffffff * Math.random(),
				distanceFromParent: 1500,
				angle: Math.random() * (Math.PI * 2),
				orbitingPlanets: [],
				showOrbit: false,
				numMoons: 2,
				name: "mars"
			}

			jupiter = {
				radius: 100,
				color: 0xffffff * Math.random(),
				distanceFromParent: 2500,
				angle: Math.random() * (Math.PI * 2),
				showOrbit: false,
				numMoons: 4,
				name: "jupiter"
			}

			saturn = {
				radius: 120,
				color: 0xffffff * Math.random(),
				distanceFromParent: 5000,
				angle: Math.random() * (Math.PI * 2),
				//speed: Utils.getSpeed(),
				rings: [Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff, Math.random() * 0xffffff],
				orbitingPlanets: [],
				showOrbit: false,
				numMoons: 12,
				name: "saturn"
			}



			uranus = {
				radius: 18,
				color: 0xffffff * Math.random(),
				distanceFromParent: 6000,
				angle: Math.random() * (Math.PI * 2),
				//speed: Utils.getSpeed(),
				orbitingPlanets: [],
				numMoons: 3,
				showOrbit: false,
				name: "uranus"
			}

			neptune = {
				radius: 18,
				color: 0xffffff * Math.random(),
				distanceFromParent: 7000,
				angle: Math.random() * (Math.PI * 2),
				//speed: Utils.getSpeed(),
				orbitingPlanets: [],
				showOrbit: false,
				numMoons: 4,
				name: "neptune"
			}


			sun = {
				radius: 200,
				color: 0xffff00,
				x: _stage.stageWidth / 2,
				y: _stage.stageHeight / 2,
				emitsLight: true,
				lightRad: 9000,
				lightAngleDelta: 0.01, //0.03 is the smallest that still runs in normal fps

				orbitingPlanets: [
					Utils.duplicate(mercury),
					Utils.duplicate(venus),
					Utils.duplicate(earth),
					Utils.duplicate(mars),
					Utils.duplicate(jupiter),
					Utils.duplicate(saturn),
					Utils.duplicate(uranus),
					Utils.duplicate(neptune)
				],
				name: "sun"
			}
		}



	}

}